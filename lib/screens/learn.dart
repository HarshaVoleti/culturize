import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/methods.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/audioblogscreen.dart';
import 'package:culturize/screens/textblogpage.dart';
import 'package:culturize/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService authService = AuthService();
  String _username = "";
  String _name = "";
  String _email = "";
  final CollectionReference audioblogsRef =
      FirebaseFirestore.instance.collection('audioblogs');
  final CollectionReference textblogsRef =
      FirebaseFirestore.instance.collection('TextBlogs');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
    print(_username);
    print(_email);
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        _username = value!;
      });
    });
    await HelperFunctions.getNameFromSF().then((value) {
      setState(() {
        _name = value!;
      });
    });

    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        _email = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String? name = _auth.currentUser!.displayName;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: RichText(
          text: TextSpan(
            text: "Hello! ",
            style: GoogleFonts.raleway(
              fontSize: size.width * 0.055,
              fontWeight: FontWeight.w600,
              color: blue,
            ),
            children: [
              TextSpan(
                text: _name,
                style: GoogleFonts.raleway(
                  fontSize: size.width * 0.055,
                  color: red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [
          SvgPicture.asset(
            'assets/icons/notification.svg',
            height: size.width * 0.07,
          ),
          SizedBox(
            width: size.width * 0.05,
          ),
          SvgPicture.asset(
            'assets/icons/settings.svg',
            height: size.width * 0.07,
          ),
          SizedBox(
            width: size.width * 0.05,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CarouselSlider(
                items: images
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage(e),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: bgblack,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Culture That \n Inspires",
                                      style: GoogleFonts.raleway(
                                        fontSize: size.width * 0.055,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(red),
                                      ),
                                      child: Text(
                                        "Start learning",
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.1,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Know about culture",
                        style: GoogleFonts.raleway(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "View all",
                          style: GoogleFonts.raleway(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: textblogsRef.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            snapshot.data!.docs.length,
                            (index) {
                              final tblog = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextBlog(
                                          title: snapshot.data!.docs[index]
                                              ['Title'],
                                          img: snapshot.data!.docs[index]
                                              ['image'],
                                          desc: snapshot.data!.docs[index]
                                              ['desc'],
                                          category: snapshot.data!.docs[index]
                                              ['category'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 210,
                                        width: 210,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              tblog['image'],
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Container(
                                          // constraints: const BoxConstraints.tightForFinite(
                                          //   100,
                                          //   100,
                                          // ),
                                          // height: 100,
                                          // width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: bgblack,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        right: 8,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: red,
                                          ),
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tblog['Title'],
                                                style: GoogleFonts.raleway(
                                                  fontSize: size.width * 0.035,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 2,
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
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
                                                child: Text(
                                                  tblog['category'],
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: List.generate(
                  //       textblogs.length,
                  //       (index) => Padding(
                  //         padding: const EdgeInsets.only(right: 20),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             // Navigator.push(
                  //             //     context,
                  //             // MaterialPageRoute(
                  //             //   builder: (context) => TextBlog(
                  //             //     label: textblogs[index]['label'],
                  //             //     desc: textblogs[index]['description'],
                  //             //     img: textblogs[index]['img'],
                  //             //     title: textblogs[index]['name'],
                  //             //   ),
                  //             // ));
                  //           },
                  //           child: Stack(
                  //             children: [
                  //               Container(
                  //                 height: 210,
                  //                 width: 210,
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.circular(6),
                  //                   image: DecorationImage(
                  //                     image: AssetImage(
                  //                       textblogs[index]['img'],
                  //                     ),
                  //                     fit: BoxFit.fill,
                  //                   ),
                  //                 ),
                  //                 child: Container(
                  //                   // constraints: const BoxConstraints.tightForFinite(
                  //                   //   100,
                  //                   //   100,
                  //                   // ),
                  //                   // height: 100,
                  //                   // width: 100,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: bgblack,
                  //                   ),
                  //                 ),
                  //               ),
                  //               Positioned(
                  //                 bottom: 8,
                  //                 left: 8,
                  //                 right: 8,
                  //                 child: Container(
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: red,
                  //                   ),
                  //                   padding: EdgeInsets.all(5),
                  //                   child: Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceEvenly,
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         textblogs[index]['name'],
                  //                         style: GoogleFonts.raleway(
                  //                           fontSize: size.width * 0.035,
                  //                           fontWeight: FontWeight.bold,
                  //                           color: Colors.white,
                  //                         ),
                  //                       ),
                  //                       Container(
                  //                         decoration: BoxDecoration(
                  //                           color: Colors.white,
                  //                           borderRadius:
                  //                               BorderRadius.circular(2),
                  //                         ),
                  //                         padding: EdgeInsets.symmetric(
                  //                           horizontal: 20,
                  //                           vertical: 2,
                  //                         ),
                  //                         child: Text(
                  //                           "Potery",
                  //                           style: GoogleFonts.raleway(
                  //                             fontSize: 12,
                  //                             fontWeight: FontWeight.w600,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // audio blogs start here
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Audio Blogs",
                        style: GoogleFonts.raleway(
                          fontSize: size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: blue,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "View all",
                          style: GoogleFonts.raleway(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: audioblogsRef.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            snapshot.data!.docs.length,
                            (index) {
                              final blog = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AudioBlogScreen(
                                          title: snapshot.data!.docs[index]
                                              ['Title'],
                                          img: snapshot.data!.docs[index]
                                              ['image'],
                                          url: snapshot.data!.docs[index]
                                              ['url'],
                                          category: snapshot.data!.docs[index]
                                              ['category'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 210,
                                        width: 210,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              snapshot.data!.docs[index]
                                                  ['image'],
                                            ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Container(
                                          // constraints: const BoxConstraints.tightForFinite(
                                          //   100,
                                          //   100,
                                          // ),
                                          // height: 100,
                                          // width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: bgblack,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        width: 220,
                                        child: Text(
                                          snapshot.data!.docs[index]['Title'],
                                          maxLines: 2,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
