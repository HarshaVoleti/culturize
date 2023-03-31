import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/chatScreen.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchcontroller = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Search",
          style: GoogleFonts.raleway(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.w600,
            color: blue,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height * 0.7),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: grey5,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: searchcontroller,
                onChanged: (value) {
                  initiateSearchMethod();
                },
                onSubmitted: (value) {
                  initiateSearchMethod();
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: grey6,
                    ),
                    hintText: "Search 'Pottery'"),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          searchcontroller.text != ''
              ? Container(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : groupList(),
                )
              : Center(
                  child: Text("search results will be shown here"),
                ),
          Container(
            child: Text("join or exit the Communities here"),
          ),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchcontroller.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchcontroller.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  joinedOrNot(String userName, String groupId, String groupname) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupname, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupID'],
                searchSnapshot!.docs[index]['groupName'],
                // searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  Widget groupTile(String userName, String groupId, String groupName) {
    // function to check whether user already exists in group
    joinedOrNot(
      userName,
      groupId,
      groupName,
    );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: grey2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: red,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),

          title: Text(groupName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          // subtitle: Text("Admin: ${getName(admin)}"),
          trailing: InkWell(
            onTap: () async {
              await DatabaseService(uid: user!.uid)
                  .toggleGroupJoin(groupId, userName, groupName);
              if (isJoined) {
                setState(() {
                  isJoined = !isJoined;
                });
                showsnackbar(
                    context, Colors.green, "Successfully joined the group");
                Future.delayed(
                  const Duration(seconds: 2),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            groupID: groupId,
                            groupName: groupName,
                            username: userName),
                      ),
                    );
                  },
                );
              } else {
                setState(() {
                  isJoined = !isJoined;
                  showsnackbar(
                      context, Colors.red, "Left the group $groupName");
                });
              }
            },
            child: isJoined
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text(
                      "Joined",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: red,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: const Text("Join Now",
                        style: TextStyle(color: Colors.white)),
                  ),
          ),
        ),
      ),
    );
  }
}
