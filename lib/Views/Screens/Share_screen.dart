import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareScreen extends StatelessWidget {
  final Map<String, dynamic>? birdData;

  const ShareScreen({super.key, this.birdData});

  void _shareContent(BuildContext context) async {
    try {
      if (birdData != null) {
        // Chia sẻ thông tin chim
        await Share.share(
          'Hãy khám phá loài chim ${birdData!['name']}!\n'
          'Tên khoa học: ${birdData!['scientificName']}\n'
          'Mô tả: ${birdData!['shortDescription']}\n'
          'Tìm hiểu thêm với ứng dụng Tra Cứu Chim Quý Việt Nam: https://example.com/bird-app',
          subject: 'Chia sẻ thông tin về ${birdData!['name']}',
        );
      } else {
        // Chia sẻ ứng dụng
        await Share.share(
          'Khám phá ứng dụng Tra Cứu Chim Quý Việt Nam! Tìm hiểu về các loài chim quý hiếm, quét ảnh để nhận diện chim, và nhiều tính năng thú vị khác. ',
          subject: 'Chia sẻ ứng dụng Tra Cứu Chim Quý Việt Nam',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chia sẻ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Text(
                        birdData != null
                            ? "Chia Sẻ ${birdData!['name']}"
                            : "Chia Sẻ Ứng Dụng",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          birdData != null
                              ? "Chia sẻ thông tin về ${birdData!['name']}"
                              : "Chia sẻ với bạn bè",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0A2463),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          birdData != null
                              ? "Hãy chia sẻ thông tin về loài chim ${birdData!['name']} để mọi người cùng khám phá!"
                              : "Hãy chia sẻ ứng dụng Tra Cứu Chim Quý Việt Nam để nhiều người cùng khám phá thiên nhiên và các loài chim quý hiếm!",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton.icon(
                          onPressed: () => _shareContent(context),
                          icon: const Icon(Icons.share, size: 20),
                          label: const Text(
                            "Chia sẻ ngay",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A2463),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ],
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
