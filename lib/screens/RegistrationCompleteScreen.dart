import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:negilu_driver_app/screens/Profile/Dashboard_screen.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/components/custom_card.dart';
import 'package:negilu_shared_package/components/custom_text.dart';
import 'package:negilu_shared_package/components/utils/navigate.dart';
import 'package:negilu_shared_package/core/enums.dart';

import '../utils/Appstyle.dart';
import '../utils/custom.dart';
import '../utils/custom_button.dart';
import 'bottom_appbar.dart';
import 'complete_profile.dart';

class RegistrationCompleteScreen extends StatefulWidget {
  const RegistrationCompleteScreen({super.key});

  @override
  State<RegistrationCompleteScreen> createState() =>
      _RegistrationCompleteScreenState();
}

class _RegistrationCompleteScreenState
    extends State<RegistrationCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            AppLogo(size: 50, color: const Color(0xFF8CCB2C)),
            const SizedBox(height: 160),
            Center(
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: const Color(0xFF8CCB2C),
              ),
            ),
            Center(
              child: Text(
                'Registration completed!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: const Text(
                'Your KYC details have been submitted successfully. We’ll review your information and update you soon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            ProfilePhotoTipsCard1(
              title: 'What happens next:',
              tips: [
                '1. Our team will verify all your documents.',
                '2. You’ll receive notification when approved.',
                '3. Once approved, you can start accepting bookings.',
              ],
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
        child: Expanded(
          child: CustomButton(
            text: "Go to Home",
            buttonType: ButtonType.filled,
            onPressed: () {
              goOff(context, DashboardLayout());
            },
            textStyle: AppTextStyles.buttonStyle,
          ),
        ),
      ),
    );
  }
}

// Dummy widget to avoid error (replace with your actual implementation)
class ProfilePhotoTipsCard1 extends StatelessWidget {
  final String title;
  final List<String> tips;

  const ProfilePhotoTipsCard1({
    super.key,
    required this.title,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.orangeAccent),
                SizedBox(width: 5),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Under Review",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(child: Text("Usually Takes 1-2 business days")),
                  ],
                ),
              ],
            ),

            Divider(),
            SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...tips.map((tip) => Text(tip)).toList(),
          ],
        ),
      ),
    );
  }
}
