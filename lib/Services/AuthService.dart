// lib/services/auth_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import 'token_manager.dart';

class AuthService {
  // Thay thế bằng URL API của bạn
  final String? baseUrl = dotenv.env['API_BASE_URL'];
  final TokenManager _tokenManager = TokenManager();

  // Key để lưu thông tin user
  static const String userKey = 'user_data';
// Phương thức đăng ký mới
  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      String name = email.split('@')[0];
      print('🟡 Bắt đầu đăng ký với email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('🔵 Phản hồi HTTP status: ${response.statusCode}');
      print('📦 Dữ liệu phản hồi: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (responseData['access_token'] != null &&
            responseData['refresh_token'] != null) {
          await _tokenManager.saveTokens(
            accessToken: responseData['access_token'],
            refreshToken: responseData['refresh_token'],
          );
          print('✅ Token đã được lưu thành công');
        }

        print('✅ Đăng ký thành công');
        return {
          'success': true,
          'message': 'Đăng ký thành công',
          'user': responseData['user'],
        };
      } else {
        print('❌ Đăng ký thất bại: ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng ký thất bại',
        };
      }
    } catch (e) {
      print('❗ Lỗi kết nối hoặc exception: $e');
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }


  // Đăng nhập
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🟡 Bắt đầu đăng nhập với email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('🔵 Phản hồi HTTP status: ${response.statusCode}');
      print('📦 Dữ liệu phản hồi: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success']) {
        final accessToken = responseData['accessToken'];

        // Refresh token được lưu bằng cookie httpOnly → không lấy trực tiếp được
        final dummyRefreshToken = 'has_refresh_token';

        await _tokenManager.saveTokens(
          accessToken: accessToken,
          refreshToken: dummyRefreshToken,
        );
        print('✅ Đã lưu accessToken');
        print('👤 User từ response: ${responseData['user']}');

        final user = User.fromJson(responseData['user']);
        await _saveUserData(user);
        print('✅ Đã lưu thông tin người dùng: ${user.email}');

        return {
          'success': true,
          'user': user,
        };
      } else {
        print('❌ Đăng nhập thất bại: ${responseData['message']}');
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng nhập thất bại',
        };
      }
    } catch (e) {
      print('❗ Lỗi exception khi đăng nhập: $e');
      return {
        'success': false,
        'message': 'Lỗi kết nối: $e',
      };
    }
  }


  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  // Lấy thông tin người dùng từ SharedPreferences
  Future<User?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);

    if (userData != null && userData.isNotEmpty) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    return await _tokenManager.isLoggedIn();
  }

  // Đăng xuất
  Future<Map<String, dynamic>> logout() async {
    try {
      final token = await _tokenManager.getAccessToken();

      if (token != null) {
        // Gọi API đăng xuất (nếu server có endpoint này)
        final response = await http.post(
          Uri.parse('$baseUrl/users/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        // Xóa tất cả dữ liệu local bất kể kết quả từ server
        await _clearUserData();

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message': 'Đăng xuất thành công',
          };
        }
      }

      // Nếu không có token hoặc request thất bại, vẫn xóa dữ liệu local
      await _clearUserData();

      return {
        'success': true,
        'message': 'Đăng xuất thành công',
      };
    } catch (e) {
      // Xóa dữ liệu local ngay cả khi có lỗi
      await _clearUserData();

      return {
        'success': true,
        'message': 'Đã đăng xuất khỏi thiết bị này',
      };
    }
  }

  // Xóa tất cả dữ liệu người dùng
  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await _tokenManager.clearTokens();
  }
}
