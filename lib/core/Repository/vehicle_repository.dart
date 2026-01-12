import '../../Model/vehicle.dart';
import '../network/apiservice.dart';

class VehicleRepository {
  final ApiService apiService;

  VehicleRepository(this.apiService);

  Future<Vehicle> getVehicleAttachments(String vehicleId) async {
    final response = await apiService.get(
      "/driver/v1/vehicles/$vehicleId/attachments",
    );

    return Vehicle.fromJson(response['data']);
  }
}
