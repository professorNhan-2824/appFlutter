import 'package:flutter/material.dart';
// Import cần thiết ở đầu file
import 'dart:ui'; // Import để sử dụng hiệu ứng BackdropFilter
import 'package:flutter_app/Views/toolnav/BottomNavBar.dart';
import 'package:flutter/services.dart'; // Import để tùy chỉnh thanh trạng thái

class BirdRecognitionUI extends StatefulWidget {
  @override
  _BirdRecognitionUIState createState() =>
      _BirdRecognitionUIState(); // Tạo trạng thái cho widget
}

class _BirdRecognitionUIState extends State<BirdRecognitionUI>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController; // Điều khiển animation
  late Animation<double> _fadeAnimation; // Animation cho hiệu ứng mờ
  late Animation<Offset> _slideAnimation; // Animation cho hiệu ứng trượt

  @override
  void initState() {
    super.initState();

    // Cấu hình animation
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200), // Thời gian animation là 1.2 giây
      vsync: this, // Đồng bộ với trạng thái của widget
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 1,
            curve: Curves.easeOut), // Hiệu ứng mờ trong 100% thời gian
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2), // Bắt đầu từ vị trí trượt xuống
      end: Offset.zero, // Kết thúc ở vị trí ban đầu
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.2, 0.7,
            curve: Curves.easeOut), // Hiệu ứng trượt trong 50% thời gian
      ),
    );

    // Khởi động animation khi widget load
    _animationController.forward();

    // Cài đặt thanh trạng thái trong suốt
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Thanh trạng thái trong suốt
      statusBarIconBrightness: Brightness.light, // Màu icon sáng
    ));
  }

  @override
  void dispose() {
    _animationController.dispose(); // Giải phóng tài nguyên animation
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền với hiệu ứng mờ tinh tế
          Positioned.fill(
            child: Hero(
              tag: 'background', // Tag cho hiệu ứng chuyển tiếp
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/Images/backgound/3.jpg'), // Hình nền
                    fit: BoxFit.cover, // Tự động điều chỉnh kích thước
                    // colorFilter: ColorFilter.mode(
                    //   Colors.black.withOpacity(0.0), // Độ mờ nền
                    //   BlendMode.darken, // Chế độ làm tối
                    // ),
                  ),
                ),
                // child: BackdropFilter(
                //   filter: ImageFilter.blur(
                //       sigmaX: 0, sigmaY: 0), // Hiệu ứng blur nhẹ
                //   child: Container(
                //       color: Colors.black.withOpacity(0.0)), // Lớp phủ mờ
                // ),
              ),
            ),
          ),

          Column(
            children: [
              // Phần header với gradient nâng cao
              Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0A2463).withOpacity(0.85), // Màu đầu gradient
                        Color(0xFF1E3A8A).withOpacity(0.75),
                        Color(0xFF3E5CB8).withOpacity(0.4), // Màu cuối gradient
                      ],
                      stops: [0.0, 0.5, 1.0], // Điểm dừng của gradient
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24), // Padding ngang
                      child: Column(
                        children: [
                          // Thanh app bar cải tiến
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12), // Padding trên
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Căn đều hai bên
                              children: [
                                Container(
                                  height: 70,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(20), // Bo góc
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                            31, 88, 129, 183), // Màu bóng
                                        blurRadius: 10, // Độ mờ bóng
                                        offset: Offset(0, 3), // Vị trí bóng
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/Images/logo/logo1.png'), // Logo // Thay đổi từ cover thành contain
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Khoảng cách
                                    _buildIconButton(
                                        Icons.info_outline), // Nút info
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Spacer(), // Tạo khoảng trống tự động

                          // Nội dung chính với animation
                          FadeTransition(
                            opacity: _fadeAnimation, // Hiệu ứng mờ
                            child: SlideTransition(
                              position: _slideAnimation, // Hiệu ứng trượt
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6), // Padding
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                          .withOpacity(0), // Màu nền mờ
                                      borderRadius:
                                          BorderRadius.circular(30), // Bo góc
                                      border: Border.all(
                                          color: Colors.white30,
                                          width: 1), // Viền
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
                                    "Tra Cứu Chim Quý",
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
                                  Text(
                                    "Việt Nam",
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
                                        Icon(
                                          Icons.update,
                                          size: 16,
                                          color: Colors.white70,
                                        ),
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

              // Phần bottom với thiết kế card hiện đại
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 32, 20, 10), // Padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32)), // Bo góc trên
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 16,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 16), // Padding dưới
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
                          crossAxisCount: 2, // 2 cột
                          crossAxisSpacing: 8, // Khoảng cách ngang
                          mainAxisSpacing: 8, // Khoảng cách dọc
                          childAspectRatio: 1.8, // Tỷ lệ kích thước card
                          physics: BouncingScrollPhysics(), // Hiệu ứng cuộn mềm
                          children: <Widget>[
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
                              "Nhận diện",
                              "Quét hình ảnh chim",
                              Icons.camera_alt,
                              Color(0xFF0097B2),
                              Color(0xFFB2EBF2),
                            ),
                            _buildFeatureCard(
                              context,
                              "Bộ sưu tập",
                              "Chim quý hiếm",
                              Icons.collections_bookmark,
                              Color(0xFF388E3C),
                              Color(0xFFC8E6C9),
                            ),
                            _buildFeatureCard(
                              context,
                              "Đánh Giá ",
                              "Đánh giá nhận xét trải nghiệm ",
                              Icons.star,
                              Color(0xFFFF8F00),
                              Color(0xFFFFE0B2),
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
      bottomNavigationBar: BottomNavBar(), // Thanh điều hướng dưới
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Hành động khi nhấn
        backgroundColor: Color(0xFF0A2463),
        elevation: 8, // Độ nổi của nút
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)), // Bo góc
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E3A8A),
                Color(0xFF0A2463)
              ], // Gradient cho nút
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
          // Icon camera
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // Vị trí nút
    );
  }

  Widget _buildIconButton(IconData icon) {
    // Tạo nút icon với hiệu ứng
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
    Color bgColor,
  ) {
    // Tạo card chức năng
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: () {}, // Hành động khi nhấn
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
