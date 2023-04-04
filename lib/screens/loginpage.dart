// import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/methods.dart';
import 'package:culturize/model.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/homepage.dart';
import 'package:culturize/screens/signupscreen.dart';
import 'package:culturize/service/database_service.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  String email = "";
  String password = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  bool pvisibility = false;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //carousel starts here
                        CarouselSlider(
                          items: images
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    // padding: EdgeInsets.all(20),
                                    // height: size.height * 0.2,
                                    width: 900,
                                    decoration: BoxDecoration(
                                        // border: Border.all(
                                        //   color: red,
                                        //   width: 2,
                                        // ),

                                        ),
                                    child: Image.asset(
                                      e,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.1,
                            height: size.height * 0.3,
                          ),
                        ),
                        //carousel ends here
                        Text(
                          "Welcome back!",
                          style: GoogleFonts.raleway(
                            color: red,
                            fontWeight: FontWeight.w600,
                            fontSize: size.width * 0.07,
                          ),
                        ),
                        Text(
                          "Ready to continue learning?",
                          style: GoogleFonts.raleway(
                            fontSize: size.width * 0.05,
                            color: grey1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email ID',
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
                                  setState(() {
                                    email = val;
                                  });
                                },
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
                                    hintText: "Emma***@gmail.com",
                                    hintStyle: GoogleFonts.raleway(
                                      fontSize: size.width * 0.03,
                                    )

                                    // labelText: "mobile",
                                    ),
                              ),
                            ),
                          ],
                        ),
                        //email field ends here
                        SizedBox(
                          height: size.width * 0.05,
                        ),
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
                                validator: (val) {
                                  if (val!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
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
                          height: size.width * 0.15,
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
                                login();
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.raleway(
                                  fontSize: size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.width * 0.075,
                        ),
                        //login button starts here
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
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
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                "Sign up",
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

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNameandPassword(email, password).then(
        (value) async {
          if (value == true) {
            print('saving usser data');
            QuerySnapshot snapshot = await DatabaseService(
                    uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
            // saving the values to our shared preferences
            await HelperFunctions.saveUserLoggedInStatus(true);
            print("userloggedinstatus");
            await HelperFunctions.saveUserEmailSF(email);
            print("saveuseremail");
            await HelperFunctions.saveUserNameSF(
              snapshot.docs[0]['username'],
            );
            print("saveusername");
            await HelperFunctions.saveNameSF(
              snapshot.docs[0]['fullName'],
            );
            print("savename");
            print("logged in and moving to home screen");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
            print("logged in ${email}");
          } else {
            showsnackbar(context, Colors.red, value);
            setState(
              () {
                _isLoading = false;
              },
            );
          }
        },
      );
    }
  }
}
