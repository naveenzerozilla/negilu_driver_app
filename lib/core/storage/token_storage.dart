// core/storage/token_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") ?? "";
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("access_token");
  }
}
