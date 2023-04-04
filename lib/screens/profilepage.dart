import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String profilepic = "";
  String username = "";
  String email = "";
  String name = "";

  getUserData() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      setState(() {
        profilepic = userDoc.get('profilePic');
        name = userDoc.get('fullName');
        username = userDoc.get("username");
        email = userDoc.get("email");
      });
    } else {
      return "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Profile",
            style: GoogleFonts.raleway(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.w600,
              color: blue,
            ),
          ),
        ),
        // backgroundColor: grey1,
        body: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Container(
                width: size.width - 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      // backgroundColor: Colors.white,
                      height: size.width * 0.27,
                      width: size.width * 0.27,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: profilepic != ""
                            ? DecorationImage(
                                image: NetworkImage(profilepic),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/culturize-a6df3.appspot.com/o/dp.png?alt=media&token=9ba7639d-b890-42b2-957c-65d7d8f15dd4"),
                                fit: BoxFit.fill,
                              ), // Use null-aware operator to conditionally create the FileImage
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.594,
                          child: Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        SizedBox(
                          width: size.width * 0.59,
                          child: Text(
                            email,
                            style: TextStyle(
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w600,
                              color: grey3,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Edit Profile",
                            style: GoogleFonts.raleway(
                              color: red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),

              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(
                  // horizontal: 20,
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
                          "Posts",
                          style: GoogleFonts.raleway(
                            fontSize: size.width * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(
                    children: [
                      Container(
                        child: GroupsList(),
                      ),
                      Center(child: Text("You haven't posted anything yet")),
                    ],
                  ),
                ),
              ),

              // TabBarView(
              //   children: [
              //     Text("tab1"),
              //     GroupsList(),
              //   ],
              // ),
            ],
          ),
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
                );
              },
            );
          },
        );
      },
    );
  }
}
