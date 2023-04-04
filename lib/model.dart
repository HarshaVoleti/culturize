import 'package:culturize/pages.dart';
import 'package:culturize/screens/profilepage.dart';
import 'package:flutter/material.dart';

Color red = Color.fromRGBO(254, 86, 103, 1);

Color bgblue = Color.fromRGBO(12, 18, 54, 0.5);

Color grey1 = Color.fromRGBO(137, 137, 137, 1);
Color grey2 = Color.fromRGBO(217, 217, 217, 1);
Color grey3 = Color.fromRGBO(149, 149, 149, 1);
Color grey4 = Color.fromRGBO(235, 235, 235, 1);
Color grey5 = Color.fromRGBO(217, 217, 217, 0.5);
Color grey6 = Color.fromRGBO(184, 184, 184, 1);
Color blue = Color.fromRGBO(12, 18, 54, 1);
Color bgblack = Color.fromRGBO(0, 0, 0, 0.4);

List images = [
  'assets/images/cimage2.png',
  'assets/images/cimage1.png',
  'assets/images/cimage3.png',
];

List navicons = [
  "assets/icons/learn.svg",
  "assets/icons/search.svg",
  "assets/icons/Community.svg",
  "assets/icons/profile.svg",
];

List navbar = [
  Icons.home,
  Icons.search,
  Icons.library_books,
  Icons.settings,
];

List<Widget> pages = [
  const LearnPage(),
  const SearchPage(),
  const CommunityPage(),
  const ProfileScreen(),
];

List pagenames = [
  'Learn',
  'Search',
  'Community',
  'Profile',
];

List textblogs = [
  {
    'name': 'The Art of Pottery: Techniques and Inspirations',
    'label': [
      'Section 1: Techniques of Pottery',
      'Section 2: Inspirations for Pottery'
    ],
    'description': [
      'The art of pottery is a centuries-old practice that has captivated artisans and enthusiasts alike with its beauty and intricacy. Pottery is a form of art that involves shaping and molding clay into functional or decorative objects, such as cups, vases, bowls, and more. Pottery can be created using various techniques, each of which requires different levels of skill and mastery. \n One of the most popular pottery techniques is hand-building, which involves creating pottery using only your hands and simple tools. This technique allows artists to explore their creativity and create unique, one-of-a-kind pieces. Another popular technique is wheel throwing, which involves using a pottery wheel to shape and form the clay into a desired',
      'Pottery is one of the oldest crafts in human history. It involves the shaping of clay into various forms, which are then hardened by firing in a kiln. Here are some techniques that are commonly used in the art of pottery: \n Handbuilding: This technique involves shaping the clay with your hands, using techniques such as pinch pots, coil pots, and slab building. This is a great technique for beginners who are just starting out in pottery. \n Wheel-throwing: This technique involves using a pottery wheel to create shapes such as bowls, vases, and plates. It requires more skill and practice than handbuilding, but it allows for greater precision and control over the final product. \n Glazing: Glazing is the process of applying a coating of liquid glass to the pottery before firing it in a kiln. This adds color and texture to the finished product, and also makes it more durable. \n Firing: Firing is the process of heating the pottery in a kiln to harden it. There are two types of firing: bisque firing, which hardens the clay and prepares it for glazing, and glaze firing, which hardens the glaze and creates a glossy finish.',
    ],
    'img': 'assets/images/textblogimg1.png',
  },
  {
    'name': 'Discovering Ayurveda: Traditional Healing for Modern World',
    'label': [
      'Section 1: Introduction to Ayurveda',
      'Section 2: The Benefits of Ayurveda',
    ],
    'description': [
      'The art of pottery is a centuries-old practice that has captivated artisans and enthusiasts alike with its beauty and intricacy. Pottery is a form of art that involves shaping and molding clay into functional or decorative objects, such as cups, vases, bowls, and more. Pottery can be created using various techniques, each of which requires different levels of skill and mastery. \n One of the most popular pottery techniques is hand-building, which involves creating pottery using only your hands and simple tools. This technique allows artists to explore their creativity and create unique, one-of-a-kind pieces. Another popular technique is wheel throwing, which involves using a pottery wheel to shape and form the clay into a desired',
      'Pottery is one of the oldest crafts in human history. It involves the shaping of clay into various forms, which are then hardened by firing in a kiln. Here are some techniques that are commonly used in the art of pottery: \n Handbuilding: This technique involves shaping the clay with your hands, using techniques such as pinch pots, coil pots, and slab building. This is a great technique for beginners who are just starting out in pottery. \n Wheel-throwing: This technique involves using a pottery wheel to create shapes such as bowls, vases, and plates. It requires more skill and practice than handbuilding, but it allows for greater precision and control over the final product. \n Glazing: Glazing is the process of applying a coating of liquid glass to the pottery before firing it in a kiln. This adds color and texture to the finished product, and also makes it more durable. \n Firing: Firing is the process of heating the pottery in a kiln to harden it. There are two types of firing: bisque firing, which hardens the clay and prepares it for glazing, and glaze firing, which hardens the glaze and creates a glossy finish.',
    ],
    'img': 'assets/images/textblogimg1.png',
  },
];

class UserModel {
  late String uid;
  late String fullName;
  late String email;
  late String profilepic;
  late String username;
  late String password;
  late List groups;

  UserModel({
    required this.email,
    required this.fullName,
    required this.groups,
    required this.password,
    required this.profilepic,
    required this.uid,
    required this.username,
  });

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      fullName: map['fullName'],
      groups: map['groups'],
      password: map['password'],
      profilepic: map['profilePic'],
      uid: map['uid'],
      username: map['username'],
    );
  }
}
