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
    // getCurrentUserIdandName();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    popUpDialog(context);
                  },
                  child: Container(
                    // backgroundColor: Colors.white,
                    height: size.width * 0.40,
                    width: size.width * 0.40,

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
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Username : ",
                            style: GoogleFonts.raleway(
                              color: blue,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            username,
                            style: GoogleFonts.raleway(
                              color: grey4,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Name : ",
                            style: GoogleFonts.raleway(
                              color: blue,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: GoogleFonts.raleway(
                              color: grey4,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email ID : ",
                            style: GoogleFonts.raleway(
                              color: blue,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email,
                            style: GoogleFonts.raleway(
                              color: grey4,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Groups : ",
                            style: GoogleFonts.raleway(
                              color: blue,
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          groupList(),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.vertical,
                          //   child: StreamBuilder(
                          //     stream: groups,
                          //     builder: (context, AsyncSnapshot snapshot) {
                          //       // make some checks
                          //       if (snapshot.hasData) {
                          //         if (snapshot.data['groups'] != null) {
                          //           if (snapshot.data['groups'].length != 0) {
                          //             return ListView.builder(
                          //               itemCount:
                          //                   snapshot.data['groups'].length,
                          //               itemBuilder: (context, index) {
                          //                 int reverseIndex =
                          //                     snapshot.data['groups'].length -
                          //                         index -
                          //                         1;
                          //                 return Text(
                          //                   snapshot.data['groups']
                          //                       [reverseIndex],
                          //                   style: GoogleFonts.raleway(
                          //                     color: blue,
                          //                     fontSize: size.width * 0.05,
                          //                   ),
                          //                 );
                          //               },
                          //             );
                          //           } else {
                          //             return noGroupWidget("not in any group");
                          //           }
                          //         } else {
                          //           return noGroupWidget(
                          //               "You've not joined any groups.");
                          //         }
                          //       } else {
                          //         return noGroupWidget("groups are loading");
                          //       }
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.04,
                ),
                TextButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            content:
                                const Text("Are you sure you want to logout?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await authService.signOut();
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                      (route) => false);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text("log out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  groupList() {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        print("hello");
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              // return noGroupWidget("groups will be shown here");
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    snapshot.data['groups'].length,
                    (index) {
                      int reverseIndex =
                          snapshot.data['groups'].length - index - 1;
                      return Text(
                        snapshot.data['groups'][reverseIndex],
                        style: GoogleFonts.raleway(
                          color: grey4,
                          fontSize: size.width * 0.05,
                        ),
                      );
                    },
                  )
                  // ListView.builder(
                  //   itemCount: snapshot.data['groups'].length,
                  //   itemBuilder: (context, index) {
                  //     int reverseIndex = snapshot.data['groups'].length - index - 1;
                  //     return Text(
                  //       snapshot.data['groups'][reverseIndex],
                  //       style: GoogleFonts.raleway(
                  //         color: blue,
                  //         fontSize: size.width * 0.05,
                  //       ),
                  //     );
                  //   },
                  // ),

                  );
            } else {
              return noGroupWidget("not in any group");
            }
          } else {
            return noGroupWidget("You've not joined any groups.");
          }
        } else {
          print("hello");
          print(snapshot);

          return noGroupWidget("groups are loading");
        }
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
