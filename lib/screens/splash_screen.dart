import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'bottom_appbar.dart'; // DashboardLayout

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Optional splash delay
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token");

    if (!mounted) return;

    if (accessToken != null && accessToken.isNotEmpty) {
      // ✅ User already logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardLayout()),
      );
    } else {
      // ❌ User not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8CCB2C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/animations/logo.png', width: 200, height: 200),
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

// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:negilu_driver_app/screens/login_screen.dart';
// import 'bottom_appbar.dart';
// import 'language_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => LoginScreen()),
//         // MaterialPageRoute(builder: (_) => DashboardLayout()),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8CCB2C),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset('assets/animations/logo.png', width: 200, height: 200),
//             const SizedBox(height: 100),
//             Lottie.asset(
//               'assets/animations/tractorLottieA.json',
//               width: 400,
//               height: 100,
//               fit: BoxFit.contain,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
