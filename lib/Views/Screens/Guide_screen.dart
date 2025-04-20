import 'package:flutter/material.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hình nền (tùy chọn, có thể dùng hình nền giống BirdRecognitionUI)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Images/backgound/3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Nội dung hướng dẫn
          SafeArea(
            child: Column(
              children: [
                // Header với nút Back
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nút Back
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context); // Quay lại màn hình trước
                          },
                        ),
                      ),
                      // Tiêu đề
                      const Text(
                        "Hướng Dẫn Sử Dụng",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 40), // Cân bằng layout
                    ],
                  ),
                ),
                // Nội dung hướng dẫn
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hướng Dẫn Sử Dụng Ứng Dụng",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A2463),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "1. Tìm kiếm thông tin chim:\n"
                            "   - Nhấn vào thẻ 'Tìm kiếm' để tra cứu thông tin các loài chim quý tại Việt Nam.\n"
                            "   - Nhập tên loài chim hoặc sử dụng bộ lọc để tìm nhanh.\n\n"
                            "2. Quét hình ảnh chim:\n"
                            "   - Nhấn vào thẻ 'Tải Ảnh' hoặc nút camera ở dưới cùng để tải ảnh chim.\n"
                            "   - Ứng dụng sẽ nhận diện loài chim dựa trên ảnh bạn cung cấp.\n\n"
                            "3. Xem bộ sưu tập:\n"
                            "   - Nhấn vào thẻ 'Bộ sưu tập' để xem danh sách các loài chim quý hiếm.\n"
                            "   - Chọn một loài để xem chi tiết và thông tin thú vị.\n\n"
                            "4. Đánh giá trải nghiệm:\n"
                            "   - Nhấn vào thẻ 'Đánh Giá' để gửi nhận xét hoặc đánh giá về ứng dụng.\n"
                            "   - Phản hồi của bạn giúp chúng tôi cải thiện ứng dụng tốt hơn.\n\n"
                            "5. Sử dụng bản đồ:\n"
                            "   - Trong màn hình chi tiết chim, nhấn 'Xem bản đồ' để xem khu vực phân bố của loài.\n\n"
                            "Lưu ý:\n"
                            "   - Đảm bảo kết nối internet để tải thông tin và ảnh từ API.\n"
                            "   - Kiểm tra quyền truy cập camera và bộ nhớ để sử dụng chức năng tải ảnh.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
