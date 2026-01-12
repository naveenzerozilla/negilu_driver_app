import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_shared_package/components/custom_text.dart';

import 'Dashboard_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RideHistory extends ConsumerStatefulWidget {
  const RideHistory({super.key});

  @override
  ConsumerState<RideHistory> createState() => _RideHistoryState();
}

class _RideHistoryState extends ConsumerState<RideHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ride History",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.all(20),
      //
      //   width: double.infinity,
      //   child: ElevatedButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Scaffold(
      //             appBar: AppBar(
      //               title: const Text('Profile'),
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
      //       "View All Bookings",
      //       style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Easily track your past, upcoming, and cancelled bookings.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "See detailed records of all your jobs in one place.Review ride details, payment info, and booking statuses anytime.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: ref
                  .read(availabilityProvider.notifier)
                  .fetchCompletedBookings(context: context, page: 1, limit: 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RideCards(title: "0", amount: "Completed"),
                          SizedBox(width: 10),
                          RideCards(title: "0", amount: "Active"),
                          SizedBox(width: 10),
                          RideCards(title: "0", amount: "Cancelled"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text("No bookings found"),
                    ],
                  );
                }

                final bookings = snapshot.data!;

                final completedCount = bookings
                    .where((b) => b['status'] == 'completed')
                    .length;
                final activeCount = bookings
                    .where((b) => b['status'] == 'in_progress')
                    .length;
                final cancelledCount = bookings
                    .where((b) => b['status'] == 'cancelled')
                    .length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RideCards(
                          title: completedCount.toString(),
                          amount: "Completed",
                        ),
                        const SizedBox(width: 10),
                        RideCards(
                          title: activeCount.toString(),
                          amount: "Active",
                        ),
                        const SizedBox(width: 10),
                        RideCards(
                          title: cancelledCount.toString(),
                          amount: "Cancelled",
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ...bookings.map((booking) {
                      final farmer = booking["farmer"] ?? {};
                      final name =
                          "${farmer["first_name"] ?? ""} ${farmer["last_name"] ?? ""}";

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: RideCard(
                          name: name,
                          distance: booking["distance"] ?? "Nearby",
                          time:
                              "${booking["start_time"]} - ${booking["end_time"]}, ${booking["booking_date"]}",
                          location: booking["farm_address"] ?? "",
                          amount:
                              "₹${booking["final_cost"] ?? booking["estimated_cost"] ?? ""}",
                          status: booking['status'],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _sectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  );
}

class RideCard extends StatelessWidget {
  final String name, distance, time, location, amount;
  final String status;

  const RideCard({
    super.key,
    required this.name,
    required this.distance,
    required this.time,
    required this.location,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // final isPending = status == "pending";
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFDFFF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Tractor + Rotavator",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 2),
                    SizedBox(width: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status == "cancelled"
                            ? Colors.red.shade100
                            : status == "in_progress"
                            ? const Color(0xFFE8F5E9) // light green
                            : status == "completed"
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status == "in_progress"
                            ? "Active"
                            : status == "completed"
                            ? "Completed"
                            : status == "cancelled"
                            ? "Cancelled"
                            : status,
                        style: TextStyle(
                          color: status == "cancelled"
                              ? Colors.red.shade800
                              : status == "in_progress"
                              ? const Color(0xFF2E7D32) // dark green
                              : status == "completed"
                              ? Colors.blue.shade800
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/animations/time.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text(
                  distance,
                  style: const TextStyle(
                    color: Color(0xFF020817),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                SvgPicture.asset(
                  'assets/animations/location_icon.svg',
                  width: 20,
                  height: 20,
                ),

                SizedBox(width: 10),
                Text(
                  location,
                  style: const TextStyle(
                    color: Color(0xFF020817),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/animations/truck_icon.svg',
                  width: 20,
                  height: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Tractor + Rotavator",
                  style: const TextStyle(
                    color: Color(0xFF020817),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RideCards extends StatelessWidget {
  final String title, amount;

  RideCards({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 100,
        height: 80,
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF8CCB2C),

                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
