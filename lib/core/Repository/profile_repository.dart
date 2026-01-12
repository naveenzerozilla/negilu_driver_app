import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/driver_profile.dart';

import 'package:http/http.dart' as http;

class ProfileRepository {
  final String baseUrl = "http://3.144.118.25:9032";

  Future<DriverProfile> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final res = await http.get(
      Uri.parse("$baseUrl/driver/v1/registration/profile"),

      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    final json = jsonDecode(res.body);
    return DriverProfile.fromJson(json['data']['profile']);
  }

  Future<Map<String, dynamic>> fetchAddressData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";
    final res = await http.get(
      Uri.parse("$baseUrl/driver/v1/address-data"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    return jsonDecode(res.body)['data'];
  }

  Future<bool> updateProfile({
    required String fullName,
    required String profileImage,
    required String mobileNumber,
    required String emailId,
    required String gender,
    required String stateId,
    required String districtId,
    required String talukId,
    required String hobliId,
    required String villageId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token") ?? "";

    final payload = {
      "full_name": fullName,
      "profile_image": profileImage,
      "mobile_number": mobileNumber,
      "email_id": emailId,
      "gender": gender,
      "state_id": stateId,
      "district_id": districtId,
      "taluk_id": talukId,
      "hobli_id": hobliId,
      "village_id": villageId,
    };

    final res = await http.put(
      Uri.parse("$baseUrl/driver/v1/registration/profile"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(payload),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      debugPrint("Update profile failed: ${res.body}");
      return false;
    }
  }
}
