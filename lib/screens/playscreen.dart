import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_radio/flutter_radio.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  String streamUrl =
      "https://coderadio-admin.freecodecamp.org/radio/8010/low.mp3";
  bool _isPlaying = false;
  String title = "";
  String singer = "";
  String album = "";
  int duration = 100;
  int elapsed = 0;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
    incre();
  }

  void incre() {
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(
        oneSec,
        (Timer t) => {
              if (_isPlaying && elapsed != duration)
                {
                  setState(() {
                    elapsed++;
                  })
                }
              else
                {t.cancel(), getMeta(), incre()}
            });
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  "PYWEDIO",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5E35B1)),
                ),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(FontAwesomeIcons.codeBranch),
                // ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x46000000),
                      offset: Offset(0, 20),
                      spreadRadius: 0,
                      blurRadius: 30,
                    ),
                    BoxShadow(
                      color: Color(0x11000000),
                      offset: Offset(0, 10),
                      spreadRadius: 0,
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    image: NetworkImage(
                        "https://www.wired.com/images_blogs/design/2013/09/tumblr_inline_mqutgxtW2Z1qz4rgp.gif"),
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.7,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text('$singer, $album'),
              SizedBox(
                height: 20,
              ),
              Slider(
                onChanged: (v) {},
                value: elapsed.toDouble(),
                max: duration.toDouble(),
                min: 0,
                activeColor: Color(0xFF5E35B1),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(FontAwesomeIcons.backward),
                  // ),
                  IconButton(
                    iconSize: 50,
                    onPressed: () {
                      getMeta();
                      FlutterRadio.playOrPause(url: streamUrl);
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    icon: Icon(
                      _isPlaying
                          ? FontAwesomeIcons.pause
                          : FontAwesomeIcons.play,
                      color: Color(0xFF5E35B1),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(FontAwesomeIcons.forward),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getMeta() async {
    var url =
        'https://coderadio-admin.freecodecamp.org/api/live/nowplaying/coderadio';

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var itemCount = jsonResponse['now_playing'];
      setState(() {
        title = jsonResponse['now_playing']['song']['title'];
        singer = jsonResponse['now_playing']['song']['artist'];
        album = jsonResponse['now_playing']['song']['album'];
        elapsed = jsonResponse['now_playing']['elapsed'];
        duration = jsonResponse['now_playing']['duration'];
      });
      print('Number of books about http: $itemCount.');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future playingStatus() async {
    bool isP = await FlutterRadio.isPlaying();
    setState(() {
      _isPlaying = isP;
    });
  }
}
