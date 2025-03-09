import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(), // Gọi màn hình đăng nhập
    );
  }
}
