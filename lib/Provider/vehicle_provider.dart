import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/Repository/vehicle_repository.dart';
import '../Model/vehicle.dart';
import '../core/network/apiservice.dart';

/// Repository provider
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepository(ApiService());
});

/// API provider
final vehicleAttachmentsProvider = FutureProvider.family<Vehicle, String>((
  ref,
  vehicleId,
) async {
  final repository = ref.read(vehicleRepositoryProvider);
  return repository.getVehicleAttachments(vehicleId);
});
