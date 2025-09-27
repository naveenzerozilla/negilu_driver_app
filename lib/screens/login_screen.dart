import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_driver_app/screens/OtpScreen.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import '../utils/Appstyle.dart';
import '../utils/NavigateHelper.dart';
import '../utils/customTextfield.dart';
import '../utils/custom_button.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
            const SizedBox(height: 160),
            const Text('Welcome Back!', style: AppTextStyles.heading),
            const SizedBox(height: 30),

            CustomTextField(
              hintText: "Enter mobile number",
              controller: passCtrl,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 30),
            CustomButton(
              text: "Continue",
              onPressed: () {
                NavigationHelper.navigateToReplacement(
                  context,
                  const OtpScreen(),
                );
              },
              textStyle: AppTextStyles.buttonStyle, // your existing style
            ),
            SizedBox(height: 20),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Don’t have an account? ",
                  style: const TextStyle(
                    color: Colors.black54, // grey for normal text
                    fontSize: 14,
                  ),
                  children: [
                    TextSpan(
                      text: "Sign Up",
                      style: const TextStyle(
                        color: Color(0xFF8CCB2C), // green for Log In
                        fontWeight: FontWeight.w600,
                      ),
                      // 👇 makes it clickable
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // Navigate to login
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
