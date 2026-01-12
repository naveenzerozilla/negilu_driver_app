


import '../Model/driver_profile.dart';

abstract class ProfileRepository {
  Future<DriverProfile> fetchProfile();
}
