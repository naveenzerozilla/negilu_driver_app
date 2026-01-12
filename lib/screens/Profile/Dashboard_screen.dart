import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:negilu_driver_app/screens/Profile/booking_Details.dart';
import 'package:negilu_driver_app/screens/bottom_appbar.dart';
import 'package:negilu_shared_package/components/utils/navigate.dart';
import 'package:negilu_shared_package/core/enums.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../Provider/auth_provider.dart';
import '../../Provider/booking_otp_notifier.dart';
import '../../Provider/dashboard_provider.dart';
import '../../utils/Appstyle.dart';
import '../../utils/custom_button.dart';

final availabilityProvider = StateNotifierProvider<AvailabilityNotifier, bool>(
  (ref) => AvailabilityNotifier(),
);
Future<List<dynamic>>? _newBookingsFuture;

class DashboardScreen extends ConsumerStatefulWidget {
  DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late Razorpay _razorpay;
  double latitude = 12.9250;
  double longitude = 77.5938;
  bool isSwitchLoading = false;

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

    // 🔹 Razorpay setup
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint("Payment successful: ${response.paymentId}");

    final notifier = ref.read(availabilityProvider.notifier);

    final bool isVerified = await notifier.paymentVerifyApi(
      context: context,
      razorpayOrderId: response.orderId!,
      razorpayPaymentId: response.paymentId!,
      razorpaySignature: response.signature!,
    );

    if (isVerified) {
      Navigator.pop(context);
      await notifier.toggleAvailability(
        context: context,
        isAvailable: true,
        latitude: latitude,
        longitude: longitude,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment verification failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment failed: ${response.code} - ${response.message}");
    setState(() {
      // _statusEnabled = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment failed. Please try again."),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External wallet selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("External wallet selected: ${response.walletName}"),
      ),
    );
  }

  void startDriverPassPayment(String orderId) {
    print("PAyment");
    var options = {
      'key': 'rzp_test_VneipD1TZu0Xav', // <-- Replace with your Razorpay Key
      'order_id': orderId,
      'amount': 50 * 100,
      'name': 'Driver Day Pass',
      'description': 'Unlock unlimited bookings for the selected day',
      'prefill': {
        // Optionally fetch real user contact/email
        'contact': '',
        'email': '',
      },
      'currency': 'INR',
    };
    print(options);

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open payment gateway.")),
      );
    }
  }

  // Bottom sheet must be inside the state so it can call startDriverPassPayment & setState
  void _showDriverPassBottomSheet(BuildContext context) {
    final DateTime startDate = DateTime.now();
    final DateTime endDate = startDate.add(const Duration(hours: 24));

    String formatDateTime(DateTime dateTime) {
      return DateFormat('dd MMM. hh:mm a').format(dateTime);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.78,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 33,
                      height: 33,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(33),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.close, color: Colors.black, size: 15),
                    ),
                  ),
                  SizedBox(width: 10),
                  const Text(
                    "Activate Driver Pass",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Activate Driver Pass Section
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(right: 97, left: 97),
                        child: Text(
                          "Activate Driver Pass to Accept Bookings",
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.only(right: 56, left: 56),
                      child: const Text(
                        "Pay once for the selected day and accept unlimited bookings",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 2),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Text(
                            '50',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'per day',
                            style: TextStyle(fontSize: 14, color: Colors.green),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Driver Pass Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          "Starting Date",
                          formatDateTime(startDate),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow("Ending Date", formatDateTime(endDate)),
                      ],
                    ),

                    Divider(),

                    const SizedBox(height: 8),
                    _buildCheckboxItem(
                      title:
                          "Pass is valid only for the booking date you are accepting.",
                    ),

                    const SizedBox(height: 8),
                    _buildCheckboxItem(
                      title: "Unlock all booking requests for that day.",
                    ),

                    const SizedBox(height: 8),
                    _buildCheckboxItem(
                      title: "Accept unlimited bookings without extra charges.",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Divider
              const Divider(),

              const SizedBox(height: 16),

              // Activate & Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.pop(context); // close bottom sheet first

                    final notifier = ref.read(availabilityProvider.notifier);

                    // 1️⃣ Create order
                    final String? orderId = await notifier.createOrderApi(
                      context: context,
                    );

                    // 2️⃣ Start payment ONLY if orderId exists
                    if (orderId != null) {
                      startDriverPassPayment(orderId);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to create payment order"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8CCB2C),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Activate & Continue",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Expiry info
              const Center(
                child: Text(
                  "Your pass will expire at midnight of the selected date.",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusEnabled = ref.watch(availabilityProvider);
    Future<void> _onRefresh() async {
      final notifier = ref.read(availabilityProvider.notifier);

      setState(() {
        _newBookingsFuture = notifier.fetchDriverBookings(
          context: context,
          page: 1,
          limit: 10,
          status: "in_progress",
        );
      });

      // Optional: refresh completed bookings as well
      await notifier.fetchCompletedBookings(
        context: context,
        page: 1,
        limit: 10,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF8CCB2C),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------- STATUS CARD -------------------
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // STATUS LABEL
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status",
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: statusEnabled
                                    ? Colors.green
                                    : Colors.grey,
                                size: 10,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusEnabled ? "Available" : "Unavailable",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: statusEnabled
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      isSwitchLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Switch.adaptive(
                              activeColor: Color(0xFF8CCB2C),
                              activeTrackColor: Colors.green.withOpacity(0.2),
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.grey.withOpacity(0.4),
                              value: statusEnabled,
                              onChanged: (val) async {
                                if (isSwitchLoading) return;

                                setState(() => isSwitchLoading = true);

                                try {
                                  if (val) {
                                    final canGoOnline = await ref
                                        .read(availabilityProvider.notifier)
                                        .checkOnlineStatusApi(context: context);

                                    if (!canGoOnline) {
                                      _showDriverPassBottomSheet(context);
                                      return;
                                    }

                                    await ref
                                        .read(availabilityProvider.notifier)
                                        .toggleAvailability(
                                          context: context,
                                          isAvailable: true,
                                          latitude: latitude,
                                          longitude: longitude,
                                        );
                                  } else {
                                    await ref
                                        .read(availabilityProvider.notifier)
                                        .toggleAvailability(
                                          context: context,
                                          isAvailable: false,
                                          latitude: latitude,
                                          longitude: longitude,
                                        );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => isSwitchLoading = false);
                                  }
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // New Bookings
              statusEnabled
                  ? FutureBuilder<List<dynamic>>(
                      future: _newBookingsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text("No new bookings");
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
                                onRefresh: _onRefresh,
                              );
                            }).toList(),
                          ],
                        );
                      },
                    )
                  : Container(),

              const SizedBox(height: 20),

              // Earnings Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Earnings Overview"),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      Text(
                        "View Details",
                        style: TextStyle(
                          color: Color(0xFF8CCB2C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF8CCB2C),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  EarningsCard(title: "Today", amount: "₹2500"),
                  SizedBox(width: 10),
                  EarningsCard(title: "This Week", amount: "₹28400"),
                  SizedBox(width: 10),
                  EarningsCard(title: "This Month", amount: "₹112000"),
                ],
              ),
              const SizedBox(height: 20),

              // Quick Actions
              _sectionTitle("Quick Actions"),
              const SizedBox(height: 8),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  InkWell(
                    onTap: () {
                      goTo(
                        context,
                        DashboardLayout(initialIndex: 1), // 👈 Profile tab
                      );
                    },
                    child: QuickActionCard(
                      icon: Icons.book_online,
                      label: "View Bookings",
                      title: "Manage your \nschedule",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      goTo(
                        context,
                        DashboardLayout(initialIndex: 3), // 👈 Profile tab
                      );
                    },
                    child: QuickActionCard(
                      icon: Icons.attach_money,
                      label: "Earnings",
                      title: "Track your income",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      goTo(
                        context,
                        DashboardLayout(initialIndex: 4),
                      );
                    },
                    child: QuickActionCard(
                      icon: Icons.build,
                      label: "Manage Equipment",
                      title: "Update vehicle details",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      goTo(
                        context,
                         DashboardLayout(initialIndex: 4),
                      );
                    },
                    child: QuickActionCard(
                      icon: Icons.person,
                      label: "Profile",
                      title: "Edit your details",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Bookings
              FutureBuilder<List<dynamic>>(
                future: ref
                    .read(availabilityProvider.notifier)
                    .fetchCompletedBookings(
                      context: context,
                      page: 1,
                      limit: 10,
                    ),
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
                            status: booking["status"],
                            servicetype: booking["service_type"] ?? "",
                            onRefresh: _onRefresh,
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
            isConfirmed || isPending
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

class BookingCard1 extends StatelessWidget {
  final String name, distance, time, location, amount;
  final String status;

  const BookingCard1({
    super.key,
    required this.name,
    required this.distance,
    required this.time,
    required this.location,
    required this.amount,
    this.status = "pending",
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == "pending";
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
                          backgroundColor: Colors.grey.shade200,
                          child: SvgPicture.asset(
                            'assets/animations/person_icon.svg',
                            width: 20,
                            height: 20,
                            color: Color(0xFF8CCB2C),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                                SizedBox(width: 3),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8CCB2C),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "New",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
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
                      "₹2,400",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF8CCB2C),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          color: Color(0xFF854D0E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
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
                // Icon(
                //   Icons.location_on_outlined,
                //   color: Color(0xFF6B7280),
                //   size: 22,
                // ),
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
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class EarningsCard extends StatelessWidget {
  final String title, amount;

  const EarningsCard({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 1,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: TextStyle(
                color: Color(0xFF8CCB2C),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, color: Colors.green.shade700, size: 14),
                SizedBox(width: 6),
                Text(
                  "+12%",
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String title;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            label == "View Bookings"
                ? 'assets/animations/booking.svg'
                : label == "Earnings"
                ? 'assets/animations/earning_e.svg'
                : label == "Manage Equipment"
                ? 'assets/animations/manage_eq.svg'
                : 'assets/animations/profile_s.svg',
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4A4A4A),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCheckboxItem({required String title, Widget? child}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(Icons.circle, color: Color(0xFF8CCB2C), size: 10),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF020817),
              ),
            ),
            if (child != null) ...[const SizedBox(height: 8), child],
          ],
        ),
      ),
    ],
  );
}

Widget _buildInfoRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    ],
  );
}
