import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class PredictScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const PredictScreen({super.key, required this.imageBytes});

  @override
  State<PredictScreen> createState() => _PredictScreenState();
}

class _PredictScreenState extends State<PredictScreen> {
  static const String _serverUrl = 'http://192.168.1.101:5000/predict';
  bool _isPredicting = true;

  @override
  void initState() {
    super.initState();
    // Tự động gọi hàm dự đoán khi trang được tải
    _predict();
  }

  // Gửi ảnh lên server
  Future<void> _predict() async {
    try {
      // Tạo multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_serverUrl));
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        widget.imageBytes,
        filename: 'image.png',
      ));

      // Gửi request và nhận phản hồi
      var response = await request.send().timeout(const Duration(seconds: 30));
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        String result = jsonResponse['bird'] ?? 'Không xác định';
        String confidenceStr = jsonResponse['confidence']?.toString() ?? '0%';
        double confidence =
            double.tryParse(confidenceStr.replaceAll('%', '')) ?? 0.0;

        // Trả kết quả về trang trước
        Navigator.pop(context, {
          'bird': result,
          'confidence': confidence,
        });
      } else {
        var errorResponse = jsonDecode(responseBody);
        throw Exception(
            errorResponse['error'] ?? 'Lỗi không xác định từ server');
      }
    } catch (e) {
      print('❌ Error during prediction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      // Trả về null nếu có lỗi
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đang nhận diện"),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Đang xử lý ảnh...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
