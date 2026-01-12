// core/network/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<Map<String, dynamic>> get(
      String path, {
        required Map<String, String> headers,
      }) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      throw Exception(decoded['message'] ?? 'API Error');
    }
  }
}
