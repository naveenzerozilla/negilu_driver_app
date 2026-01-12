class DriverBooking {
  final String id;
  final String bookingId;
  final String farmAddress;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final String status;
  final String estimatedCost;

  final Farmer farmer;
  final Vehicle vehicle;

  DriverBooking({
    required this.id,
    required this.bookingId,
    required this.farmAddress,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.estimatedCost,
    required this.farmer,
    required this.vehicle,
  });

  factory DriverBooking.fromJson(Map<String, dynamic> json) {
    return DriverBooking(
      id: json['id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      farmAddress: json['farm_address'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'] ?? '',
      estimatedCost: json['estimated_cost'] ?? '0',
      farmer: Farmer.fromJson(json['farmer'] ?? {}),
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
    );
  }
}
class Vehicle {
  final String vehicleNumber;

  Vehicle({required this.vehicleNumber});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleNumber: json['vehicle_number'] ?? '',
    );
  }
}

class Farmer {
  final String firstName;
  final String lastName;
  final String mobile;

  Farmer({
    required this.firstName,
    required this.lastName,
    required this.mobile,
  });

  factory Farmer.fromJson(Map<String, dynamic> json) {
    return Farmer(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}
