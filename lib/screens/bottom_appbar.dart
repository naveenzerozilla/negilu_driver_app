import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_driver_app/screens/Profile/Booking_screeen.dart';
import 'package:negilu_driver_app/screens/Profile/Earning_screen.dart';

import 'Profile/Dashboard_screen.dart' show DashboardScreen;
import 'Profile/Support_screen.dart';
import 'Profile/profile.dart';

class DashboardLayout extends ConsumerStatefulWidget {
  final int initialIndex;

  const DashboardLayout({
    super.key,
    this.initialIndex = 0, // default Dashboard
  });

  @override
  ConsumerState<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends ConsumerState<DashboardLayout> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    DashboardScreen(), // 👈 remove Center() for safety
    BookingScreeen(),
    EarningScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// 🧭 Top AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/animations/menu_icon.svg',
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            Color(0xff4A4A4A),
            BlendMode.srcIn,
          ),
        ),
        onPressed: () {},
      ),
      title: const Text(
        "Dashboard",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
      ),
      centerTitle: false,
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/animations/notification_icon.svg',
                width: 24,
                height: 24,
                // colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              ),
              onPressed: () {},
            ),
            Positioned(
              right: 6,
              top: 3,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF8CCB2C),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/animations/home_icon.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? Color(0xFF8CCB2C) : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/animations/booking_icon.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? Color(0xFF8CCB2C) : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/animations/earning_icon.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? Color(0xFF8CCB2C) : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/animations/phone_icon.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? Color(0xFF8CCB2C) : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            label: "Support",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/animations/profile_icon.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _currentIndex == 4 ? Color(0xFF8CCB2C) : Colors.grey.shade600,
                BlendMode.srcIn,
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
