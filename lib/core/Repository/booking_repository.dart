import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookingRepository {
  final String baseUrl = "http://3.144.118.25:9032";

  Future<void> completeBooking({
    required String bookingId,
    required String completionNotes,
    required double actualDuration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("access_token") ?? "";

    final res = await http.post(
      Uri.parse("$baseUrl/driver/v1/bookings/complete"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": bookingId,
        "completion_notes": completionNotes,
        "actual_duration": actualDuration,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Failed to complete booking");
    }
  }
}
