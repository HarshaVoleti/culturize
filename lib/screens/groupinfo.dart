import 'package:culturize/pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({
    super.key,
    required this.groupID,
    required this.adminname,
    required this.groupname,
  });
  final String groupID;
  final String groupname;
  final String adminname;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  Stream? members;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getmembers();
  }

  getmembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupID)
        .then(
      (value) {
        setState(
          () {
            members = value;
          },
        );
      },
    );
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupname,
          style: GoogleFonts.raleway(
            color: blue,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            memberslist(size.width),
          ],
        ),
      ),
    );
  }

  memberslist(double size) {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: red,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w500,
                              fontSize: size * 0.1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(
                          getName(
                            snapshot.data['members'][index],
                          ),
                        )),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "no members yet",
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                "no members yet",
              ),
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
