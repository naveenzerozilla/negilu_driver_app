class DriverProfile {
  final String fullName;
  final String mobileNumber;
  final String? email;
  final String? profilePic;
  final String? gender;

  // 🆕 Address IDs
  final String? stateId;
  final String? districtId;
  final String? talukId;
  final String? hobliId;
  final String? villageId;

  const DriverProfile({
    required this.fullName,
    required this.mobileNumber,
    this.email,
    this.profilePic,
    this.gender,
    this.stateId,
    this.districtId,
    this.talukId,
    this.hobliId,
    this.villageId,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      fullName: json['full_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      email: json['email_id'],
      profilePic: json['profile_image'], // ✅ confirm key
      gender: json['gender'],

      // 🆕 address mapping
      stateId: json['state_id'],
      districtId: json['district_id'],
      talukId: json['taluk_id'],
      hobliId: json['hobli_id'],
      villageId: json['village_id'],
    );
  }
}
