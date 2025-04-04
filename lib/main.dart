import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/BirdDetail.dart';
import 'package:flutter_app/Views/Screens/Discover.dart';
import 'package:flutter_app/Views/Screens/Login.dart';
import 'package:flutter_app/Views/toolnav/BottomNavBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BirdRecognitionUI(), // Gọi màn hình đăng nhập
    );
  }
}
