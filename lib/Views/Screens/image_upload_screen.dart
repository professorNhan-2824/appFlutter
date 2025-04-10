import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? _imageBytes;
  bool _isPredicting = false;
  String? _result;
  double? _confidence;

  // URL của Flask server
  static const String _serverUrl = 'http://127.0.0.1:5000/predict';

  // Chọn ảnh (hỗ trợ cả web và mobile)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 224,
        maxHeight: 224,
      );
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
          _result = null;
          _confidence = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có ảnh được chọn')),
        );
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  // Gửi ảnh lên server
  Future<void> _predict() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ảnh trước')),
      );
      return;
    }

    setState(() => _isPredicting = true);

    try {
      // Tạo multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_serverUrl));
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        _imageBytes!,
        filename: 'image.png',
      ));

      // Gửi request và nhận phản hồi
      print('Sending request to $_serverUrl...');
      var response = await request.send().timeout(const Duration(seconds: 30));
      print('Response status: ${response.statusCode}');

      // Đọc phản hồi
      var responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        print('Parsed JSON: $jsonResponse');
        setState(() {
          _result = jsonResponse['bird'] ?? 'Không xác định';
          String confidenceStr = jsonResponse['confidence']?.toString() ?? '0%';
          _confidence =
              double.tryParse(confidenceStr.replaceAll('%', '')) ?? 0.0;
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
    } finally {
      setState(() => _isPredicting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhận diện chim"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị ảnh
            if (_imageBytes != null)
              Image.memory(
                _imageBytes!,
                height: 224,
                width: 224,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 224,
                width: 224,
                color: Colors.grey[300],
                child: const Center(child: Text('Chưa có ảnh')),
              ),
            const SizedBox(height: 10),
            // Hiển thị thông tin loài chim và độ tin cậy ngay dưới ảnh
            Text(
              _result != null
                  ? 'Loài: $_result\nĐộ tin cậy: ${_confidence!.toStringAsFixed(2)}%'
                  : 'Chưa có kết quả',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            // Hiển thị nút tùy theo nền tảng
            if (kIsWeb)
              // Trên web: Chỉ hiển thị nút "Tải ảnh lên"
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.upload_file),
                label: const Text('Tải ảnh lên'),
              )
            else
              // Trên mobile: Hiển thị hai nút "Chọn ảnh" và "Chụp ảnh"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text('Chọn ảnh'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Chụp ảnh'),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPredicting ? null : _predict,
              child: _isPredicting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Dự đoán loài chim'),
            ),
          ],
        ),
      ),
    );
  }
}
