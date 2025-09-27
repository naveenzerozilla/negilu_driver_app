import 'package:flutter/material.dart';

import 'Appstyle.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black54),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black26, width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF8CCB2C), width: 2.0),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $hintText';
            }
            return null;
          },
    );
  }
}

class HeadingText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const HeadingText(this.text, {super.key, this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.heading1, // reuse your existing style
      textAlign: textAlign,

    );
  }
}
