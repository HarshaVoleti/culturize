import 'package:culturize/model.dart';
import 'package:culturize/screens/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.label,
    required this.inputtype,
    required this.example,
    required this.cont,
    required this.text,
    // required this.validatr,
  });
  String label;
  TextInputType inputtype;
  TextEditingController cont;
  String text;
  String example;
  // Function validatr;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
              text = val;
            },
            controller: cont,
            keyboardType: inputtype,
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
                hintText: example,
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
    );
  }
}

// void showsnackbar(context, color, message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       backgroundColor: color,
//       duration: Duration(seconds: 1),
//     ),
//   );
// }
void showsnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            groupID: widget.groupId,
            groupName: widget.groupName,
            username: widget.userName,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: red,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String name;
  final String username;
  final String email;
  final String photoUrl;

  UserCard(
      {required this.name,
      required this.username,
      required this.email,
      required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Expanded(
          //   child: Image.network(
          //     photoUrl,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //     textblogs[index]['img'],
                    //   ),
                    //   fit: BoxFit.fill,
                    // ),
                    color: bgblue,
                  ),
                  child: Container(
                    // constraints: const BoxConstraints.tightForFinite(
                    //   100,
                    //   100,
                    // ),
                    // height: 100,
                    // width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: bgblack,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: red,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.raleway(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 2,
                          ),
                          child: Text(
                            "Join",
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
        ],
      ),
    );
  }
}


// class CustomTextField1 extends StatelessWidget {
//   CustomTextField1({
//     super.key,
//     required this.label,
//     required this.inputtype,
//     required this.example,
//     required this.func,
//     required this.text,
//     // required this.validatr,
//   });
//   String label;
//   TextInputType inputtype;
//   String text;
//   String example;
//   String func;
//   // Function validatr;

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.raleway(
//             fontWeight: FontWeight.w700,
//             fontSize: size.width * 0.04,
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           decoration: BoxDecoration(
//             color: grey2,
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: TextFormField(
//             onChanged: (val) {
//               text = val;
//             },
//             keyboardType: inputtype,
//             cursorColor: grey3,
//             validator: (val) {
//               func;
//             },
//             decoration: InputDecoration(
//                 fillColor: grey3,
//                 border: InputBorder.none,
//                 hintText: example,
//                 hintStyle: GoogleFonts.raleway(
//                   fontSize: size.width * 0.03,
//                 )

//                 // labelText: "mobile",
//                 ),
//           ),
//         ),
//         SizedBox(
//           height: size.width * 0.05,
//         ),
//       ],
//     );
//   }
// }
