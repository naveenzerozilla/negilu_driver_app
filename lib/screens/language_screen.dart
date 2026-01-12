import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_shared_package/components/applogo.dart';
import 'package:negilu_shared_package/core/enums.dart';
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
    // {"label": "हिन्दी", "value": "hi"},
    {"label": "ಕನ್ನಡ", "value": "kn"},
    // {"label": "తెలుగు", "value": "te"},
    // {"label": "தமிழ்", "value": "ta"},
    // {"label": "മലയാളം", "value": "ml"},
    // {"label": "मराठी", "value": "mr"},
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                value: _selectedLang,
                decoration: InputDecoration(
                  labelText: "Select Language",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // ✅ Rounded border
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    // You can replace this with any icon (e.g., Icons.arrow_drop_down_circle)
                    color: Colors.black54,
                  ),
                  iconSize: 28,
                ),
                items: languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang['value'],
                    child: Text(
                      lang['label']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLang = value;
                  });
                },
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 300,
                  offset: Offset(0, 6), // adjust dropdown position if needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(22),
                    ), // Change radius here
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),
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
                side: const BorderSide(color: Colors.lightGreen, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text('Skip', style: TextStyle(color: Colors.black)),
            ),

            const SizedBox(height: 12),
            CustomButton(
              buttonType: ButtonType.filled,
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
