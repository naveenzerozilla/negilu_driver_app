class Vehicle {
  final String id;
  final String name;
  final String number;
  final List attachments;

  Vehicle({
    required this.id,
    required this.name,
    required this.number,
    required this.attachments,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['vehicle_id'],
      name: json['vehicle_name'],
      number: json['vehicle_number'],
      attachments: json['attachments'] ?? [],
    );
  }
}
