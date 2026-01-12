import 'package:flutter/material.dart';
import 'package:negilu_driver_app/core/profile_repository.dart';
import '../Model/driver_profile.dart';

class ProfileState {
  final bool isLoading;
  final DriverProfile? profile;
  final String? error;

  const ProfileState({this.isLoading = false, this.profile, this.error});

  ProfileState copyWith({
    bool? isLoading,
    DriverProfile? profile,
    String? error,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

