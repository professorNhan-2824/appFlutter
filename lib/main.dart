import 'package:flutter/material.dart';
import 'Views/Screens/HomeScreen.dart';

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