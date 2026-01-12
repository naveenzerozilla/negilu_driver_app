import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/core/enums.dart';
import '../Provider/auth_provider.dart';
import '../utils/Appstyle.dart';
import '../utils/customTextfield.dart';
import '../utils/custom_button.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final mobileCtrl = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Consumer<AuthNotifier>(
              builder: (context, authNotifier, child) {
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 22),
                        AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
                        const SizedBox(height: 160),
                        const Text('Welcome Aboard!', style: AppTextStyles.heading),
                        const SizedBox(height: 30),
                        CustomTextField(
                          hintText: "Enter full name",
                          controller: nameCtrl,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          hintText: "Enter mobile number",
                          controller: mobileCtrl,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 30),
                        CustomButton(
                          buttonType: ButtonType.filled,
                          text: "Continue",
                          isLoading: authNotifier.isLoading,
                          onPressed: () {
                            // FocusScope.of(context).unfocus();
                            authNotifier.signupWithMobile(
                              context,
                              nameCtrl.text.trim(),
                              mobileCtrl.text.trim(),
                            );
                          },
                          textStyle: AppTextStyles.buttonStyle,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Log In",
                                  style: const TextStyle(
                                    color: Color(0xFF8CCB2C),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
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
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
