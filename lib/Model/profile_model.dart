class DriverProfile {
  final String? fullName;
  final String? mobile;
  final String? email;
  final String? stateId;
  final String? districtId;
  final String? talukId;
  final String? hobliId;
  final String? villageId;
  final String? profilePic;

  DriverProfile({
    this.fullName,
    this.mobile,
    this.email,
    this.stateId,
    this.districtId,
    this.talukId,
    this.hobliId,
    this.villageId,
    this.profilePic,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      fullName: json['full_name'],
      mobile: json['mobile_number'],
      email: json['email_id'],
      stateId: json['state_id'],
      districtId: json['district_id'],
      talukId: json['taluk_id'],
      hobliId: json['hobli_id'],
      villageId: json['village_id'],
      profilePic: json['profile_pic'],
    );
  }
}

class StateModel {
  final String id;
  final String name;

  StateModel({required this.id, required this.name});

  factory StateModel.fromJson(Map<String, dynamic> json) =>
      StateModel(id: json['id'], name: json['name']);
}

class DistrictModel {
  final String id;
  final String name;
  final String stateId;

  DistrictModel({required this.id, required this.name, required this.stateId});

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    id: json['id'],
    name: json['name'],
    stateId: json['state_id'],
  );
}

class TalukModel {
  final String id;
  final String name;
  final String districtId;

  TalukModel({required this.id, required this.name, required this.districtId});
}

class HobliModel {
  final String id;
  final String name;
  final String talukId;

  HobliModel({required this.id, required this.name, required this.talukId});
}

class VillageModel {
  final String id;
  final String name;
  final String hobliId;

  VillageModel({required this.id, required this.name, required this.hobliId});
}
