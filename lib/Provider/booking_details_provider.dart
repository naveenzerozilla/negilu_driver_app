import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final bookingDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, bookingId) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.get(
        Uri.parse("http://3.144.118.25:9032/driver/v1/bookings/$bookingId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json["data"];
      } else {
        throw Exception("Failed to load booking details");
      }
    });
