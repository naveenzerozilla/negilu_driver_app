import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import '../utils/Appstyle.dart';
import '../utils/custom_button.dart';
import 'login_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLang;

  final List<Map<String, String>> languages = [
    {"label": "English", "value": "en"},
    {"label": "हिन्दी", "value": "hi"},
    {"label": "ಕನ್ನಡ", "value": "kn"},
    {"label": "తెలుగు", "value": "te"},
    {"label": "தமிழ்", "value": "ta"},
    {"label": "മലയാളം", "value": "ml"},
    {"label": "मराठी", "value": "mr"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // Logo text
            AppLogo(size: 50, color: const Color(0xFF8CCB2C)),

            const SizedBox(height: 90),
            const Text('Choose your\nLanguage', style: AppTextStyles.heading),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedLang,
                decoration: InputDecoration(
                  labelText: "Select Language",
                  border: OutlineInputBorder(),
                ),
                items: languages.map((lang) {
                  return DropdownMenuItem(
                    value: lang['value'],
                    child: Text(lang['label']!, style: TextStyle(fontSize: 18)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLang = value;
                  });
                },
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.lightGreen,
                  width: 1, // 👈 reduce thickness (default is 1.0)
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    6,
                  ), // 👈 reduce corner radius
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Skip', style: TextStyle(color: Colors.black)),
            ),

            const SizedBox(height: 12),
            CustomButton(
              text: "Continue",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              textStyle: AppTextStyles.buttonStyle, // your existing style
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
