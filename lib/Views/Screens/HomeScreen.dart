import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/BirdDetail.dart';
import 'package:flutter_app/Views/Screens/Discover.dart';
import 'package:flutter_app/Views/Screens/userScreen.dart';
import 'dart:ui'; // Để sử dụng hiệu ứng BackdropFilter
import 'package:flutter_app/Views/toolnav/BottomNavBar.dart'; // Giả sử đây là file có sẵn
import 'package:flutter/services.dart'; // Để tùy chỉnh thanh trạng thái
import 'image_upload_screen.dart'; // Import màn hình tải ảnh mới

class BirdRecognitionUI extends StatefulWidget {
  @override
  _BirdRecognitionUIState createState() => _BirdRecognitionUIState();
}

class _BirdRecognitionUIState extends State<BirdRecognitionUI>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Cấu hình animation
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 1, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền
          Positioned.fill(
            child: Hero(
              tag: 'background',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Images/backgound/3.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              // Phần header
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0A2463).withOpacity(0.85),
                        Color(0xFF1E3A8A).withOpacity(0.75),
                        Color(0xFF3E5CB8).withOpacity(0.4),
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 70,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(31, 88, 129, 183),
                                        blurRadius: 10,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/Images/logo/logo1.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                _buildIconButton(Icons.info_outline),
                              ],
                            ),
                          ),
                          Spacer(),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color: Colors.white30, width: 1),
                                    ),
                                    child: Text(
                                      "KHÁM PHÁ THIÊN NHIÊN",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Tra Cứu Chim Quý\nViệt Nam",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 32,
                                      height: 1.1,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.2),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.update,
                                            size: 16, color: Colors.white70),
                                        SizedBox(width: 8),
                                        Text(
                                          "Cập nhật 3/2025",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Phần bottom
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 32, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                1), // Sửa lỗi typo từ 'custom' thành 'bottom'
                        child: Text(
                          "Chức năng chính",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2463),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.3,
                          physics: BouncingScrollPhysics(),
                          children: [
                            _buildFeatureCard(
                              context,
                              "Tìm kiếm",
                              "Tìm thông tin các loài chim",
                              Icons.search,
                              Color(0xFFDA4167),
                              Color(0xFFFFD1DC),
                            ),
                            _buildFeatureCard(
                              context,
                              "Tải Ảnh",
                              "Quét hình ảnh chim",
                              Icons.camera_alt,
                              Color(0xFF0097B2),
                              Color(0xFFB2EBF2),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImageUploadScreen()),
                                );
                              },
                            ),
                            _buildFeatureCard(
                              context,
                              "Bộ sưu tập",
                              "Chim quý hiếm",
                              Icons.collections_bookmark,
                              Color(0xFF388E3C),
                              Color(0xFFC8E6C9),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BirdDetailApp()),
                                );
                              },
                            ),
                            _buildFeatureCard(
                              context,
                              "Đánh Giá",
                              "Đánh giá nhận xét trải nghiệm",
                              Icons.star,
                              Color(0xFFFF8F00),
                              Color(0xFFFFE0B2),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => ImageUploadScreen()),
          // );
        },
        backgroundColor: Color(0xFF0A2463),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E3A8A), Color(0xFF0A2463)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF1E3A8A).withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(Icons.camera_enhance, size: 28, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    Color bgColor, {
    VoidCallback? onTap, // Thêm tham số onTap
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
