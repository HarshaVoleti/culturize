import 'package:culturize/model.dart';
import 'package:flutter/material.dart';

class TextBlog extends StatefulWidget {
  final String title;
  final List desc;
  final String img;
  final String category;

  const TextBlog({
    super.key,
    required this.title,
    required this.desc,
    required this.img,
    required this.category,
  });

  @override
  State<TextBlog> createState() => _TextBlogState();
}

class _TextBlogState extends State<TextBlog> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(
                  widget.img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(
                  color: grey1,
                  thickness: 0.5,
                  indent: 15,
                  endIndent: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                  child: Column(
                    children: List.generate(
                      widget.desc.length,
                      (index) => Text(
                        widget.desc[index],
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: -15,
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
        ),
      ),
    );
  }
}
