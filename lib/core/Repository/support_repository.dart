import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/supportModel.dart';
import '../../Model/support_option.dart';

class SupportRepository {
  final String baseUrl = "http://3.144.118.25:9032";

  Future<List<SupportTicket>> fetchSupportTickets({
    int page = 1,
    int limit = 10,
    String status = "all",
    String priority = "all",
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";

    final uri = Uri.parse(
      "$baseUrl/driver/v1/support"
      "?page=$page&limit=$limit&status=$status&priority=$priority",
    );

    final res = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to fetch support tickets");
    }

    final json = jsonDecode(res.body);

    final List ticketsJson = json['data']['tickets'];

    return ticketsJson.map((e) => SupportTicket.fromJson(e)).toList();
  }

  // ---------- GET OPTIONS ----------
  Future<Map<String, List<SupportOption>>> fetchSupportOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    final res = await http.get(
      Uri.parse("$baseUrl/driver/v1/support/options"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    final json = jsonDecode(res.body)['data'];

    return {
      "issue_types": (json['issue_types'] as List)
          .map((e) => SupportOption.fromJson(e))
          .toList(),
      "priorities": (json['priorities'] as List)
          .map((e) => SupportOption.fromJson(e))
          .toList(),
    };
  }

  // ---------- CREATE TICKET ----------
  Future<void> createSupportTicket({
    required String issueType,
    required String description,
    required String priority,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    final res = await http.post(
      Uri.parse("$baseUrl/driver/v1/support"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "issue_type": issueType,
        "issue_description": description,
        "priority": priority,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to create support ticket");
    }
  }
}
