import 'package:flutter/material.dart';
import 'package:flutter_app/Views/Screens/check_image.dart';
import 'package:flutter_app/Views/Screens/testAnh.dart';
import 'package:flutter_app/config/google_gemini_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'ai_screen.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  Uint8List? _imageBytes;
  String? _result;
  double? _confidence;
  List<Map<String, String>> _conversationHistory = [];
  final TextEditingController _customQueryController = TextEditingController();
  bool _isLoadingResponse = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: kIsWeb ? null : 1080, // Tăng maxWidth để giữ chất lượng
        maxHeight: kIsWeb ? null : 1080,
      );
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        if (source == ImageSource.camera) {
          // Khi chụp ảnh từ camera, chuyển đến màn hình cắt ảnh
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropImageScreen(
                imageBytes: imageBytes,
                onCrop: (croppedBytes) {
                  setState(() {
                    _imageBytes = croppedBytes;
                    _result = null;
                    _confidence = null;
                    _conversationHistory = [];
                  });
                },
              ),
            ),
          );
        } else {
          // Khi chọn ảnh từ thư viện, lưu trực tiếp
          setState(() {
            _imageBytes = imageBytes;
            _result = null;
            _confidence = null;
            _conversationHistory = [];
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không có ảnh được chọn')),
        );
      }
    } catch (e) {
      print('❌ Lỗi khi chọn ảnh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chọn ảnh: $e')),
      );
    }
  }

  Future<void> _navigateToPredict() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ảnh trước')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PredictScreen(imageBytes: _imageBytes!),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _result = result['bird'] ?? 'Không xác định';
        _confidence = result['confidence'] ?? 0.0;
        _conversationHistory = [];
      });
    }
  }

  Future<void> _fetchBirdInfo() async {
    setState(() {
      _isLoadingResponse = true;
    });

    final history = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AIScreen(birdName: _result!),
      ),
    );

    if (history != null && history is List<Map<String, String>>) {
      setState(() {
        _conversationHistory = history;
        _isLoadingResponse = false;
      });
    } else {
      setState(() {
        _isLoadingResponse = false;
      });
    }
  }

  Future<void> _askNewQuestion() async {
    if (_customQueryController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập câu hỏi')),
      );
      return;
    }

    final String query = _customQueryController.text;
    _customQueryController.clear();

    setState(() {
      _isLoadingResponse = true;
    });

    try {
      final geminiService = GoogleGeminiService();

      String prompt =
          "Bạn là một chuyên gia về chim. Tôi đang hỏi về loài chim $_result. Dưới đây là lịch sử hội thoại:\n";
      for (var entry in _conversationHistory) {
        prompt += "Người dùng: ${entry['query']}\nAI: ${entry['response']}\n";
      }
      prompt +=
          "Người dùng: $query\nHãy trả lời bằng tiếng Việt, ngắn gọn nhưng đầy đủ thông tin.";

      String aiResponse = await geminiService.chatWithGemini(prompt);
      aiResponse = aiResponse.trim().replaceAll('\n', ' ').replaceAll('\r', '');

      setState(() {
        _conversationHistory.add({
          'query': query,
          'response': aiResponse,
        });
      });
    } catch (e) {
      print('❌ Lỗi khi đặt câu hỏi: $e');
      setState(() {
        _conversationHistory.add({
          'query': query,
          'response': "Lỗi khi lấy thông tin: $e",
        });
      });
    } finally {
      setState(() {
        _isLoadingResponse = false;
      });
    }
  }

  // Danh sách các câu hỏi có sẵn
  final List<String> predefinedQueries = [
    "Đặc điểm nhận dạng của loài chim này là gì?",
    "Môi trường sống của loài chim này như thế nào?",
    "Thói quen ăn uống của loài chim này ra sao?",
  ];

  // Hàm để sử dụng câu hỏi có sẵn
  Future<void> _usePresetQuestion(String question) async {
    _customQueryController.text = question;
    await _askNewQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhận diện chim"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      Text(
                        _result != null
                            ? 'Loài: $_result\nĐộ tin cậy: ${_confidence!.toStringAsFixed(2)}%'
                            : 'Chưa có kết quả',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Nút "Biết thêm về loài này" chỉ hiển thị sau khi nhận diện
                      if (_result != null && _result != 'Không xác định')
                        ElevatedButton(
                          onPressed: _fetchBirdInfo,
                          child: const Text('Biết thêm về loài này'),
                        ),

                      const SizedBox(height: 20),

                      // Hiển thị lịch sử hội thoại
                      if (_conversationHistory.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Thông tin về loài chim $_result:",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              ...List.generate(
                                _conversationHistory.length,
                                (index) {
                                  final entry = _conversationHistory[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Hỏi: ${entry['query']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "Trả lời: ${entry['response']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                        if (index <
                                            _conversationHistory.length - 1)
                                          const Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Giao diện nhập câu hỏi mới
                      if (_conversationHistory.isNotEmpty)
                        Column(
                          children: [
                            Text(
                              "Đặt câu hỏi về loài chim",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Các câu hỏi có sẵn
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: predefinedQueries
                                  .map((query) => ElevatedButton(
                                        onPressed: _isLoadingResponse
                                            ? null
                                            : () => _usePresetQuestion(query),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                        ),
                                        child: Text(
                                          query,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ))
                                  .toList(),
                            ),

                            const SizedBox(height: 15),

                            // Ô nhập câu hỏi
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _customQueryController,
                                    decoration: const InputDecoration(
                                      hintText: "Nhập câu hỏi của bạn",
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: _isLoadingResponse
                                      ? null
                                      : _askNewQuestion,
                                  child: const Text("Hỏi"),
                                ),
                              ],
                            ),

                            if (_isLoadingResponse)
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (kIsWeb)
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Tải ảnh lên'),
                  )
                else
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
                  onPressed: _navigateToPredict,
                  child: const Text('Dự đoán loài chim'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
