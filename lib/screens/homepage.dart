import 'package:culturize/pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activetab = 0;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isverified = false;
  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return  Scaffold(
      body: getbody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getbody() {
    return IndexedStack(index: activetab, children: pages);
  }

  Widget getFooter() {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: blue,
      ),
      height: size.height * 0.1,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(navbar.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                activetab == index
                    ? Container(
                        width: 10,
                        height: 5,
                        decoration: BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                      )
                    : Container(
                        width: 15,
                        height: 5,
                      ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      activetab = index;
                    });
                  },
                  child: Container(
                    height: 30,
                    width: size.width * 0.2,
                    child: SvgPicture.asset(
                      navicons[index],
                      color: activetab == index ? red : Colors.white,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Text(
                  pagenames[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: activetab == index ? red : Colors.white,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
