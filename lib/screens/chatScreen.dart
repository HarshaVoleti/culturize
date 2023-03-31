import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:culturize/pages.dart';
import 'package:culturize/screens/groupinfo.dart';
import 'package:culturize/screens/messageTile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.groupID,
    required this.groupName,
    required this.username,
  });

  final String groupID;
  final String groupName;
  final String username;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserandAdmin();
  }

  getUserandAdmin() {
    DatabaseService().getChats(widget.groupID).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: blue, // Set your desired color here
        ),
        leadingWidth: size.width * 0.05,
        title: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupInfoScreen(
                  groupID: widget.groupID,
                  groupname: widget.groupName,
                  adminname: admin,
                ),
              ),
            );
          },
          child: Text(
            widget.groupName,
            style: GoogleFonts.raleway(
              color: blue,
              fontSize: size.width * 0.06,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Exit"),
                      content: const Text("Are you sure you exit the group? "),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .toggleGroupJoin(widget.groupID,
                                    widget.username, widget.groupName)
                                .whenComplete(() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
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
            icon: Icon(
              Icons.logout,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        centerTitle: false,
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here

          chatMessages(),
          // SizedBox(
          //   height: 500,
          // ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 30),
              width: MediaQuery.of(context).size.width,
              color: blue,
              child: Row(children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    color: grey5,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  child: TextFormField(
                    controller: messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Send a message...",
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: grey5,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  // Widget chatMessages() {
  //   final size = MediaQuery.of(context).size;
  //   return StreamBuilder(
  //     stream: chats,
  //     builder: (context, AsyncSnapshot snapshot) {
  //       int count = snapshot.data.docs[index;
  //       return snapshot.hasData
  //           ? Column(
  //               children: [
  //                 Container(
  //                   height: size.height * 0.8,
  //                   child: ListView.builder(
  //                     itemCount: count,
  //                     itemBuilder: (context, index) {
  //                       return MessageTile(
  //                           message: snapshot.data.docs[index]['message'],
  //                           sender: snapshot.data.docs[index]['sender'],
  //                           sentByMe: widget.username ==
  //                               snapshot.data.docs[index]['sender']);
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             )
  //           : Container();
  //     },
  //   );
  // }

  Widget chatMessages() {
    final size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Column(
                children: [
                  Container(
                    height: size.height * 0.795,
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return MessageTile(
                            message: snapshot.data.docs[index]['message'],
                            sender: snapshot.data.docs[index]['sender'],
                            sentByMe: widget.username ==
                                snapshot.data.docs[index]['sender']);
                      },
                    ),
                  ),
                ],
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.username,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupID, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
