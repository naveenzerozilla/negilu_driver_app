import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = "http://3.144.118.25:9032";

  /// Build headers with token
  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  /// GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$_baseUrl$endpoint"),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  /// POST request
  Future<Map<String, dynamic>> post(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch(
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final response = await http.patch(
      Uri.parse("$_baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(body ?? {}),
    );

    return _handleResponse(response);
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse("$_baseUrl$endpoint"),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  /// Common response handler
  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw Exception(
        decoded['message'] ?? "Something went wrong",
      );
    }
  }
}
