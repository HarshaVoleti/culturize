// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:culturize/pages.dart';
// import 'package:culturize/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:crop_image/crop_image.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';

// class AddPost extends StatefulWidget {
//   const AddPost({super.key});

//   @override
//   State<AddPost> createState() => _AddPostState();
// }

// class _AddPostState extends State<AddPost> {
//   File? _image;
//   File? postImage;
//   final _picker = ImagePicker();
//   String? downloadURL;
//   CropController controller = CropController(aspectRatio: 3 / 4);
//   String profilepic = "";
//   String username = "";
//   String email = "";
//   String name = "";
//   String caption = "";

//   getUserData() async {
//     final userRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(FirebaseAuth.instance.currentUser!.uid);
//     final userDoc = await userRef.get();
//     if (userDoc.exists) {
//       setState(() {
//         profilepic = userDoc.get('profilePic');
//         name = userDoc.get('fullName');
//         username = userDoc.get("username");
//         email = userDoc.get("email");
//       });
//     } else {
//       return "";
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _pickImageFromGallery();
//     getUserData();
//   }

//   Future<void> _finished() async {
//     final croppedImage = await ImageCropper().cropImage(
//       sourcePath: _image!.path,
//       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
//       compressQuality: 100,
//       maxWidth: 450,
//       maxHeight: 450,
//       compressFormat: ImageCompressFormat.jpg,
//       aspectRatioPresets: [CropAspectRatioPreset.square],
//     );
//     setState(() {
//       postImage = File(croppedImage!.path);
//     });

//     // ignore: use_build_context_synchronously
//   }

//   Future uploadImage(File _image) async {
//     final imgId = DateTime.now().millisecondsSinceEpoch.toString();
//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     Reference reference = FirebaseStorage.instance
//         .ref()
//         .child('${username}')
//         .child("post_$imgId");

//     await reference.putFile(_image);
//     downloadURL = await reference.getDownloadURL();

//     // cloud firestore
//     await firebaseFirestore.collection("posts").doc(imgId).set(
//       {
//         "url": downloadURL,
//         "caption": caption,
//         "username": username,
//         "time": DateTime.now(),
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           iconSize: size.width * 0.06,
//           color: Colors.black, // set the color of the back button
//           onPressed: () {
//             // go back to the previous screen
//             Navigator.of(context).pop();
//           },
//         ),
//         leadingWidth: 40,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "Add Post",
//           style: GoogleFonts.raleway(
//             fontSize: size.width * 0.06,
//             fontWeight: FontWeight.w600,
//             color: blue,
//           ),
//         ),
//         centerTitle: false,
//         actions: [
//           TextButton(
//             onPressed: () {
//               _finished();
//             },
//             child: Text(
//               "Post",
//               style: GoogleFonts.raleway(
//                 fontSize: size.width * 0.05,
//                 color: blue,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             if (_image != null) ...[
//               Container(
//                 height: 300,
//                 child: Image.file(
//                   postImage!,
//                 ),
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                     onPressed: _pickImageFromCamera,
//                     child: Text("Camera"),
//                   ),
//                   TextButton(
//                     onPressed: _pickImageFromGallery,
//                     child: Text("Gallery"),
//                   ),
//                 ],
//               ),
//               Text("Caption"),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Flexible(
//                   child: Container(
//                     padding: EdgeInsets.all(9),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: blue,
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: TextFormField(
//                       onChanged: (value) {
//                         setState(() {
//                           caption = value;
//                         });
//                       },
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         hintText: "Enter Caption",
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ] else
//               ...[],
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickImageFromCamera() async {
//     final PickedFile? pickedFile =
//         await _picker.getImage(source: ImageSource.camera);
//     setState(() => this._image = File(pickedFile!.path));
//   }

//   Future<void> _pickImageFromGallery() async {
//     try {
//       final PickedFile? pickedFile = await _picker.getImage(
//         source: ImageSource.gallery,
//       );
//       setState(
//         () => this._image = File(pickedFile!.path),
//       );
//     } catch (e) {
//       showsnackbar(context, red, e.toString());
//       Navigator.pop(context);
//     }
//   }
// }
