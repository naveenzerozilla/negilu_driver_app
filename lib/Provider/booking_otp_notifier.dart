import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final bookingOtpProvider =
StateNotifierProvider<BookingOtpNotifier, Map<String, String>>(
      (ref) => BookingOtpNotifier(),
);

class BookingOtpNotifier extends StateNotifier<Map<String, String>> {
  BookingOtpNotifier() : super({});

  void saveOtp(String bookingId, String otp) {
    state = {...state, bookingId: otp};
  }

  String? getOtp(String bookingId) {
    return state[bookingId];
  }

  void clearOtp(String bookingId) {
    final newState = Map<String, String>.from(state);
    newState.remove(bookingId);
    state = newState;
  }
}
