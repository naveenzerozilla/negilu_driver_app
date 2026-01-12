import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // ---------------- FAQ LIST ---------------- //
  bool isLogoutLoading = false;

  List<FAQItem> faqs = [
    FAQItem(
      question: "How do I change my vehicle pricing?",
      answer:
          "You can modify pricing under the Pricing section in your dashboard.",
    ),
    FAQItem(
      question: "What if a customer cancels a booking?",
      answer:
          "Cancellation rules apply based on the customer's cancellation policy.",
    ),
    FAQItem(
      question: "How do I update my documents?",
      answer: "Go to Profile → Documents and upload the latest files.",
    ),
    FAQItem(
      question: "When will I receive my payment?",
      answer: "Payments are processed every Monday and Thursday.",
    ),
    FAQItem(
      question: "How do I add new attachments?",
      answer: "Open booking details → Add Attachments → Upload your file.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.all(20),
      //   height: 200,
      //
      //   width: double.infinity,
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         width: 720,
      //         child: ElevatedButton(
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => Scaffold(
      //                   appBar: AppBar(
      //                     title: const Text('Settings Page'),
      //                     centerTitle: false,
      //                     backgroundColor: Colors.white,
      //                     foregroundColor: Colors.black,
      //                     elevation: 0,
      //                   ),
      //                   body: const Center(child: Text('Profile page')),
      //                 ),
      //               ),
      //             );
      //           },
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: const Color(0xFF8CCB2C),
      //             foregroundColor: Colors.white,
      //             padding: const EdgeInsets.symmetric(vertical: 13),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(12),
      //             ),
      //           ),
      //           child: const Text(
      //             "Contact Support",
      //             style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      //           ),
      //         ),
      //       ),
      //       SizedBox(height: 10),
      //       SizedBox(
      //         width: double.infinity,
      //         height: 50,
      //         child: OutlinedButton(
      //           onPressed: () async {
      //             final prefs = await SharedPreferences.getInstance();
      //             final accessToken = prefs.getString("access_token") ?? "";
      //
      //             if (accessToken.isEmpty) {
      //               Navigator.pushReplacement(
      //                 context,
      //                 MaterialPageRoute(builder: (context) => LoginScreen()),
      //               );
      //             } else {
      //               await prefs.setString("access_token", "");
      //               Navigator.of(context).pushReplacementNamed('/login');
      //             }
      //           },
      //
      //           style: OutlinedButton.styleFrom(
      //             backgroundColor: Color(0xFFFFF1F0),
      //
      //             side: const BorderSide(color: Colors.red, width: 0.5),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(5),
      //             ),
      //           ),
      //           child: const Text(
      //             'Logout',
      //             style: TextStyle(
      //               fontWeight: FontWeight.w600,
      //               color: Colors.red,
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customize the app to work the way you prefer.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Manage your profile, change your language, and set your preferences. Update anytime to keep your experience smooth and personal.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            // Bullet Points
            _bulletPoint("Change language and regional settings"),
            _bulletPoint("Edit profile and contact information"),
            _bulletPoint("Manage notification preferences"),
            const SizedBox(height: 20),

            // Live Chat Card
            _supportCard(
              icon: Icons.language,
              iconColor: Colors.green,
              title: "Language",
              subtitle: "Currently: English",
              onTap: () {
                // Navigate to your Live Chat screen
                print("Live Chat tapped");
              },
            ),

            const SizedBox(height: 12),

            // Call Support Card
            _supportCard(
              icon: Icons.notifications_none_outlined,
              iconColor: Colors.green,
              title: "Notifications",
              subtitle: "Push notifications, alerts",
              onTap: () {
                // launchUrl(Uri.parse("tel:+919876543210"));
              },
            ),

            const SizedBox(height: 12),

            // Email Support Card
            _supportCard(
              icon: Icons.privacy_tip,
              iconColor: Colors.green,
              title: "Privacy & Security",
              subtitle: "Data protection, account security",
              onTap: () {
                // launchUrl(Uri.parse("mailto:support@negilu.com"));
              },
            ),
            const SizedBox(height: 12),

            // Email Support Card
            _supportCard(
              icon: Icons.help_outline,
              iconColor: Colors.green,
              title: "Help & Support",
              subtitle: "FAQs, contact support",
              onTap: () {
                // launchUrl(Uri.parse("mailto:support@negilu.com"));
              },
            ),
            const SizedBox(height: 12),
            _supportCard1(
              title: "+91 98765 43210",
              subtitle: "support@negilu.com",
              onTap: () {
                // launchUrl(Uri.parse("mailto:support@negilu.com"));
              },
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                // SizedBox(
                //   width: 720,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => Scaffold(
                //             appBar: AppBar(
                //               title: const Text('Settings Page'),
                //               centerTitle: false,
                //               backgroundColor: Colors.white,
                //               foregroundColor: Colors.black,
                //               elevation: 0,
                //             ),
                //             body: const Center(child: Text('Profile page')),
                //           ),
                //         ),
                //       );
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFF8CCB2C),
                //       foregroundColor: Colors.white,
                //       padding: const EdgeInsets.symmetric(vertical: 13),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //     ),
                //     child: const Text(
                //       "Contact Support",
                //       style: TextStyle(
                //         fontWeight: FontWeight.w600,
                //         fontSize: 16,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10),
                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: OutlinedButton(
                //     onPressed: isLogoutLoading
                //         ? null
                //         : () async {
                //       setState(() => isLogoutLoading = true);
                //
                //       try {
                //         final prefs = await SharedPreferences.getInstance();
                //         final accessToken = prefs.getString("access_token") ?? "";
                //
                //         if (accessToken.isNotEmpty) {
                //           await prefs.remove("access_token");
                //         }
                //
                //         if (!mounted) return;
                //
                //         Navigator.of(context)
                //             .pushReplacementNamed('/login');
                //       } finally {
                //         if (mounted) {
                //           setState(() => isLogoutLoading = false);
                //         }
                //       }
                //     },
                //     style: OutlinedButton.styleFrom(
                //       backgroundColor: const Color(0xFFFFF1F0),
                //       side: const BorderSide(color: Colors.red, width: 0.5),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5),
                //       ),
                //     ),
                //     child: isLogoutLoading
                //         ? const SizedBox(
                //       height: 22,
                //       width: 22,
                //       child: CircularProgressIndicator(
                //         strokeWidth: 2,
                //         color: Colors.red,
                //       ),
                //     )
                //         : const Text(
                //       'Logout',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w600,
                //         color: Colors.red,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isLogoutLoading
                        ? null
                        : () async {
                            setState(() => isLogoutLoading = true);

                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove("access_token");

                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/login');
                          },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF1F0),
                      side: const BorderSide(color: Colors.red, width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: isLogoutLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // -------------------- FAQ EXPAND ITEM -------------------- //

  Widget _faqItem(FAQItem faq) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() => faq.isExpanded = !faq.isExpanded);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: faq.isExpanded ? 0.5 : 0.0,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),

        // Expandable answer
        if (faq.isExpanded)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF5F6FA),
            ),
            child: Text(
              faq.answer,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),

        const SizedBox(height: 12),
      ],
    );
  }
}

// ---------- Widgets ---------- //

// Bullet point item
Widget _bulletPoint(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    child: Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 8),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    ),
  );
}

// Support Card
Widget _supportCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 0, offset: Offset(0, 0)),
        ],
      ),
      child: Row(
        children: [
          // ICON
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),

          const SizedBox(width: 14),

          // TEXT LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),

          // PUSH ARROW TO RIGHT SIDE
          const Spacer(),

          // RIGHT ARROW
          InkWell(
            onTap: () {},
            child: const Icon(Icons.arrow_forward_ios, size: 18),
          ),
        ],
      ),
    ),
  );
}

Widget _supportCard1({
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 0, offset: Offset(0, 0)),
        ],
      ),
      child: Row(
        children: [
          // ICON

          // TEXT LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact Support",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.call, color: Colors.green, size: 16),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.mail, color: Colors.green, size: 16),
                  SizedBox(width: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// -------------------- TICKET TILE -------------------- //
Widget _ticketTile({
  required String title,
  required String ticketId,
  required String date,
  required String priority,
  required String status,
  required Color statusColor,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + Status Badge
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          "Ticket ID: $ticketId",
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),

        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            Text(
              priority,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    ),
  );
}

class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
