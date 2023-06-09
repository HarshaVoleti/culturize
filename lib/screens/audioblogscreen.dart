// import 'package:audioplayers/audioplayers.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:culturize/pages.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AudioBlogScreen extends StatefulWidget {
  AudioBlogScreen({
    super.key,
    required this.title,
    required this.img,
    required this.url,
    required this.category,
  });
  final String img;
  final String url;
  final String title;
  final String category;

  @override
  State<AudioBlogScreen> createState() => _AudioBlogScreenState();
}

class _AudioBlogScreenState extends State<AudioBlogScreen> {
  Duration _duration = new Duration();
  Duration _position = new Duration();

  
  // AudioPlayer audioPlayer = AudioPlayer();

  final player = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupplayer(widget.url);
    // audioPlayer = AudioPlayer();
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    player.seek(newDuration);
  }

  setupplayer(String url) async {
    await player.setSourceUrl(url); // equivalent to setSource(UrlSource(url));
    player.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    player.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    player.onPlayerComplete.listen((p) {
      setState(() {
        isplaying = false;
      });
    });
  }

  bool isplaying = false;
  Duration totalduration = Duration(minutes: 0, seconds: 0);
  Duration current = Duration();

  
  @override
  Widget build(BuildContext context) {
    // equivalent to setSource(UrlSource(url));
    /// Optional

    final size = MediaQuery.of(context).size;
    // Future<Duration?> audioDuration = audioPlayer.getDuration();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        leading: IconButton(
          onPressed: () {
            player.stop();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
        title: Text(
          widget.category,
          style: GoogleFonts.raleway(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      widget.img,
                    ),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                height: size.width * 0.8,
                width: size.width * 0.8,
              ),
            ),
            Text(
              widget.title,
              style: GoogleFonts.raleway(
                fontSize: size.width * 0.06,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                text: "from",
                children: [
                  TextSpan(
                    text: " ${widget.category}",
                    style: GoogleFonts.raleway(
                      fontSize: size.width * 0.04,
                      color: red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                style: GoogleFonts.raleway(
                  fontSize: size.width * 0.04,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_position.toString().split(".")[0]),
                  Text(_duration.toString().split(".")[0]),
                ],
              ),
            ),
            Slider(
              min: 0.0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds.toDouble(),
              onChanged: (value) {
                setState(
                  () {
                    changeToSecond(value.toInt());
                    value = value;
                  },
                );
              },
              activeColor: red,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: IconButton(
                    iconSize: size.width * 0.1,
                    onPressed: () {
                      setState(() {
                        changeToSecond(_position.inSeconds - 10);
                      });
                    },
                    icon: Icon(
                      Icons.replay_10,
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    iconSize: size.width * 0.2,
                    color: red,
                    onPressed: () {
                      if (isplaying) {
                        // audioPlayer.pause();
                        player.pause();
                        setState(() {
                          isplaying = false;
                        });
                      } else {
                        player.play(UrlSource(widget.url));
                        // audioPlayer.play(Source());
                        setState(() {
                          isplaying = true;
                        });
                      }
                    },
                    icon: isplaying == true
                        ? Icon(Icons.pause_circle_filled_rounded)
                        : Icon(Icons.play_circle_fill_rounded),
                  ),
                ),
                Container(
                  child: IconButton(
                    iconSize: size.width * 0.1,
                    onPressed: () {
                      setState(() {
                        changeToSecond(_position.inSeconds + 10);
                      });
                    },
                    icon: Icon(
                      Icons.forward_10,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
