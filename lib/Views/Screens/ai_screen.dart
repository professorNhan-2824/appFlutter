import 'package:flutter/material.dart';
import 'package:flutter_app/config/google_gemini_service.dart';

class AIScreen extends StatefulWidget {
  final String birdName;

  const AIScreen({super.key, required this.birdName});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final GoogleGeminiService geminiService = GoogleGeminiService();
  List<Map<String, String>> conversationHistory = [];
  bool _isLoading = true;

  final List<String> predefinedQueries = [
    "Đặc điểm nhận dạng của loài chim này là gì?",
    "Môi trường sống của loài chim này như thế nào?",
    "Thói quen ăn uống của loài chim này ra sao?",
  ];

  @override
  void initState() {
    super.initState();
    _processInitialQuery();
  }

  Future<void> _processInitialQuery() async {
    // Tự động xử lý câu hỏi đầu tiên khi màn hình được tải
    await _fetchAIResponse(
        "Giới thiệu tổng quan về loài chim ${widget.birdName}");

    // Trả về lịch sử hội thoại và kết thúc màn hình
    Navigator.pop(context, conversationHistory);
  }

  Future<void> _fetchAIResponse(String query) async {
    try {
      String prompt =
          "Bạn là một chuyên gia về chim. Tôi đang hỏi về loài chim ${widget.birdName}. Dưới đây là lịch sử hội thoại:\n";
      for (var entry in conversationHistory) {
        prompt += "Người dùng: ${entry['query']}\nAI: ${entry['response']}\n";
      }
      prompt +=
          "Người dùng: $query\nHãy trả lời bằng tiếng Việt, ngắn gọn nhưng đầy đủ thông tin.";

      String aiResponse = await geminiService.chatWithGemini(prompt);

      // Loại bỏ ký tự không mong muốn và đảm bảo định dạng
      aiResponse = aiResponse.trim().replaceAll('\n', ' ').replaceAll('\r', '');

      setState(() {
        conversationHistory.add({
          'query': query,
          'response': aiResponse,
        });
      });
    } catch (e) {
      print('❌ Error fetching AI info: $e');
      setState(() {
        conversationHistory.add({
          'query': query,
          'response': "Lỗi khi lấy thông tin: $e",
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đang tra cứu về ${widget.birdName}"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Đang tải thông tin về ${widget.birdName}...")
          ],
        ),
      ),
    );
  }
}
