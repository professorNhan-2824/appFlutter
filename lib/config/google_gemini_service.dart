import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleGeminiService {
  final String apiKey =
      "AIzaSyCrtEqcu0usp1KWa7meMwB09-Nj8nKzf48"; // Thay bằng API Key của bạn
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  Future<String> chatWithGemini(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 200, // Giới hạn số token đầu ra
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["candidates"] != null &&
            data["candidates"].isNotEmpty &&
            data["candidates"][0]["content"] != null &&
            data["candidates"][0]["content"]["parts"] != null &&
            data["candidates"][0]["content"]["parts"].isNotEmpty) {
          return data["candidates"][0]["content"]["parts"][0]["text"] ??
              "Không có phản hồi.";
        } else {
          return "Không nhận được phản hồi từ AI.";
        }
      } else if (response.statusCode == 403) {
        return "Lỗi 403: API Key sai hoặc chưa bật Generative Language API.";
      } else if (response.statusCode == 404) {
        return "Lỗi 404: Model không tồn tại hoặc API URL sai.";
      } else {
        return "Lỗi: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }
}
