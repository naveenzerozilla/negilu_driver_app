import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_driver_app/screens/personal_information.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import '../utils/Appstyle.dart';
import '../utils/custom_button.dart';
class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});

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
            const SizedBox(height: 60),
            const Text("Complete your profile", style: AppTextStyles.heading),

            const SizedBox(height: 8),
            const Text("Complete your registration", style: AppTextStyles.body),

            const SizedBox(height: 160),
            SvgPicture.asset(
              'assets/animations/completeprofile.svg',
              // color: const Color(0xFF8CCB2C), // apply tint color
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Complete Registration",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PersonalInfoScreen()),
                );
              },
              textStyle: AppTextStyles.buttonStyle, // your existing style
            ),
          ],
        ),
      ),
    );
  }
}
