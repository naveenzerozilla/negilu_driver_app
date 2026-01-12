import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';

import '../Model/driver_profile.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ApiClient apiClient;
  final TokenStorage tokenStorage;

  ProfileRepositoryImpl({required this.apiClient, required this.tokenStorage});

  @override
  Future<DriverProfile> fetchProfile() async {
    final token = await tokenStorage.getAccessToken();

    final response = await apiClient.get(
      '/driver/v1/registration/profile',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return DriverProfile.fromJson(response['data']['profile']);
  }
}
