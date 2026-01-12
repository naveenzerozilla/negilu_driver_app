import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_shared_package/components/utils/navigate.dart';
import 'package:negilu_shared_package/core/enums.dart';

import '../../Provider/booking_otp_notifier.dart';
import '../../Provider/dashboard_provider.dart';
import '../../utils/custom_button.dart';
import 'Dashboard_screen.dart';
import 'booking_Details.dart';

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, bool>(
  (ref) => AvailabilityNotifier(),
);
Future<List<dynamic>>? _newBookingsFuture;

class BookingScreeen extends ConsumerStatefulWidget {
  const BookingScreeen({super.key});

  @override
  _BookingScreeenState createState() => _BookingScreeenState();
}

class _BookingScreeenState extends ConsumerState<BookingScreeen> {
  @override
  void initState() {
    super.initState();

    final notifier = ref.read(availabilityProvider.notifier);

    // 🔹 Initial load for FutureBuilder
    _newBookingsFuture = notifier.fetchDriverBookings(
      context: context,
      page: 1,
      limit: 10,
      status: "in_progress",
    );

    // 🔹 Load completed bookings (provider-based)
    notifier.fetchCompletedBookings(context: context, page: 1, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // New Bookings
            FutureBuilder<List<dynamic>>(
              future: _newBookingsFuture,
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return const Center(child: CircularProgressIndicator());
                // }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No data found");
                }

                final bookings = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sectionTitle("New Bookings"),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8CCB2C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "${bookings.length} new",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...bookings.map((booking) {
                      final farmer = booking["farmer"] ?? {};
                      final name =
                          "${farmer["first_name"] ?? ""} ${farmer["last_name"] ?? ""}";

                      return BookingCard(
                        id: booking["id"],
                        name: name,
                        distance: "Nearby",
                        time:
                            "${booking["start_time"]} - ${booking["end_time"]}, ${booking["booking_date"]}",
                        location: booking["farm_address"] ?? "",
                        amount: "₹${booking["estimated_cost"]}",
                        status: booking["status"],
                        servicetype: booking["service_type"],
                        onRefresh: () {},
                      );
                    }).toList(),
                  ],
                );
              },
            ),

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
                      _sectionTitle("Recent Bookings"),
                      const SizedBox(height: 8),
                      const Text("No completed bookings"),
                    ],
                  );
                }

                final bookings = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Recent Bookings"),
                    const SizedBox(height: 8),

                    ...bookings.map((booking) {
                      final farmer = booking["farmer"] ?? {};
                      final name =
                          "${farmer["first_name"] ?? ""} ${farmer["last_name"] ?? ""}";

                      return InkWell(
                        onTap: () {
                          goTo(
                            context,
                            BookingDetailPage(bookingId: booking["id"] ?? ""),
                          );
                        },
                        child: BookingCard(
                          id: booking["id"] ?? "",
                          name: name,
                          distance: booking["distance"] ?? "Nearby",
                          time:
                              "${booking["start_time"]} - ${booking["end_time"]}, ${booking["booking_date"]}",
                          location: booking["farm_address"] ?? "",
                          amount:
                              "₹${booking["final_cost"] ?? booking["estimated_cost"] ?? ""}",
                          status: booking["status"] ?? "",
                          servicetype: booking["service_type"] ?? "",
                          onRefresh: () {},
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

class BookingCard extends StatefulWidget {
  final VoidCallback onRefresh;
  final String id, name, distance, time, location, amount;
  final String status;
  final String servicetype;

  const BookingCard({
    super.key,
    required this.onRefresh,
    required this.id,
    required this.name,
    required this.distance,
    required this.time,
    required this.location,
    required this.amount,
    required this.status,
    required this.servicetype,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  String? _locationOtp;

  @override
  Widget build(BuildContext context) {
    // final isPending = widget.status; // == "pending";
    final bool isPending = widget.status == "pending";
    final bool isConfirmed = widget.status == "confirmed";

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFDFFF9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 0,
            spreadRadius: 2,
            offset: const Offset(0, 2),
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
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFE5F3D6),
                          // light green bg
                          child: Text(
                            widget.name.isNotEmpty
                                ? widget.name.trim()[0].toUpperCase()
                                : "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8CCB2C), // primary green
                            ),
                          ),
                        ),

                        // CircleAvatar(
                        //   radius: 22,
                        //   backgroundColor: Colors.grey.shade200,
                        //   child: SvgPicture.asset(
                        //     'assets/animations/person_icon.svg',
                        //     width: 20,
                        //     height: 20,
                        //     color: Color(0xFF8CCB2C),
                        //   ),
                        // ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 3),
                                // Container(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 6,
                                //     vertical: 2,
                                //   ),
                                //   decoration: BoxDecoration(
                                //     color: Color(0xFF8CCB2C),
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: Text(
                                //     "New",
                                //     style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 12,
                                //       fontWeight: FontWeight.w500,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "8.5 km away",
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
                    Text(
                      widget.amount,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF8CCB2C),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.status == "cancelled"
                            ? Colors.red.shade100
                            : widget.status == "in_progress"
                            ? const Color(0xFFE8F5E9) // light green
                            : widget.status == "completed"
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.status == "in_progress"
                            ? "Active"
                            : widget.status == "completed"
                            ? "Completed"
                            : widget.status == "cancelled"
                            ? "Cancelled"
                            : widget.status,
                        style: TextStyle(
                          color: widget.status == "cancelled"
                              ? Colors.red.shade800
                              : widget.status == "in_progress"
                              ? const Color(0xFF2E7D32) // dark green
                              : widget.status == "completed"
                              ? Colors.blue.shade800
                              : Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
                  widget.distance,
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
                // Icon(
                //   Icons.location_on_outlined,
                //   color: Color(0xFF6B7280),
                //   size: 22,
                // ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Text(
                    widget.location,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF020817),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
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
                  widget.servicetype,
                  style: const TextStyle(
                    color: Color(0xFF020817),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            isConfirmed ||isPending
                ? Container(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: _buildConfirmButton(context, widget.id),
                    // isPending
                    //     ? _buildConfirmButton(context)
                    //     : isConfirmed
                    //     ? _buildAcceptRejectButtons(context)
                    //     : const SizedBox(),
                  )
                : Container(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child:
                        //   Row(
                        //     children: [
                        widget.status == "in_progress"
                        ? Consumer(
                            builder: (context, ref, _) {
                              return OutlinedButton(
                                onPressed: () async {
                                  goTo(
                                    context,
                                    BookingDetailPage(
                                      bookingId: widget.id ?? "",
                                    ),
                                  );
                                },

                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.lightGreen,
                                    width: 2.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  minimumSize: const Size.fromHeight(52),
                                ),
                                child: const Text(
                                  'View Booking',
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          )
                        : Container(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, String bookingId) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomButton(
          text: "Confirm",
          buttonType: ButtonType.filled,
          onPressed: () async {
            final notifier = ref.read(availabilityProvider.notifier);

            _showLoader(context);

            final response = await notifier.confirmBookingApi(
              bookingId: widget.id,
            );

            if (!context.mounted) return;
            Navigator.pop(context);

            if (response != null && response["status"] == true) {
              final otp = response["data"]["location_otp"];

              // ✅ FIX IS HERE
              ref.read(bookingOtpProvider.notifier).saveOtp(widget.id, otp);

              goTo(context, BookingDetailPage(bookingId: bookingId ?? ""));

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Booking confirmed"),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              goTo(context, BookingDetailPage(bookingId: bookingId ?? ""));
              // _showError(context, "Failed to confirm booking");
            }
          },
        );
      },
    );
  }
}

void _showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

Widget _sectionTitle(String text) {
  return Text(
    text,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}
