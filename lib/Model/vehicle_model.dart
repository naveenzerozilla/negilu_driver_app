class VehicleType {
  final String id;
  final String name;
  final String category;

  VehicleType({
    required this.id,
    required this.name,
    required this.category,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'],
      name: json['name'],
      category: json['category'],
    );
  }
}
class Brand {
  final String id;
  final String name;
  final String category;

  Brand({
    required this.id,
    required this.name,
    required this.category,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      name: json['brand_name'], // ✅ correct
      category: json['category'],
    );
  }
}
class VehicleModel {
  final String id;
  final String brandId;
  final String? displayName;

  VehicleModel({
    required this.id,
    required this.brandId,
    required this.displayName,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      brandId: json['brand_id'],
      displayName: json['display_name'],
    );
  }
}



class HorsePower {
  final String id;
  final String displayRange;
  final String category;

  HorsePower({
    required this.id,
    required this.displayRange,
    required this.category,
  });

  factory HorsePower.fromJson(Map<String, dynamic> json) {
    return HorsePower(
      id: json['id'],
      displayRange: json['display_range'],
      category: json['category'],
    );
  }
}
