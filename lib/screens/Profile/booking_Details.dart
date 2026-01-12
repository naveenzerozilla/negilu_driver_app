import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:negilu_shared_package/core/enums.dart';

import '../../Provider/booking_details_provider.dart';
import '../../Provider/booking_otp_notifier.dart';
import '../../Provider/booking_provider.dart';
import '../../utils/custom_button.dart';
import 'Booking_screeen.dart';

class BookingDetailPage extends ConsumerWidget {
  final String bookingId;

  const BookingDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "BOOKING DETAIL",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: bookingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (booking) {
          final status = booking["status"] as String? ?? "unknown";
          final farmer = booking["farmer"];
          final vehicle = booking["vehicle"];
          final farm = booking["farm_location"];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                status.toLowerCase() == "completed" ||
                        status.toLowerCase() == "cancelled"
                    ? SizedBox()
                    : SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(
                          'assets/animations/driver_location.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),

                _bookingStartCard(
                  context,
                  booking,
                  farmer,
                  vehicle,
                  bookingId,
                  status,
                ),
                const SizedBox(height: 20),
                _bookingCard(context, booking, farmer, farm),
                const SizedBox(height: 20),
                status.toLowerCase() == "completed" ||
                    status.toLowerCase() == "cancelled"
                    ? SizedBox():
                _cancellationPolicy(booking),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _bookingStartCard(
  BuildContext context,
  Map<String, dynamic> booking,
  Map<String, dynamic> farmer,
  Map<String, dynamic> vehicle,
  String bookingId,
  String status,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Vehicle number
                  Text(
                    vehicle["vehicle_number"] ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),

                  /// Vehicle name
                  Text(
                    vehicle["display_name"] ?? "",
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  /// Farmer info
                  Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(
                        farmer["name"] ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Vehicle icon
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green.shade100,
              child: const Icon(Icons.agriculture, color: Colors.green),
            ),
          ],
        ),

        const SizedBox(height: 16),
        // isPending
        //     ? _buildConfirmButton(context)
        //     : isConfirmed
        //     ?
        if (status.toLowerCase() == "confirmed") ...[
          _buildAcceptRejectButtons(context, bookingId),
        ] else if (status.toLowerCase() == "cancelled") ...[
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Booking Cancelled",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ] else if (status.toLowerCase() == "completed") ...[
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8CCB2C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Booking Completed",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: Consumer(
              builder: (context, ref, _) {
                return ElevatedButton(
                  onPressed: () async {
                    // 1️⃣ Open Complete Booking BottomSheet directly
                    await showCompleteBookingSheet(
                      context,
                      ref,
                      bookingId, // ✅ ONLY ID
                    );

                    // 2️⃣ Reload booking list
                    await ref
                        .read(availabilityProvider.notifier)
                        .fetchDriverBookings(
                          context: context,
                          page: 1,
                          limit: 5,
                          status: "in_progress",
                        );

                    // 3️⃣ Reload booking detail page
                    ref.invalidate(bookingDetailProvider(bookingId));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CCB2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Complete Booking",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    ),
  );
}

Future<void> showCompleteBookingSheet(
  BuildContext context,
  WidgetRef ref,
  String bookingId,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => CompleteBookingBottomSheet(bookingId: bookingId),
  );
}

Widget _buildAcceptRejectButtons(BuildContext context, bookingId) {
  return Row(
    children: [
      Expanded(
        child: Consumer(
          builder: (context, ref, _) {
            return OutlinedButton(
              onPressed: () async {
                final bool? result = await _showCancelBookingBottomSheet(
                  context,
                  bookingId,
                );
                if (result == true) {
                  // ✅ RELOAD BOOKING DETAIL PAGE
                  ref.invalidate(bookingDetailProvider(bookingId));
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 2),
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text("Reject"),
            );
          },
        ),
      ),

      const SizedBox(width: 12),

      // -------- ACCEPT --------
      Expanded(
        child: Consumer(
          builder: (context, ref, _) {
            return CustomButton(
              text: "Accept",
              buttonType: ButtonType.filled,
              onPressed: () async {
                final storedOtp = ref
                    .read(bookingOtpProvider.notifier)
                    .getOtp(bookingId);

                if (storedOtp == null) {
                  _showError(context, "OTP not available");
                  return;
                }

                final result = await _showOtpBottomSheet(
                  context,
                  bookingId,
                  storedOtp, // ✅ CORRECT
                  "Enter OTP to proceed",
                );

                if (result == true) {
                  await ref
                      .read(availabilityProvider.notifier)
                      .fetchDriverBookings(
                        context: context,
                        page: 1,
                        limit: 5,
                        status: "in_progress",
                      );

                  // ✅ RELOAD BOOKING DETAIL PAGE
                  ref.invalidate(bookingDetailProvider(bookingId));
                }
              },
            );
          },
        ),
      ),
    ],
  );
}

/// 🔹 Booking Card
Widget _bookingCard(
  BuildContext context,
  Map<String, dynamic> booking,
  Map<String, dynamic> farmer,
  Map<String, dynamic> farm,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow(
          icon: Icons.schedule,
          title: "Scheduled at",
          value:
              "${booking["start_time"]} - ${booking["end_time"]}, ${booking["booking_date"]}",
        ),
        _infoRow(
          icon: Icons.location_on,
          title: "Farm Location",
          value: farm["farm_name"] ?? "",
        ),
        _infoRow(
          icon: Icons.person_outline,
          title: "Booked for",
          value: farmer["name"] ?? "",
        ),
        _infoRow(
          icon: Icons.phone,
          title: "Contact",
          value: farmer["mobile"] ?? "",
          trailing: Icons.chevron_right,
        ),
        _infoRow(
          icon: Icons.receipt_long,
          title: "Total bill",
          value: "₹${booking["estimated_cost"]}",
          subtitle: "Check receipt",
          trailing: Icons.chevron_right,
        ),
        _infoRow(
          icon: Icons.payments,
          title: "Payment mode",
          value: booking["payment_mode"] ?? "Cash",
        ),
      ],
    ),
  );
}

void _showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
}

void _showError(BuildContext context, String msg) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
}

Future<bool?> _showOtpBottomSheet(
  BuildContext context,
  String bookingId,
  String otp,
  String message,
) {
  const int otpLength = 4;

  final List<TextEditingController> controllers = List.generate(
    otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    otpLength,
    (_) => FocusNode(),
  );

  bool isLoading = false;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Enter OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "Enter the OTP shared with the farmer to accept this booking",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),
                    Text("Otp is " + otp, style: TextStyle(color: Colors.grey)),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(otpLength, (index) {
                        return SizedBox(
                          width: 55,
                          height: 62,
                          child: TextField(
                            controller: controllers[index],
                            focusNode: focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF8BC82C),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < otpLength - 1) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[index - 1]);
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                final enteredOtp = controllers
                                    .map((c) => c.text)
                                    .join();

                                if (enteredOtp.length != otpLength) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please enter valid OTP"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                setModalState(() => isLoading = true);

                                final response = await ref
                                    .read(availabilityProvider.notifier)
                                    .acceptBookingApi(
                                      bookingId: bookingId,
                                      otp: enteredOtp,
                                    );

                                if (!context.mounted) return;

                                setModalState(() => isLoading = false);

                                if (response != null &&
                                    response["status"] == true) {
                                  ref
                                      .read(bookingOtpProvider.notifier)
                                      .clearOtp(bookingId);

                                  Navigator.of(context).pop(true);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Booking accepted successfully",
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Invalid OTP or booking expired",
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },

                        // onPressed: isLoading
                        //     ? null
                        //     : () async {
                        //         final otp = controllers
                        //             .map((c) => c.text)
                        //             .join();
                        //
                        //         if (otp.length != otpLength) {
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text("Please enter valid OTP"),
                        //               backgroundColor: Colors.red,
                        //             ),
                        //           );
                        //           return;
                        //         }
                        //
                        //         setModalState(() => isLoading = true);
                        //
                        //         final success = await ref
                        //             .read(availabilityProvider.notifier)
                        //             .acceptBookingApi(
                        //               bookingId: bookingId,
                        //               otp: otp,
                        //             );
                        //
                        //         if (!context.mounted) return;
                        //
                        //         if (success == true) {
                        //           // ✅ CLEAR OTP (important)
                        //           ref
                        //               .read(availabilityProvider.notifier)
                        //               .clearOtp(bookingId);
                        //
                        //           Navigator.pop(
                        //             context,
                        //             true,
                        //           ); // ✅ SEND RESULT TO PARENT
                        //
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text(
                        //                 "Booking accepted successfully",
                        //               ),
                        //               backgroundColor: Colors.green,
                        //             ),
                        //           );
                        //         } else {
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text(
                        //                 "Invalid OTP or booking expired",
                        //               ),
                        //               backgroundColor: Colors.red,
                        //             ),
                        //           );
                        //         }
                        //       },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8CCB2C),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

Future<bool?> _showCancelBookingBottomSheet(
  BuildContext context,
  String bookingId,
) {
  final TextEditingController reasonController = TextEditingController();
  bool isLoading = false;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Cancel Booking",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Please provide a reason for cancelling this booking",
                        style: TextStyle(color: Colors.black),
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        "Reason",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextFormField(
                        controller: reasonController,
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "Enter cancellation reason",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  final reason = reasonController.text.trim();

                                  if (reason.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please enter a reason"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  setModalState(() => isLoading = true);

                                  final success = await ref
                                      .read(availabilityProvider.notifier)
                                      .cancelBookingApi(
                                        bookingId: bookingId,
                                        reason: reason,
                                      );

                                  setModalState(() => isLoading = false);

                                  if (!context.mounted) return;

                                  if (success) {
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Failed to cancel booking",
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Cancel Booking",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}

/// 🔹 Info Row Widget
Widget _infoRow({
  required IconData icon,
  required String title,
  required String value,
  String? subtitle,
  IconData? trailing,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8CCB2C),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) Icon(trailing, color: Colors.grey),
      ],
    ),
  );
}

/// 🔹 Cancellation Policy

Widget _cancellationPolicy1(Map<String, dynamic> booking) {
  // ✅ Show only if booking is cancelled
  // if (booking["status"] != "cancelled") {
  //   return const SizedBox();
  // }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "CANCELLATION DETAILS",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),

        /// Cancel reason
        Text(
          booking["cancelled_reason"] ?? "No reason provided",
          style: const TextStyle(color: Colors.red, fontSize: 13),
        ),

        const SizedBox(height: 6),

        /// Cancelled time (optional)
        if (booking["cancelled_at"] != null)
          Text(
            "Cancelled on: ${booking["cancelled_at"]}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
      ],
    ),
  );
}

Widget _cancellationPolicy(Map<String, dynamic> booking) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "CANCELLATION POLICY",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      const SizedBox(height: 8),
      const Text(
        "Lorem ipsum dolor sit amet consectetur. Ultrices id arcu sed orci. "
        "Lorem ipsum dolor sit amet consectetur. Ultrices id arcu sed orci.",
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: () {},
        child: const Text(
          "Cancel my booking",
          style: TextStyle(color: Color(0xFF8CCB2C)),
        ),
      ),

      const SizedBox(height: 15),
    ],
  );
}

class CompleteBookingBottomSheet extends ConsumerStatefulWidget {
  final String bookingId;

  const CompleteBookingBottomSheet({super.key, required this.bookingId});

  @override
  ConsumerState<CompleteBookingBottomSheet> createState() =>
      _CompleteBookingBottomSheetState();
}

class _CompleteBookingBottomSheetState
    extends ConsumerState<CompleteBookingBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _durationController = TextEditingController();

  bool isSubmitting = false;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8CCB2C), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Complete Booking",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            // COMPLETION NOTES
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: _inputDecoration("Completion Notes"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Completion notes are required";
                }
                if (v.trim().length < 10) {
                  return "Please enter at least 10 characters";
                }
                return null;
              },
            ),

            const SizedBox(height: 12),

            // ACTUAL DURATION
            TextFormField(
              controller: _durationController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _inputDecoration("Actual Duration (hours)"),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Duration is required";
                }
                final value = double.tryParse(v);
                if (value == null || value <= 0) {
                  return "Enter a valid duration";
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => isSubmitting = true);

                        try {
                          await ref
                              .read(bookingRepositoryProvider)
                              .completeBooking(
                                bookingId: widget.bookingId,
                                completionNotes: _notesController.text.trim(),
                                actualDuration: double.parse(
                                  _durationController.text,
                                ),
                              );

                          // 🔄 Reload booking detail + list
                          ref.invalidate(
                            bookingDetailProvider(widget.bookingId),
                          );

                          ref
                              .read(availabilityProvider.notifier)
                              .fetchDriverBookings(
                                context: context,
                                page: 1,
                                limit: 5,
                                status: "in_progress",
                              );

                          Navigator.pop(context);
                        } catch (_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to complete booking"),
                            ),
                          );
                        } finally {
                          setState(() => isSubmitting = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8CCB2C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isSubmitting ? "Submitting..." : "Complete Booking",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
