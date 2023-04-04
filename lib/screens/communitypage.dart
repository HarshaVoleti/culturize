import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommunityDetailsPage extends StatefulWidget {
  CommunityDetailsPage({super.key, required this.id});

  final String id;

  @override
  State<CommunityDetailsPage> createState() => _CommunityDetailsPageState();
}

class _CommunityDetailsPageState extends State<CommunityDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Future snapshot = DatabaseService().getGroupData(widget.id);
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('groups')
                .doc(widget.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something went wrong'),
                );
              } else {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var groupData = snapshot.data!;

                return Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display group name and group icon
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.network(
                                  groupData["groupIcon"],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: size.height * 0.25,
                                ),
                                Stack(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 20.0,
                                            right: 20,
                                            top: size.width * 0.12 + 10,
                                          ),
                                          child: Text(
                                            groupData["groupName"],
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                              // top: size.height * 0.195,
                              top: size.height * 0.25 - size.width * 0.12,
                              left: size.width * 0.05,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  groupData['groupIcon'],
                                ),
                                radius: size.width * 0.12,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Join this Community to share your opinion and discuss with your peers about the ${groupData['groupName']}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 5,
                      child: SafeArea(
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: size.height * 0.04,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}
