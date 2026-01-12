  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:negilu_driver_app/screens/splash_screen.dart';
  import 'Provider/address_provider.dart';
import 'Provider/auth_provider.dart';
import 'Provider/profile_provider.dart';
import 'core/Repository/profile_repository.dart';

  void main() {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(
      ProviderScope(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthNotifier>(create: (_) => AuthNotifier()),

            ChangeNotifierProvider<ProfileProvider>(
              create: (_) =>
              ProfileProvider(ProfileRepository())..loadProfile(),
            ),
            ChangeNotifierProvider(create: (_) => AddressProvider()),
          ],
          child: const MyApp(),
        ),
      ),
    );
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Negilu Driver',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const SplashScreen(),
      );
    }
  }
