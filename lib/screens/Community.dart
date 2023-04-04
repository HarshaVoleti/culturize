import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/chatScreen.dart';
import 'package:culturize/screens/communitypage.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  String username = "";
  String email = "";
  Stream? groups;
  String groupName = "";
  bool isJoined = false;
  bool _isLoading = false;

  get groupId => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
    getCurrentUserIdandName();
    print(username);
    print(email);
  }

  String userName = "";
  // bool isJoined = false;
  User? user;

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

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        username = value!;
      });
    });

    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });

    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('groups');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int? sliding = 0;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Connect to learn",
            textHeightBehavior: TextHeightBehavior(
              applyHeightToFirstAscent: true,
              applyHeightToLastDescent: true,
            ),
            style: GoogleFonts.raleway(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w600,
              color: blue,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(AppBar().preferredSize.height * 0.7),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: grey4,
                ),
                child: TabBar(
                  labelStyle: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: GoogleFonts.raleway(),
                  labelColor: Colors.white,
                  unselectedLabelColor: blue,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: red,
                  ),
                  tabs: [
                    Tab(
                      child: Text(
                        "Your Communities",
                        style: GoogleFonts.raleway(
                          fontSize: size.width * 0.035,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Top Communities",
                        style: GoogleFonts.raleway(
                          fontSize: size.width * 0.035,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          centerTitle: false,
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GroupsList(),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: usersRef.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.all(5),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 5 / 6.5
                        // childAspectRatio: size.height * 0.34 / size.width,
                        ),
                    itemBuilder: (context, index) {
                      final group = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommunityDetailsPage(
                                        id: group['groupID'],
                                      )));
                        },
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: size.height * 0.282,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        group['groupIcon'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    // color: red,
                                  ),
                                  child: Container(
                                    // constraints: const BoxConstraints.tightForFinite(
                                    //   100,
                                    //   100,
                                    // ),
                                    // height: 100,
                                    // width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: bgblack,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  right: 8,
                                  child: Container(
                                    height: size.height * 0.131,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: red,
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: size.width * 0.07,
                                        ),
                                        Text(
                                          group['groupName'],
                                          // maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: GoogleFonts.raleway(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 2,
                                          ),
                                          child: InkWell(
                                            onTap: () async {},
                                            child: Text(
                                              "View",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.282,
                                  child: Center(
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        group['groupIcon'],
                                      ),
                                      radius: size.width * 0.1,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget GroupsList() {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        var userGroups = snapshot.data!['groups'];
        return FutureBuilder(
          future: Future.wait((userGroups as List<dynamic>)
              .map((groupName) => FirebaseFirestore.instance
                  .collection('groups')
                  .where('groupName', isEqualTo: groupName)
                  .get())
              .toList() as Iterable<Future>),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var groupDocs = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(0),
              // shrinkWrap: true,
              itemCount: groupDocs.length,
              itemBuilder: (BuildContext context, int index) {
                var groupData = groupDocs[index].docs[0].data();
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            groupID: groupData['groupID'],
                            groupName: groupData["groupName"],
                            username: username,
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          // backgroundColor: Colors.white,
                          height: size.width * 0.15,
                          width: size.width * 0.15,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: groupData['groupIcon'] != ""
                                ? DecorationImage(
                                    image: NetworkImage(groupData['groupIcon']),
                                    fit: BoxFit.fitHeight,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                        "https://firebasestorage.googleapis.com/v0/b/culturize-a6df3.appspot.com/o/dp.png?alt=media&token=9ba7639d-b890-42b2-957c-65d7d8f15dd4"),
                                    fit: BoxFit.fill,
                                  ), // Use null-aware operator to conditionally create the FileImage
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          groupData['groupName'],
                          style: GoogleFonts.raleway(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              groupName = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(username,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showsnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              // return noGroupWidget(" joined any groups.");
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(
                    groupId: snapshot.data['groups'][reverseIndex],
                    groupName: snapshot.data['groups'][reverseIndex],
                    userName: snapshot.data['fullName'],
                  );
                },
              );
            } else {
              return noGroupWidget("You've joined any groups.");
            }
          } else {
            return noGroupWidget("no groups.");
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
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

  noGroupWidget(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
