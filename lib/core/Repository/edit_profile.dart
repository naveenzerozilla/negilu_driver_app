import 'package:dio/dio.dart';

class BookingRepository {
  final Dio dio;

  BookingRepository(this.dio);

  Future<Map<String, dynamic>> fetchBookingDetail(String bookingId) async {
    final response = await dio.get(
      "/driver/v1/bookings/$bookingId",
    );

    if (response.statusCode == 200) {
      return response.data["data"];
    } else {
      throw Exception("Failed to load booking details");
    }
  }
}
