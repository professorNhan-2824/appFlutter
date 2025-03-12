import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              // Spacer to center main content
              // Main content
              const SizedBox(height: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bird logo with decorative background
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Image.asset(
                        'assets/Images/LoginScreen/bird.png',
                        height: 150,
                      ),
                    ],
                  ),
                  
                  // const SizedBox(height: 10),
                  
                  // App title and tagline
                  const Text(
                    "BirdLens",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Khám phá các loài chim trong khu vực của bạn",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  
                  // const SizedBox(height: 20),
                  const SizedBox(height: 15),
                  // Feature highlights
                  _buildFeatureRow(
                    Icons.photo_camera_outlined, 
                    "Nhận diện nhanh chóng",
                    "Chỉ cần chụp ảnh để xác định loài chim"
                  ),
                  const SizedBox(height: 15),
                  _buildFeatureRow(
                    Icons.explore_outlined, 
                    "Khám phá đa dạng",
                    "Tìm hiểu các loài chim tại Việt Nam"
                  ),
                  const SizedBox(height: 15),
                  // const SizedBox(height: 40),
                  
                  // Social login buttons
                  _buildSocialButton(Icons.facebook, "Đăng nhập với Facebook", Colors.blue),
                  const SizedBox(height: 15),
                  _buildSocialButton(Icons.g_mobiledata, "Đăng nhập với Google", Colors.red),
                  
                  // Email signup option
                  const SizedBox(height: 10),
                ],
              ),
              
              const Spacer(flex: 1),
              
              // Bottom section with terms
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Bằng cách đăng nhập, bạn đồng ý với Điều khoản sử dụng và Chính sách bảo mật của chúng tôi",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String text, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(double.infinity, 50),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
  
  Widget _buildFeatureRow(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue, size: 24),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}