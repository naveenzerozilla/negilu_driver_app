import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:negilu_driver_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/AttatchmentModel.dart';
import '../Model/VehicleModel.dart';
import '../Model/vehicle_model.dart';
import '../screens/OtpScreen.dart';
import '../utils/NavigateHelper.dart';
import 'package:path/path.dart';

class AuthNotifier extends ChangeNotifier {
  final String baseUrl = "http://3.144.118.25:9032";
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loginWithMobile(
    BuildContext context,
    String mobileNumber,
  ) async {
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }

    try {
      isLoading = true;

      const String apiUrl = "http://3.144.118.25:9032/driver/v1/auth/login";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": mobileNumber}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true || data['status'] == true) {
          print(data['status']);
          final otp = data['data']['otp']?.toString() ?? '';
          NavigationHelper.navigateToReplacement(
            context,
            OtpScreen(otpFromServer: otp, mobile: mobileNumber),
          );
        } else {
          print(data['status']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Signup failed')),
          );
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Login failed')),
        );
      }
    } catch (e) {
      if (kDebugMode) print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      isLoading = false;
    }
  }

  Future<void> signupWithMobile(
    BuildContext context,
    String fullName,
    String mobileNumber,
  ) async {
    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name')),
      );
      return;
    }
    if (mobileNumber.isEmpty || mobileNumber.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
        ),
      );
      return;
    }

    try {
      isLoading = true;

      final response = await http.post(
        Uri.parse("${baseUrl}/driver/v1/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "full_name": fullName,
          "mobile": mobileNumber,
          "country_code": "+91",
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true || data['status'] == true) {
          print(data['status']);
          final otp = data['data']['otp']?.toString() ?? '';
          NavigationHelper.navigateToReplacement(
            context,
            OtpScreen(otpFromServer: otp, mobile: mobileNumber),
          );
        } else {
          print(data['status']);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Signup failed')),
          );
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Signup failed')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (kDebugMode) print("Signup error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    } finally {
      isLoading = false;
    }
  }

  Future<Map<String, dynamic>?> resendOtp(
    BuildContext context,
    String mobile,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/driver/v1/auth/resend-otp"),
        // same endpoint for resend OTP
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"mobile": mobile}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Failed to resend OTP')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      return null;
    }
  }

  Future<Map<String, dynamic>?> verifyOtp({
    required BuildContext context,
    required String mobile,
    required String otp,
  }) async {
    try {
      isLoading = true;

      final response = await http.post(
        Uri.parse("$baseUrl/driver/v1/auth/verify-otp"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"mobile": mobile, "otp": otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        final accessToken = data['data']['access_token'] ?? "";
        final registration = data['data']['registration_progress'] ?? {};

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("access_token", accessToken);
        await prefs.setBool(
          "is_registered",
          registration['is_registered'] ?? false,
        );
        await prefs.setInt("current_step", registration['current_step'] ?? 1);

        debugPrint(" Access Token Saved: $accessToken");
        debugPrint(" is_registered: ${registration['is_registered']}");
        debugPrint(" current_step: ${registration['current_step']}");

        return {
          "is_registered": registration['is_registered'] ?? false,
          "current_step": registration['current_step'] ?? 1,
        };
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "OTP verification failed")),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
      return null;
    } finally {
      isLoading = false;
    }
  }

  /// Upload image to API
  Future<String?> uploadImage(File file) async {
    try {
      isLoading = true;

      final uri = Uri.parse("$baseUrl/common/upload-image");

      // Retrieve access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";

      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
      final mimeParts = mimeType.split('/');

      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $accessToken';

      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // backend key name
          file.path,
          contentType: MediaType(mimeParts[0], mimeParts[1]),
          filename: basename(file.path),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        print(data['data']['filePath']);
        // Return uploaded file URL
        return data['data']['filePath'];
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(data['message'] ?? "Status failed")),
        // );
        debugPrint("Upload failed: ${data['message']}");
        return null;
      }
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> DeleteImage(String filePath) async {
    try {
      isLoading = true;

      final uri = Uri.parse("$baseUrl/common/delete-image");

      // Retrieve access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";

      // Build request body
      final body = jsonEncode({"filePath": filePath});

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: body,
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        debugPrint(" Image deleted: $filePath");
        return true;
      } else {
        debugPrint("Delete failed: ${data['message']}");
        return false;
      }
    } catch (e) {
      debugPrint(" Error deleting image: $e");
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> submitStep(
    BuildContext context, {
    required int stepNumber,
    required Map<String, dynamic> body,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Example URL logic based on step
      String url = "";
      if (stepNumber == 1) {
        url = "$baseUrl/driver/v1/registration/step1-personal-info";
      } else if (stepNumber == 2) {
        url = "$baseUrl/driver/v1/registration/step2-driver-details";
      } // add other steps as needed
      else if (stepNumber == 3) {
        url = "$baseUrl/driver/v1/registration/step3-vehicle-details";
      } // add other steps as needed
      else if (stepNumber == 4) {
        url = "$baseUrl/driver/v1/registration/step4-add-attachments";
      } else if (stepNumber == 5) {
        url = "$baseUrl/driver/v1/registration/step5-set-pricing";
      } else if (stepNumber == 6) {
        url = "$baseUrl/driver/v1/registration/step6-bank-aadhar-details";
      } else if (stepNumber == 7) {
        url = "$baseUrl/driver/v1/registration/step7-review-submit";
      }
      // Get access token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token") ?? "";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // pass token
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Status failed")),
        );
        debugPrint("Step $stepNumber API error: ${data['message']}");
        return false;
      }
    } catch (e) {
      debugPrint("Error in step $stepNumber API: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchVehicleAttachments(
    BuildContext context,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final url = Uri.parse(
        '$baseUrl/driver/v1/registration/vehicle-attachments-list',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        VehicleItem? vehicle;
        List<AttachmentItem> attachments = [];

        if (data['status'] == true) {
          if (data['data']['vehicle'] != null) {
            vehicle = VehicleItem.fromJson(data['data']['vehicle']);
          }

          if (data['data']['attachments'] != null) {
            attachments = (data['data']['attachments'] as List)
                .map((e) => AttachmentItem.fromJson(e))
                .toList();
          }
        }

        return {'vehicle': vehicle, 'attachments': attachments};
      } else {
        debugPrint('Failed to fetch attachments: ${response.statusCode}');
        return {'vehicle': null, 'attachments': []};
      }
    } catch (e) {
      debugPrint('Error in fetchVehicleAttachments: $e');
      return {'vehicle': null, 'attachments': []};
    }
  }

  Future<Map<String, dynamic>> fetchVehicleMasterData(
    BuildContext context,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/driver/v1/vehicle-types/master-data'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return data['data']; // ✅ raw API data
      }

      return {
        'vehicle_types': [],
        'brands': [],
        'models': [],
        'horsepowers': [],
      };
    } catch (e) {
      debugPrint("Master data error: $e");
      return {
        'vehicle_types': [],
        'brands': [],
        'models': [],
        'horsepowers': [],
      };
    }
  }

  Future<Map<String, dynamic>?> fetchReviewSummary(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final url = Uri.parse(
        'http://3.144.118.25:9032/driver/v1/registration/progress',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          return json['data']['step_details'];
        } else {
          debugPrint("⚠️ API returned false status: ${json['message']}");
          return null;
        }
      } else {
        debugPrint("API failed: ${response.statusCode} ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint(" Error fetching review summary: $e");
      return null;
    }
  }

  // Future<List<AttachmentItem>> fetchVehicleAttachments(BuildContext context) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('access_token') ?? '';
  //
  //     final url = Uri.parse('http://3.144.118.25:9032/driver/v1/registration/vehicle-attachments-list'); // your GET endpoint
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //         'Content-Type': 'application/json',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       if (data['status'] == true && data['data']?['attachments'] != null) {
  //         final List attachments = data['data']['attachments'];
  //
  //         return attachments.map((e) => AttachmentItem.fromJson(e)).toList();
  //       } else {
  //         debugPrint("⚠️ No attachments found in response");
  //         return [];
  //       }
  //     } else {
  //       debugPrint("❌ Failed with ${response.statusCode}: ${response.body}");
  //       return [];
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Error in fetchVehicleAttachments: $e");
  //     return [];
  //   }
  // }
}
