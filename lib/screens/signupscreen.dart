import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/helper.dart';
import 'package:culturize/methods.dart';
import 'package:culturize/model.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/homepage.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name = '';
  bool _isLoading = false;
  String username = '';
  String email = '';
  String password = '';
  String cpassword = '';
  bool pvisibility = false;
  bool cpvisibility = false;
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Join Us!",
                    style: GoogleFonts.raleway(
                      color: red,
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.07,
                    ),
                  ),
                  Text(
                    "Join our community of culture enthusiasts today and start your journey towards mastering your craft!",
                    style: GoogleFonts.raleway(
                      color: grey1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: size.width * 0.07,
                  ),
                  //name field starts her
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: grey2,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            name = val;
                          },
                          keyboardType: TextInputType.name,
                          cursorColor: grey3,
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                          decoration: InputDecoration(
                              fillColor: grey3,
                              border: InputBorder.none,
                              hintText: "Harsha Voleti",
                              hintStyle: GoogleFonts.raleway(
                                fontSize: size.width * 0.03,
                              )

                              // labelText: "mobile",
                              ),
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                    ],
                  ),
                  //name field ends here
                  //username field starts here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: grey2,
                          borderRadius: BorderRadius.circular(4),
                          
                        ),
                        
                        child: TextFormField(
                          onChanged: (val) {
                            username = val;
                          },
                          keyboardType: TextInputType.name,
                          cursorColor: grey3,
                          // validator: (value) async {
                          //   if (value.isEmpty) {
                          //     return 'Please enter a username';
                          //   }

                          //   bool isTaken = await isUsernameTaken(value);

                          //   if (isTaken) {
                          //     return 'Username is already taken';
                          //   }

                          //   return null;
                          // },
                          decoration: InputDecoration(
                              fillColor: grey3,
                              border: InputBorder.none,
                              hintText: "harshavoleti",
                              hintStyle: GoogleFonts.raleway(
                                fontSize: size.width * 0.03,
                              )

                              // labelText: "mobile",
                              ),
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                    ],
                  ),
                  //username field ends here
                  //email field starts here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email ID",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: grey2,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            email = val;
                          },
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: grey3,
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please enter a valid email";
                          },
                          decoration: InputDecoration(
                              fillColor: grey3,
                              border: InputBorder.none,
                              hintText: "mailharshavoleti@gmail.com",
                              hintStyle: GoogleFonts.raleway(
                                fontSize: size.width * 0.03,
                              )

                              // labelText: "mobile",
                              ),
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.05,
                      ),
                    ],
                  ),
                  //email field ends here

                  //password field starts here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: grey2,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            password = val;
                          },
                          obscureText: !pvisibility,
                          cursorColor: grey3,
                          decoration: InputDecoration(
                            fillColor: grey3,
                            border: InputBorder.none,
                            suffixIconColor: grey3,
                            suffixIcon: IconButton(
                              icon: pvisibility
                                  ? Icon(Icons.visibility)
                                  : Icon(
                                      Icons.visibility_off,
                                    ),
                              onPressed: () {
                                setState(() {
                                  pvisibility = !pvisibility;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //password field ends here
                  SizedBox(
                    height: size.width * 0.05,
                  ),
                  //confirm password field starts here
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Confirm Password",
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: grey2,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: TextFormField(
                          onChanged: (val) {
                            cpassword = val;
                          },
                          obscureText: !cpvisibility,
                          cursorColor: grey3,
                          decoration: InputDecoration(
                            fillColor: grey3,
                            border: InputBorder.none,
                            suffixIconColor: grey3,
                            suffixIcon: IconButton(
                              icon: cpvisibility
                                  ? Icon(Icons.visibility)
                                  : Icon(
                                      Icons.visibility_off,
                                    ),
                              onPressed: () {
                                setState(() {
                                  cpvisibility = !cpvisibility;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //confirm password field ends here
                  SizedBox(
                    height: size.width * 0.1,
                  ),
                  //submit button starts here
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: size.width * 0.10,
                      width: size.width * 0.38,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(red),
                        ),
                        onPressed: () {
                          register();
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.raleway(
                            fontSize: size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //submit button ends here
                  SizedBox(
                    height: size.width * 0.075,
                  ),
                  //login button starts here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.raleway(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.raleway(
                            color: red,
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.04,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> isUsernameTaken(String username) async {
    bool taken = false;

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      taken = true;
    }

    return taken;
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(name, email, password, username)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(username);
          await HelperFunctions.saveNameSF(name);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
          // saving the shared preference state
        } else {
          showsnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
