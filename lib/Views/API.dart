import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/bird.dart';

class BirdService {
  // Phương thức tìm kiếm chim theo loài
  Future<List<Bird>> findBirdBySpecies(String species) async {
    final encodedSpecies = Uri.encodeComponent(species);
    final url = 'https://apiflutter-cndd.onrender.com/birds/findbird?species=$encodedSpecies';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Kiểm tra và phân tích đúng cấu trúc dữ liệu
      final jsonData = jsonDecode(response.body);

      // Kiểm tra xem dữ liệu là Map hay List
      if (jsonData is Map<String, dynamic>) {
        // Nếu là Map, kiểm tra xem có trường nào chứa danh sách không
        if (jsonData.containsKey('data') && jsonData['data'] is List) {
          // Trường hợp API trả về dạng: {"data": [...]}
          return (jsonData['data'] as List)
              .map((item) => Bird.fromJson(item))
              .toList();
        } else {
          // Nếu không có trường data, có thể API chỉ trả về một bird
          return [Bird.fromJson(jsonData)];
        }
      } else if (jsonData is List) {
        // Nếu trực tiếp là List
        return jsonData.map((item) => Bird.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected data format from API');
      }
    } else {
      throw Exception('Failed to load birds: ${response.statusCode}');
    }
  }
}
