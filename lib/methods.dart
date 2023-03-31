import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Future<User> createAccount(String name, String email, String password) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   try {
//     User? user = (await _auth.createUserWithEmailAndPassword(
//             email: email, password: password))
//         .user;
//     if (user != null) {
//       print("login successfull");
//       return user;
//     } else {
//       print("account creation failed");
//       return user!;
//     }
//   } catch (e) {
//     print("object");
//     return null!;
//   }
// }

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
      "name": name,
      "email": email,
      "status": "Unavalible",
      "uid": _auth.currentUser!.uid,
      "password": password,
    });
    print(name + email + _auth.currentUser!.uid);
    print("no firebase errors");

    return userCrendetial.user;
  } on FirebaseAuthException catch (e) {
    print(e.message);
    SnackBar(content: Text("logged in"));
    print("error occured while creating account");
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));
    print("Login Sucessfull");

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    });
    print("user logged out");
  } catch (e) {
    print("error");
    print(e.toString());
  }
}

// Future<User?> logIn(String email, String password) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   try {
//     User? user = (await _auth.signInWithEmailAndPassword(
//             email: email, password: password))
//         .user;
//     if (user != null) {
//       print("login successfull");
//       return user;
//     } else {
//       print("login failed");
//       return user;
//     }
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }

// Future logout() async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   try {
//     print("signed out");
//     _auth.signOut();
//   } catch (e) {
//     print(e);
//     return null;
//   }
// }
