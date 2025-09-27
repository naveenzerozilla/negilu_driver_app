import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'language_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LanguageScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8CCB2C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/animations/logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 100),
            Lottie.asset(
              'assets/animations/tractorLottieA.json',
              width: 400,
              height: 100,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
