import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_filled), label: "Trang chủ"),
        BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Chụp ảnh"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Cài đặt"),
      ],
    );
  }
}
