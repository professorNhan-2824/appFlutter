import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/Camera.dart';
import 'Views/GetAPI.dart';
import 'Views/Screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BirdSearchScreen(), // Gọi màn hình đăng nhập
    );
  }
}
//thay doi moi
