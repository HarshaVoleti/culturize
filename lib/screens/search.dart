import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/chatScreen.dart';
import 'package:culturize/screens/subjectpage.dart';
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

  late List<DocumentSnapshot> _groups;
  late List<DocumentSnapshot> _subjects;
  late bool _isSearching;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
    _isSearching = false;
    _groups = [];
  }

  void _searchPressed() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchText = '';
    });
  }

  void _searchTextChanged(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  Future<void> _performSearch() async {
    final groups = await FirebaseFirestore.instance
        .collection('groups')
        .where('groupName', isGreaterThanOrEqualTo: _searchText)
        .get();
    final subjects = await FirebaseFirestore.instance
        .collection("Subjects")
        .where('title', isGreaterThanOrEqualTo: _searchText)
        .get();

    setState(() {
      _groups = groups.docs;
      _subjects = subjects.docs;
    });
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
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

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
                  _searchText = value;
                  _performSearch();
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
      body: _buildSearchResults(),
      // body: Column(
      //   children: [
      //     searchcontroller.text != ''
      //         ? Container(
      //             child: isLoading
      //                 ? Center(
      //                     child: CircularProgressIndicator(
      //                         color: Theme.of(context).primaryColor),
      //                   )
      //                 : groupList(),
      //           )
      //         : Center(
      //             child: Text("search results will be shown here"),
      //           ),
      //     Container(
      //       child: Text("join or exit the Communities here"),
      //     ),
      //   ],
      // ),
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
    return isJoined;
  }

  Widget _buildSearchResults() {
    if (_searchText.isEmpty) {
      return const Center(child: Text('Start searching...'));
    }

    if (_groups.isEmpty) {
      return const Center(child: Text('No results found.'));
    }
    final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
    final bottomNavBarHeight = kBottomNavigationBarHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTabController(
          length: 2,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
                  labelColor: blue,
                  indicatorColor: blue,
                  tabs: [
                    Tab(
                      text: "Communities",
                    ),
                    Tab(
                      text: "Subjects",
                    ),
                  ],
                ),
                Flexible(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.67,
                    child: TabBarView(
                      children: [
                        Container(
                          child: grouplist(),
                        ),
                        Container(
                          child: subjectlist(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  subjectlist() {
    final size = MediaQuery.of(context).size;
    return Container(
      child: ListView.builder(
        itemCount: _subjects.length,
        itemBuilder: (BuildContext context, int index) {
          final groupData = _subjects[index].data()!;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: grey2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubjectPage(
                        subject: _subjects[index]['title'],
                        description: _subjects[index]['desc'],
                        image: _subjects[index]['Image'],
                        subtitle: _subjects[index]['subtitle'],
                      ),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  leading: Container(
                    height: size.width * 0.20,
                    width: size.width * 0.20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          _subjects[index]['Image'],
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(
                    _subjects[index]['title'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  grouplist() {
    return Container(
      height: 500,
      child: ListView.builder(
        itemCount: _groups.length,
        itemBuilder: (BuildContext context, int index) {
          final groupData = _groups[index].data()!;
          return groupTile(
              userName,
              _groups[index]['groupID'],
              _groups[index]['groupName'],
              _groups[index]['groupIcon'],
              _groups[index]['members']);
        },
      ),
    );
  }

  // groupList() {
  //   return hasUserSearched
  //       ? ListView.builder(
  //           shrinkWrap: true,
  //           itemCount: searchSnapshot!.docs.length,
  //           itemBuilder: (context, index) {
  //             return groupTile(
  //               userName,
  //               searchSnapshot!.docs[index]['groupID'],
  //               searchSnapshot!.docs[index]['groupName'],
  //               // searchSnapshot!.docs[index]['admin'],
  //             );
  //           },
  //         )
  //       : Container();
  // }

  Widget groupTile(String userName, String groupId, String groupName,
      String image, List members) {
    // function to check whether user already exists in group
    joinedOrNot(
      userName,
      groupId,
      groupName,
    );
    final size = MediaQuery.of(context).size;
    bool joined = members.contains(userName) ? true : false;
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
          leading: Container(
            // backgroundColor: Colors.white,
            height: size.width * 0.20,
            width: size.width * 0.20,

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: image != ""
                  ? DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.fill,
                    )
                  : DecorationImage(
                      image: NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/culturize-a6df3.appspot.com/o/dp.png?alt=media&token=9ba7639d-b890-42b2-957c-65d7d8f15dd4"),
                      fit: BoxFit.fill,
                    ), // Use null-aware operator to conditionally create the FileImage
            ),
          ),

          title: Text(groupName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          // subtitle: Text("Admin: ${getName(admin)}"),
          trailing: InkWell(
            onTap: () async {
              await DatabaseService(uid: user!.uid)
                  .toggleGroupJoin(groupId, userName, groupName);

              if (joined) {
                setState(() {
                  joined = false;
                });
                showsnackbar(context, Colors.red, "Left the group $groupName");
              } else {
                setState(() {
                  joined = true;
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
              }
            },
            child: joined
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
