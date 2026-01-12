class VehicleItem {
  final String id;
  final String vehicleTypeId;
  final String brandId;
  final String modelId;
  final String horsepowerId;

  VehicleItem({
    required this.id,
    required this.vehicleTypeId,
    required this.brandId,
    required this.modelId,
    required this.horsepowerId,
  });

  factory VehicleItem.fromJson(Map<String, dynamic> json) {
    return VehicleItem(
      id: json['id'] ?? '',
      vehicleTypeId: json['vehicle_type_id'] ?? '',
      brandId: json['brand_id'] ?? '',
      modelId: json['model_id'] ?? '',
      horsepowerId: json['horsepower_id'] ?? '',
    );
  }
}
