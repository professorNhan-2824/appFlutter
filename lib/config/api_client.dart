// lib/services/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Services//token_manager.dart';

class ApiClient {
  final String baseUrl = 'https://apiflutter-cndd.onrender.com';
  final TokenManager _tokenManager = TokenManager();

  // GET request với token authentication
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final token = await _tokenManager.getAccessToken();
      
      if (token == null) {
        return {'success': false, 'message': 'Không có token, cần đăng nhập lại'};
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      // Xử lý response
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // POST request với token authentication
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _tokenManager.getAccessToken();
      
      if (token == null) {
        return {'success': false, 'message': 'Không có token, cần đăng nhập lại'};
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      
      // Xử lý response
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  // Xử lý response từ API
  Map<String, dynamic> _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      return {'success': true, 'data': responseData};
    } else if (response.statusCode == 401) {
      // Token hết hạn, cần refresh token hoặc đăng nhập lại
      return {'success': false, 'message': 'Phiên đăng nhập hết hạn', 'status': 401};
    } else {
      return {
        'success': false, 
        'message': responseData['message'] ?? 'Lỗi từ server',
        'status': response.statusCode
      };
    }
  }
}