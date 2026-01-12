import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_driver_app/screens/Profile/EditProfile.dart';
import 'package:negilu_driver_app/screens/Profile/Support_screen.dart';
import 'package:negilu_driver_app/screens/Profile/ride_history.dart';
import 'package:negilu_driver_app/screens/login_screen.dart';
import 'package:negilu_shared_package/components/utils/navigate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/driver_profile.dart';
import '../../Provider/profile_provider.dart';
import '../../core/profile_provider.dart';
import 'Settings.dart';
import 'manage_vehicle.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileProvider>().state;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(body: Center(child: Text(state.error!)));
    }

    final profile = state.profile!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Row
                  _ProfileCard(profile: profile),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            6,
                          ), // ← circular radius
                        ),
                        child: _StatItem(icon: Icons.star, label: '4.8'),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            6,
                          ), // ← circular radius
                        ),
                        child: _StatItem(icon: Icons.handshake, label: '127'),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.only(right: 5, left: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            6,
                          ), // ← circular radius
                        ),
                        child: _StatItem(icon: Icons.work, label: '8 Years'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        goTo(context, EditProfilePage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8CCB2C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "View Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Options
            _ProfileTile(
              title: 'Ride History',
              onTap: () {
                goTo(context, RideHistory());
              },
            ),
            _ProfileTile(
              title: 'Manage Vehicles & Attachment',
              onTap: () {
                goTo(context, ManageVehiclesScreen());
              },
            ),
            _ProfileTile(
              title: 'Settings',
              onTap: () {
                goTo(context, SettingScreen());
              },
            ),
            _ProfileTile(
              title: 'Help & Support',
              onTap: () {
                goTo(context, SupportScreen());
              },
            ),

            const SizedBox(height: 130),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: _isLoggingOut
                    ? null
                    : () async {
                        setState(() => _isLoggingOut = true);

                        final prefs = await SharedPreferences.getInstance();

                        // ✅ ALWAYS remove token (don’t set empty string)
                        await prefs.remove("access_token");

                        if (!mounted) return;

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false, // 🔥 clears back stack
                        );
                      },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF1F0),
                  side: const BorderSide(color: Colors.red, width: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: _isLoggingOut
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.red,
                        ),
                      )
                    : const Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
              ),
            ),

            // SizedBox(
            //   width: double.infinity,
            //   height: 50,
            //   child: OutlinedButton(
            //     onPressed: () async {
            //       final prefs = await SharedPreferences.getInstance();
            //       final accessToken = prefs.getString("access_token") ?? "";
            //
            //       if (accessToken.isEmpty) {
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(builder: (context) => LoginScreen()),
            //         );
            //       } else {
            //         await prefs.setString("access_token", "");
            //         Navigator.of(context).pushReplacementNamed('/login');
            //       }
            //     },
            //
            //     style: OutlinedButton.styleFrom(
            //       backgroundColor: Color(0xFFFFF1F0),
            //
            //       side: const BorderSide(color: Colors.red, width: 0.5),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //     ),
            //     child: const Text(
            //       'Logout',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         color: Colors.red,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _ProfileTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 2),

      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD9D9D9),
            blurRadius: 0,
            spreadRadius: 0.4,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0xFFD9D9D9),
            blurRadius: 0,
            spreadRadius: 0.4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(
          title,

          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFFFC107), size: 18),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DriverProfile profile;

  const _ProfileCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.mobileNumber,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 32,
            backgroundImage: profile.profilePic != null
                ? NetworkImage(profile.profilePic!)
                : null,
            child: profile.profilePic == null ? const Icon(Icons.person) : null,
          ),
        ],
      ),
    );
  }
}
