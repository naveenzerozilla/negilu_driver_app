import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_shared_package/components/applogo.dart';

import '../utils/Appstyle.dart';
import '../utils/custom_button.dart';
import 'complete_profile.dart';
import 'login_screen.dart';

/// 1. OTP Screen
class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int secondsRemaining = 30;
  Timer? timer;

  final int otpLength = 5;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    startTimer();

    controllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        setState(() => secondsRemaining--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // Logo text
            AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
            const SizedBox(height: 100),
            const Text(
              "Enter the OTP!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            /// OTP Fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(otpLength, (index) {
                return SizedBox(
                  width: 55,
                  height: 55,
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
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.5,
                        ),
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
                        // move to next
                        FocusScope.of(
                          context,
                        ).requestFocus(focusNodes[index + 1]);
                      } else if (value.isEmpty && index > 0) {
                        // move back on delete
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
            Center(
              child: Text(
                "Resend Code in: 00:${secondsRemaining.toString().padLeft(2, "0")}",
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: "Continue",
              onPressed: () {
                String otp = controllers.map((c) => c.text).join();
                debugPrint("OTP entered: $otp");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CompleteProfileScreen(),
                  ),
                );
              },

              // your existing style
            ),
          ],
        ),
      ),
    );
  }
}


