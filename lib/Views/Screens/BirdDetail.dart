import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:universal_html/html.dart' as html;

class BirdDetailScreen extends StatelessWidget {
  final String birdName;

  const BirdDetailScreen({super.key, required this.birdName});

  // Hàm gọi API
  Future<Map<String, dynamic>> fetchBirdData(String species) async {
    final url =
        'https://apiflutter-cndd.onrender.com/birds/findbird?species=$species';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'].isNotEmpty) {
        return data['data'][0];
      } else {
        throw Exception('Không tìm thấy dữ liệu cho loài chim này');
      }
    } else {
      throw Exception('Lỗi khi gọi API: ${response.statusCode}');
    }
  }

  // Hàm chia sẻ thông tin chim
  void _shareBirdData(
      BuildContext context, Map<String, dynamic> birdData) async {
    String shareContent =
        'Tìm hiểu thêm: Khám phá ${birdData['name'] ?? birdName}! '
        'Tên khoa học: ${birdData['scientificName'] ?? 'Không rõ'}. ';
    if (shareContent.length > 200) {
      shareContent = shareContent.substring(0, 197) + '...';
    }

    if (kIsWeb) {
      html.window.navigator.clipboard?.writeText(shareContent).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã sao chép liên kết vào clipboard!')),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi sao chép: $e')),
        );
      });
      return;
    }

    try {
      print('Share content: $shareContent');
      await Share.share(
        shareContent,
        subject: 'Chia sẻ thông tin về ${birdData['name'] ?? birdName}',
      );
    } catch (e, stackTrace) {
      print('Lỗi chia sẻ: $e\nStackTrace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chia sẻ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchBirdData(birdName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Không có dữ liệu'));
          }

          final birdData = snapshot.data!;
          print('Image URL: ${birdData['imageUrl']}');
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Hình ảnh chim
                    Container(
                      height: 250,
                      child: CachedNetworkImage(
                        imageUrl: birdData['imageUrl'] ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) {
                          print('Lỗi tải ảnh: $error, URL: $url');
                          return const Image(
                            image: AssetImage(
                                'assets/Images/birdSpecies/placeholder.png'),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    // Nội dung chi tiết
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            birdData['name'] ?? birdName,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.science,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  birdData['scientificName'] ?? 'Không rõ',
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.nature_people,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  birdData['habitat'] ?? 'Không rõ',
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.restaurant,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  birdData['food'] ?? 'Không rõ',
                                  style: const TextStyle(color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Thông tin loài",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Mô tả: ${birdData['shortDescription'] ?? 'Không có mô tả'}\n'
                            'Tuổi thọ: ${birdData['lifespan'] ?? 'Không rõ'}\n'
                            'Sự thật thú vị: ${(birdData['interestingFacts'] as List<dynamic>?)?.join(', ') ?? 'Không có'}',
                            style: const TextStyle(fontSize: 16),
                            softWrap: true,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => _shareBirdData(context, birdData),
                            icon: const Icon(Icons.share, size: 20),
                            label: const Text(
                              "Chia sẻ loài chim",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A2463),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Nút quay lại
              Positioned(
                top: 40,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
