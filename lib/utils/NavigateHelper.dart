import 'package:flutter/material.dart';

class NavigationHelper {
  /// Pushes a new screen and replaces the current one
  static void navigateToReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pushes a new screen without replacing
  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Pops the current screen
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
