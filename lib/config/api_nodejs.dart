import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart'; // Import model User

class ApiService {
  static const String baseUrl =
      "https://apiflutter-cndd.onrender.com"; // Đổi thành URL backend của bạn xí lên đổi lại sausau

  // Hàm gọi API lấy danh sách user
  static Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/'));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      // Kiểm tra nếu response là Map và có key "data"
      if (jsonData is Map<String, dynamic> && jsonData.containsKey("data")) {
        List<dynamic> usersList = jsonData["data"];
        return usersList.map((data) => User.fromJson(data)).toList();
      }

      throw Exception("Dữ liệu API không hợp lệ");
    } else {
      throw Exception("Lỗi khi tải dữ liệu từ API");
    }
  }

  static Future<Map<String, dynamic>> addUser(String name, String email) async {
    final url = Uri.parse('$baseUrl/adduser');

    try {
      //gửi request lên server
      final response = await http.post(url,
          body: json.encode({"name": name, "email": email}),
          headers: {"Content-Type": "application/json"});
      //kieerm tra xem response co thanh cong hay khong
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": "Lỗi từ server"};
      }
    } catch (err) {
      return {"success": false, "message": "Lỗi: $err"};
    }
  }

  static Future<Map<String, dynamic>> deleteUser(String id) async {
    final url = Uri.parse('$baseUrl/deleteuser/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": "Lỗi server khi xóa"};
      }
    } catch (err) {
      return {"success": false, "message": "Lỗi: $err"};
    }
  }

  static Future<Map<String, dynamic>> updateUser(
      String id, String name, String email) async {
    final url = Uri.parse('$baseUrl/updateuser/$id');
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": name, "email": email}),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"success": false, "message": "Lỗi server khi cập nhật"};
      }
    } catch (err) {
      return {"success": false, "message": "Lỗi: $err"};
    }
  }
}
