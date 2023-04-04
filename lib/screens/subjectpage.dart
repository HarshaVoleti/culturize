import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/audioblogscreen.dart';
import 'package:culturize/screens/textblogpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({
    super.key,
    required this.subject,
    required this.image,
    required this.description,
    required this.subtitle,
  });
  final String subject;
  final String image;
  final String description;
  final String subtitle;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final CollectionReference audioblogsRef =
      FirebaseFirestore.instance.collection('audioblogs');
  final CollectionReference textblogsRef =
      FirebaseFirestore.instance.collection('TextBlogs');

  //  QuerySnapshot  audioref;
  // Stream? textref;

  // getTextBlogs(String) async {
  //   QuerySnapshot snapshot =
  //       await textblogsRef.where("category", isEqualTo: widget.subject).get();
  //   setState(() {
  //     textref = snapshot;
  //   });
  // }

  // getAudioBlogs(String) async {
  //   QuerySnapshot snapshot1 =
  //       await audioblogsRef.where("category", isEqualTo: widget.subject).get();
  //   setState(() {
  //     audioref = snapshot1;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getTextBlogs(widget.subject);
    // getAudioBlogs(widget.subject);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 40,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Start Learning",
          style: GoogleFonts.raleway(
            fontSize: size.width * 0.06,
            fontWeight: FontWeight.w600,
            color: blue,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: size.width * 0.2,
                    height: size.width * 0.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(widget.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        widget.subject,
                        style: GoogleFonts.raleway(
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.w600,
                          color: blue,
                        ),
                      ),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.raleway(
                          fontSize: size.width * 0.04,
                          fontWeight: FontWeight.w600,
                          color: grey1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                widget.description,
                style: GoogleFonts.raleway(
                  fontSize: size.width * 0.032,
                  fontWeight: FontWeight.w600,
                  color: blue,
                ),
              ),
              //audio blogs starts here
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Blogs",
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
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('TextBlogs')
                          .where('category', isEqualTo: widget.subject)
                          .get(),
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
                                          height: size.width * 0.5,
                                          width: size.width * 0.5,
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
                                                    fontSize:
                                                        size.width * 0.035,
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
                                                        BorderRadius.circular(
                                                            2),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 2,
                                                  ),
                                                  child: Text(
                                                    tblog['category'],
                                                    style: GoogleFonts.raleway(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                  ],
                ),
              ),
              //textblogs end here
              //audio blogs starts here
              Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
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
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('audioblogs')
                          .where('category', isEqualTo: widget.subject)
                          .get(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: size.width * 0.5,
                                          width: size.width * 0.5,
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
                                              horizontal: 0, vertical: 5),
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
      ),
    );
  }
}
