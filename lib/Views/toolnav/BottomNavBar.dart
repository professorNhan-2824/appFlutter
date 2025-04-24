import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/HomeScreen.dart';
import 'package:flutter_app/Views/Screens/image_upload_screen.dart';

// Thêm các màn hình khác nếu cần như SettingsScreen

class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BirdRecognitionUI()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUploadScreen()),
        );

        break;
      case 2:
        // Ví dụ: Mở màn hình Cài đặt (nếu có)
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Mở trang Cài đặt.")),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabTapped,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Trang chủ",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: "Chụp ảnh",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Cài đặt",
        ),
      ],
    );
  }
}
