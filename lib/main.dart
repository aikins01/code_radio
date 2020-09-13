import 'package:code_radio/screens/playscreen.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlayerScreen(),
      theme: ThemeData(
        primaryColor: Color(0xFF5E35B1),
      ),
    );
  }
}



