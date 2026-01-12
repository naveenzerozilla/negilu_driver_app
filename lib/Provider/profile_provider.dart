import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/Repository/profile_repository.dart';
import '../core/profile_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileState _state = const ProfileState(isLoading: true);

  ProfileState get state => _state;

  ProfileProvider(this.repository);

  Future<void> loadProfile() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    try {
      final profile = await repository.fetchProfile();
      _state = ProfileState(profile: profile, isLoading: false);
    } catch (e) {
      _state = ProfileState(error: e.toString(), isLoading: false);
    }

    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String profileImage,
    required String mobileNumber,
    required String emailId,
    required String gender,
    required String stateId,
    required String districtId,
    required String talukId,
    required String hobliId,
    required String villageId,
  }) async {
    _state = _state.copyWith(isLoading: true);
    await loadProfile();
    notifyListeners();

    final success = await repository.updateProfile(
      fullName: fullName,
      profileImage: profileImage,
      mobileNumber: mobileNumber,
      emailId: emailId,
      gender: gender,
      stateId: stateId,
      districtId: districtId,
      talukId: talukId,
      hobliId: hobliId,
      villageId: villageId,
    );

    if (success) {
      await loadProfile(); // 🔄 refresh profile
    } else {
      _state = _state.copyWith(isLoading: false);
      notifyListeners();
    }
  }
}
