import 'dart:async';
import 'package:flutter/material.dart';
import 'package:negilu_driver_app/screens/personal_information.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/core/enums.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import '../utils/custom_button.dart';
import 'bottom_appbar.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  final String otpFromServer;
  final String mobile;

  const OtpScreen({
    super.key,
    required this.otpFromServer,
    required this.mobile,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int secondsRemaining = 30;
  Timer? timer;
  bool isResendEnabled = false;
  bool showOtpLabel = true; // show/hide OTP label
  late String currentOtp;

  final int otpLength = 4;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    currentOtp = widget.otpFromServer;

    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());

    startTimer();
    _setupOtpAutoFill();
  }

  /// Basic OTP autofill via clipboard (can replace with sms_autofill package)
  void _setupOtpAutoFill() {
    Timer.periodic(const Duration(seconds: 2), (t) async {
      final clipboardData = await Clipboard.getData('text/plain');
      if (clipboardData != null &&
          clipboardData.text != null &&
          clipboardData.text!.length == otpLength) {
        final otp = clipboardData.text!;
        for (int i = 0; i < otpLength; i++) {
          controllers[i].text = otp[i];
        }
        t.cancel(); // stop timer once OTP auto-filled
      }
    });
  }

  /// Start or reset OTP timer
  void startTimer() {
    setState(() {
      secondsRemaining = 30;
      isResendEnabled = false;
      showOtpLabel = true; // show OTP initially
    });

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        t.cancel();
        setState(() {
          isResendEnabled = true;
          showOtpLabel = false; // hide OTP after timer ends
        });
      }
    });
  }

  /// Resend OTP API call
  Future<void> onResendOtp() async {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final response = await authNotifier.resendOtp(context, widget.mobile);

    if (response != null && response['data'] != null) {
      setState(() {
        currentOtp = response['data']['otp'].toString();
        // clear previous inputs
        for (var c in controllers) c.clear();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("New OTP sent: $currentOtp")));

      startTimer(); // restart timer
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
                  const SizedBox(height: 100),
                  Text(
                    "Enter the OTP ",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (showOtpLabel)
                    Center(
                      child: Text(
                        "Your OTP is: $currentOtp",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),

                  /// OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(otpLength, (index) {
                      return SizedBox(
                        width: 55,
                        height: 62,
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF8BC82C),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < otpLength - 1) {
                              FocusScope.of(
                                context,
                              ).requestFocus(focusNodes[index + 1]);
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(
                                context,
                              ).requestFocus(focusNodes[index - 1]);
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),

                  /// Timer or Resend OTP
                  Center(
                    child: isResendEnabled
                        ? GestureDetector(
                            onTap: authNotifier.isLoading ? null : onResendOtp,
                            child: Text(
                              authNotifier.isLoading
                                  ? "Sending..."
                                  : "Resend OTP",
                              style: const TextStyle(
                                color: Color(0xFF8BC82C),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Text(
                            "Resend code in 00:${secondsRemaining.toString().padLeft(2, "0")}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  CustomButton(
                    buttonType: ButtonType.filled,
                    text: "Continue",
                    isLoading: authNotifier.isLoading,
                    onPressed: () async {
                      String enteredOtp = controllers.map((c) => c.text).join();

                      if (enteredOtp.length != otpLength) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter full OTP"),
                          ),
                        );
                        return;
                      }

                      final result = await authNotifier.verifyOtp(
                        context: context,
                        mobile: widget.mobile,
                        otp: enteredOtp,
                      );

                      if (result != null) {
                        bool isRegistered = result['is_registered'];
                        int currentStep = result['current_step'];

                        if (isRegistered) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DashboardLayout(), // your main screen
                            ),
                          );
                        } else {
                          // 🚀 Not completed → Resume registration from current step
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PersonalInfoScreen(
                                initialStep:
                                    currentStep - 1, // 👈 pass current step
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
