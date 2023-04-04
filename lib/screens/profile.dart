import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";
  String name = "";
  String profilepic = "";
  Stream? groups;
  get groupId => null;

  File? _image;

  final imagePicker = ImagePicker();
  String? downloadURL;

  Future imagePickerGallery() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showsnackbar(
          context,
          red,
          "No File selected",
        );
      }
    });
  }

  Future imagePickerCamera() async {
    final pick = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showsnackbar(
          context,
          red,
          "No File selected",
        );
      }
    });
  }

  Future uploadImage(File _image) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('${username}')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'profilePic': downloadURL,
      },
    );
    setState(() {
      profilepic = downloadURL!;
    });
  }

  Future removeImage() async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // cloud firestore
    await firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'profilePic': "",
      },
    );
    setState(() {
      profilepic = "";
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
    getProfilePic();
    // getCurrentUserIdandName()
    print(username);
    print(email);
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   gettingUserData();
  //   getProfilePic();
  //   print(profilepic);
  //   print(username);
  //   print(email);
  // }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        username = value!;
      });
    });
    await HelperFunctions.getNameFromSF().then((value) {
      setState(() {
        name = value!;
      });
    });

    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
      print(groups.toString());
    });
    print("groups been taken");
  }

  getProfilePic() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      setState(() {
        profilepic = userDoc.get('profilePic');
      });
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 20, top: 80),
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        alignment: Alignment.center,
                        child: Row(
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: size.width * 0.594,
                                    child: Text(
                                      name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: SizedBox(
                                    width: size.width * 0.594,
                                    child: Text(
                                      email,
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.w600,
                                        color: grey3,
                                      ),
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
                    ],
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 5,
                  ),
                  child: Container(
                    height: 40,
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
                            "Posts",
                            style: GoogleFonts.raleway(
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Your Communities",
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
                  child: TabBarView(
                    children: [
                      Center(
                        child: Text("tab 2"),
                      ),
                      GroupsList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GroupsList() {
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
              itemCount: groupDocs.length,
              itemBuilder: (BuildContext context, int index) {
                var groupData = groupDocs[index].docs[0].data();
                return Row(
                  children: [
                    Container(
                      // backgroundColor: Colors.white,
                      height: size.width * 0.20,
                      width: size.width * 0.20,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: groupData['groupIcon'] != ""
                            ? DecorationImage(
                                image: NetworkImage(groupData['groupIcon']),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/culturize-a6df3.appspot.com/o/dp.png?alt=media&token=9ba7639d-b890-42b2-957c-65d7d8f15dd4"),
                                fit: BoxFit.fill,
                              ), // Use null-aware operator to conditionally create the FileImage
                      ),
                    ),
                    Text(
                      groupData['groupName'],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
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

  popUpDialog(BuildContext context) {
    final size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                "Select Image from",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // backgroundColor: Colors.white,
                    height: size.width * 0.30,
                    width: size.width * 0.30,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _image != null
                          ? DecorationImage(
                              image: NetworkImage(profilepic),
                              fit: BoxFit.fill,
                            )
                          : DecorationImage(
                              image: AssetImage("assets/images/dp.png"),
                              fit: BoxFit.fill,
                            ), // Use null-aware operator to conditionally create the FileImage
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      imagePickerCamera();
                    },
                    child: Text("Camera"),
                  ),
                  TextButton(
                    onPressed: () {
                      imagePickerGallery();
                    },
                    child: Text("Gallery"),
                  ),
                  TextButton(
                    onPressed: () {
                      removeImage();

                      Navigator.of(context).pop();
                    },
                    child: Text("Remove photo"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      uploadImage(_image!);
                      Navigator.of(context).pop();
                    },
                    child: Text("Upload"),
                  ),
                ],
              ),
            );
          });
        });
  }
}
