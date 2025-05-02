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
  bool _isPickingImage = false;

  // Color scheme
  // Color scheme
  final Color primaryColor = const Color.fromRGBO(80, 199, 143, 1); // Thay đổi thành rgb(80, 199, 143)
  final Color secondaryColor = const Color.fromRGBO(80, 199, 143, 1); // Thay đổi thành rgb(80, 199, 143)
  final Color backgroundColor = const Color.fromRGBO(225, 240, 239, 1); // Thay đổi thành rgb(225, 240, 239)
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF263238);
  final Color subtextColor = const Color(0xFF607D8B);
  final Color predictButtonColor = const Color.fromRGBO(80, 199, 193, 1); // Màu mới cho nút dự đoán

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isPickingImage = true;
    });
    
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: kIsWeb ? null : 1080,
        maxHeight: kIsWeb ? null : 1080,
      );
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        if (source == ImageSource.camera) {
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
          setState(() {
            _imageBytes = imageBytes;
            _result = null;
            _confidence = null;
            _conversationHistory = [];
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Không có ảnh được chọn'),
            backgroundColor: Colors.red[400],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      print('❌ Lỗi khi chọn ảnh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi chọn ảnh: $e'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isPickingImage = false;
      });
    }
  }

  Future<void> _navigateToPredict() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn ảnh trước'),
          backgroundColor: Colors.orange[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
      
      // Hiển thị toast thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nhận diện thành công!'),
          backgroundColor: secondaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
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
        SnackBar(
          content: const Text('Vui lòng nhập câu hỏi'),
          backgroundColor: Colors.orange[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Nhận diện chim"),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        foregroundColor: textColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image Display Card
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                "Hình ảnh chim",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Image Container with border and shadow
                              Container(
                                height: 250,
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: _imageBytes != null
                                    ? Image.memory(
                                        _imageBytes!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.photo_camera_outlined,
                                              size: 50,
                                              color: subtextColor,
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Chưa có ảnh',
                                              style: TextStyle(
                                                color: subtextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Result Section
                              if (_result != null)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: _result != 'Không xác định' 
                                        ? Colors.green.withOpacity(0.1) 
                                        : Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _result != 'Không xác định' 
                                          ? Colors.green.withOpacity(0.5) 
                                          : Colors.orange.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: _result != 'Không xác định' 
                                                ? Colors.green 
                                                : Colors.orange,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Kết quả nhận diện',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Loài: $_result',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (_confidence != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4),
                                          child: Text(
                                            'Độ tin cậy: ${_confidence!.toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              color: subtextColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Action Buttons
                      if (_result != null && _result != 'Không xác định')
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: ElevatedButton.icon(
                            onPressed: _fetchBirdInfo,
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Biết thêm về loài này'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                            ),
                          ),
                        ),

                      const SizedBox(height: 30),

                      // Conversation History
                      if (_conversationHistory.isNotEmpty)
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info, color: primaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "Thông tin về loài chim $_result",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 1.5),
                                ...List.generate(
                                  _conversationHistory.length,
                                  (index) {
                                    final entry = _conversationHistory[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Question
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: primaryColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: primaryColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    entry['query']!,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          
                                          // Response
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16, top: 8, right: 8),
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.smart_toy_outlined,
                                                    color: secondaryColor,
                                                    size: 20,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      entry['response']!,
                                                      style: TextStyle(
                                                        color: textColor,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          
                                          if (index < _conversationHistory.length - 1)
                                            const Padding(
                                              padding: EdgeInsets.symmetric(vertical: 8),
                                              child: Divider(),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 20),

                      // Q&A Input
                      if (_conversationHistory.isNotEmpty)
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: cardColor,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.question_answer, color: primaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Đặt câu hỏi về loài chim",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Preset Questions
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
                                              backgroundColor: primaryColor.withOpacity(0.1),
                                              foregroundColor: primaryColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                                side: BorderSide(color: primaryColor.withOpacity(0.3)),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 10),
                                            ),
                                            child: Text(
                                              query,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ))
                                      .toList(),
                                ),

                                const SizedBox(height: 20),

                                // Custom Question Input
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _customQueryController,
                                        decoration: InputDecoration(
                                          hintText: "Nhập câu hỏi của bạn",
                                          hintStyle: TextStyle(color: subtextColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          filled: true,
                                          fillColor: Colors.grey.withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: _isLoadingResponse
                                          ? null
                                          : _askNewQuestion,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(_isLoadingResponse ? "Đang xử lý..." : "Hỏi"),
                                    ),
                                  ],
                                ),

                                if (_isLoadingResponse)
                                  const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: LinearProgressIndicator(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom Action Panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Upload Buttons
                if (kIsWeb)
                  ElevatedButton.icon(
                    onPressed: _isPickingImage ? null : () => _pickImage(ImageSource.gallery),
                    icon: Icon(_isPickingImage ? Icons.hourglass_bottom : Icons.upload_file),
                    label: Text(_isPickingImage ? 'Đang tải...' : 'Tải ảnh lên'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isPickingImage ? null : () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(_isPickingImage ? 'Đang tải...' : 'Chọn từ thư viện'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isPickingImage ? null : () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: Text(_isPickingImage ? 'Đang tải...' : 'Chụp ảnh mới'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: 12),
                
                // Predict Button
                ElevatedButton.icon(
                  onPressed: _navigateToPredict,
                  icon: const Icon(Icons.search),
                  label: const Text('Dự đoán loài chim'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: predictButtonColor,
                    foregroundColor: const Color.fromARGB(255, 16, 15, 15),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
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