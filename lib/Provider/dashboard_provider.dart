import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/driver_booking_model.dart';

class AvailabilityNotifier extends StateNotifier<bool> {
  AvailabilityNotifier() : super(false);
  bool _isSwitchLoading = false;

  bool get isSwitchLoading => _isSwitchLoading;

  final String baseUrl = "http://3.144.118.25:9032";
  bool _isLoading = false;

  Future<bool> checkOnlineStatusApi({required BuildContext context}) async {
    if (_isLoading) return false;
    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/payment/check-before-online"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"action": "check_payment_status"}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return true;
      }

      print(data["status"]);
      print(data["message"] ?? "Payment check failed");
      return data["status"];
    } catch (e) {
      print("Something went wrong");
      return false;
    } finally {
      _isLoading = false;
    }
  }

  Future<String?> createOrderApi({required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/payment/create-order"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "payment_type": "driver_availability",
          "amount": 50,
          "currency": "INR",
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return data["data"]?["order"]?["id"];
      }

      // _showError(context, data["message"] ?? "Order creation failed");
      return null;
    } catch (e) {
      // _showError(context, "Something went wrong");
      return null;
    }
  }

  Future<bool> paymentVerifyApi({
    required BuildContext context,
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/payment/verify"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "razorpay_order_id": razorpayOrderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_signature": razorpaySignature,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"] ?? "Payment verification failed"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } catch (e) {
      debugPrint("Verify API Error: $e");
      return false;
    }
  }

  Future<void> toggleAvailability({
    required BuildContext context,
    required bool isAvailable,
    required double latitude,
    required double longitude,
    VoidCallback? onSuccess,
  }) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/availability/toggle-availability"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "is_available": isAvailable,
          "latitude": latitude,
          "longitude": longitude,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        // ✅ UPDATE STATE ONLY AFTER SUCCESS
        state = isAvailable;

        // ✅ ENSURE CONTEXT IS VALID
        if (context.mounted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  isAvailable ? "You are online now" : "You are offline now",
                ),
                backgroundColor: isAvailable ? Colors.green : Colors.grey[800],
                duration: const Duration(seconds: 2),
              ),
            );
        }

        onSuccess?.call();
      }
    } catch (e) {
      debugPrint("Toggle availability failed: $e");
    } finally {
      _isLoading = false;
    }
  }

  // Future<List<DriverBooking>> fetchDriverBookings({
  //   required BuildContext context,
  //   int page = 1,
  //   int limit = 10,
  //   String status = "in_progress",
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString("access_token") ?? "";
  //
  //     final uri = Uri.parse(
  //       "$baseUrl/driver/v1/bookings?page=$page&limit=$limit&status=$status",
  //     );
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //
  //     final json = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && json["status"] == true) {
  //       final List list = json["data"]["bookings"];
  //       return list.map((e) => DriverBooking.fromJson(e)).toList();
  //     }
  //
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }
  Future<List<dynamic>> fetchDriverBookings({
    required BuildContext context,
    int page = 1,
    int limit = 10,
    String status = "in_progress",
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final uri = Uri.parse(
        "$baseUrl/driver/v1/bookings/pending?"
        "?page=$page&limit=$limit&status=$status",
      );

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return data["data"]["bookings"] ?? [];
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> fetchCompletedBookings({
    required BuildContext context,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final uri = Uri.parse(
        "$baseUrl/driver/v1/bookings?"
        "?page=$page&limit=$limit&status=",
      );

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["status"] == true) {
        return data["data"]["bookings"] ?? [];
      }

      return [];
    } catch (e) {
      debugPrint("Completed bookings error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> acceptBookingApi({
    required String bookingId,
    required String otp,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/bookings/accept"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"id": bookingId, "otp": otp}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        debugPrint("Accept booking failed: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Accept booking error: $e");
      return null;
    }
  }

  // Future<bool> acceptBookingApi({
  //   required String bookingId,
  //   required String otp,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString("access_token") ?? "";
  //
  //     final response = await http.post(
  //       Uri.parse("$baseUrl/driver/v1/bookings/accept"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({
  //         "id": bookingId, // ✅ REQUIRED
  //         "otp": otp,
  //       }),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //
  //     return response.statusCode == 200 && data["status"] == true;
  //   } catch (e) {
  //     debugPrint("Accept booking error: $e");
  //     return false;
  //   }
  // }

  // Future<bool> cancelBookingApi({
  //   required String bookingId,
  //   required String reason,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString("access_token") ?? "";
  //
  //     final response = await http.post(
  //       Uri.parse("$baseUrl/driver/v1/bookings/reject"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({"booking_id": bookingId, "reason": reason}),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     return response.statusCode == 200 && data["status"] == true;
  //   } catch (e) {
  //     debugPrint("Cancel booking error: $e");
  //     return false;
  //   }
  // }
  Future<Map<String, dynamic>?> confirmBookingApi({
    required String bookingId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null || token.isEmpty) return null;

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/bookings/confirm"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"id": bookingId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint("Confirm booking error: $e");
      return null;
    }
  }

  // Future<bool> confirmBookingApi({
  //   required String bookingId,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString("access_token");
  //
  //     if (token == null || token.isEmpty) return false;
  //
  //     final response = await http.post(
  //       Uri.parse("$baseUrl/driver/v1/bookings/confirm"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //       body: jsonEncode({
  //         "id": bookingId,
  //       }),
  //     );
  //
  //     debugPrint("Confirm booking status: ${response.statusCode}");
  //     debugPrint("Confirm booking response: ${response.body}");
  //
  //     return response.statusCode == 200 || response.statusCode == 201;
  //   } catch (e) {
  //     debugPrint("Confirm booking error: $e");
  //     return false;
  //   }
  // }

  Future<bool> cancelBookingApi({
    required String bookingId,
    required String reason,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null || token.isEmpty) {
        debugPrint("Token missing");
        return false;
      }

      final response = await http
          .post(
            Uri.parse("$baseUrl/driver/v1/bookings/reject"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({"booking_id": bookingId, "reason": reason}),
          )
          .timeout(const Duration(seconds: 15));

      debugPrint("Cancel booking status: ${response.statusCode}");
      debugPrint("Cancel booking response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isEmpty) return true;

        final data = jsonDecode(response.body);

        // Handle both formats safely
        if (data is Map<String, dynamic>) {
          return data["status"] == true ||
              data["success"] == true ||
              data["message"] != null;
        }
        return true;
      }

      return false;
    } catch (e, stackTrace) {
      debugPrint("Cancel booking error: $e");
      debugPrint(stackTrace.toString());
      return false;
    }
  }

  // Future<List<dynamic>> fetchDriverBookings({
  //   required BuildContext context,
  //   int page = 1,
  //   int limit = 10,
  //   String status = "in_progress",
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString("access_token") ?? "";
  //
  //     final uri = Uri.parse(
  //       "$baseUrl/driver/v1/bookings"
  //       "?page=$page&limit=$limit&status=$status",
  //     );
  //
  //     final response = await http.get(
  //       uri,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token",
  //       },
  //     );
  //     print("Bearer $token");
  //
  //     final data = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && data["status"] == true) {
  //       return data["data"] ?? [];
  //     }
  //
  //     // _showError(context, data["message"] ?? "Failed to fetch bookings");
  //     return [];
  //   } catch (e) {
  //     // _showError(context, "Something went wrong");
  //     return [];
  //   }
  // }
}
