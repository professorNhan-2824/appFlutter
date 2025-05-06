import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/HomeScreen.dart';
import 'package:flutter_app/Views/Screens/MyAccount.dart';
import 'package:flutter_app/Views/Screens/image_upload_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    if (_currentIndex == index) return; // Không làm gì nếu nhấn tab hiện tại
    
    setState(() {
      _currentIndex = index;
    });

    // Sử dụng pushReplacement để thay thế màn hình hiện tại trong stack
    Widget screen;
    switch (index) {
      case 0:
        screen = BirdRecognitionUI();
        break;
      case 1:
        screen = ImageUploadScreen();
        break;
      case 2:
        screen = MyAccount();
        break;
      default:
        screen = BirdRecognitionUI();
    }

    // Sử dụng pushAndRemoveUntil để xóa toàn bộ stack điều hướng và thêm màn hình mới
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false, // Xóa tất cả các route trước đó
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
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
          icon: Icon(Icons.person),
          label: "Tài khoản",
        ),
      ],
    );
  }
}