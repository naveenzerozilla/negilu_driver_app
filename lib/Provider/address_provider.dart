import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/profile_model.dart';

class AddressProvider extends ChangeNotifier {
  bool isLoading = false;

  List<StateModel> states = [];
  List<DistrictModel> districts = [];
  List<TalukModel> taluks = [];
  List<HobliModel> hoblis = [];
  List<VillageModel> villages = [];

  // selected IDs
  String? selectedStateId;
  String? selectedDistrictId;
  String? selectedTalukId;
  String? selectedHobliId;
  String? selectedVillageId;
  void selectState(String? id) {
    selectedStateId = id;
    selectedDistrictId = null;
    selectedTalukId = null;
    selectedHobliId = null;
    selectedVillageId = null;
    notifyListeners();
  }

  void selectDistrict(String? id) {
    selectedDistrictId = id;
    selectedTalukId = null;
    selectedHobliId = null;
    selectedVillageId = null;
    notifyListeners();
  }

  void selectTaluk(String? id) {
    selectedTalukId = id;
    selectedHobliId = null;
    selectedVillageId = null;
    notifyListeners();
  }

  void selectHobli(String? id) {
    selectedHobliId = id;
    selectedVillageId = null;
    notifyListeners();
  }

  void selectVillage(String? id) {
    selectedVillageId = id;
    notifyListeners();
  }
  void clearSelection() {
    selectedStateId = null;
    selectedDistrictId = null;
    selectedTalukId = null;
    selectedHobliId = null;
    selectedVillageId = null;
    notifyListeners();
  }

  Future<void> loadAddressData() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString("access_token") ?? "";

      final response = await http.get(
        Uri.parse("http://3.144.118.25:9032/driver/v1/address-data"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      debugPrint("Address API status: ${response.statusCode}");
      debugPrint("Address API body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception("Address API failed");
      }

      final decoded = jsonDecode(response.body);

      if (decoded == null || decoded["data"] == null) {
        throw Exception("Address data is null");
      }

      final data = decoded["data"];

      states = (data["states"] as List? ?? [])
          .map((e) => StateModel(id: e["id"], name: e["name"]))
          .toList();

      districts = (data["districts"] as List? ?? [])
          .map(
            (e) => DistrictModel(
          id: e["id"],
          name: e["name"],
          stateId: e["state_id"],
        ),
      )
          .toList();

      taluks = (data["taluks"] as List? ?? [])
          .map(
            (e) => TalukModel(
          id: e["id"],
          name: e["name"],
          districtId: e["district_id"],
        ),
      )
          .toList();

      hoblis = (data["hoblis"] as List? ?? [])
          .map(
            (e) => HobliModel(
          id: e["id"],
          name: e["name"],
          talukId: e["taluk_id"],
        ),
      )
          .toList();

      villages = (data["villages"] as List? ?? [])
          .map(
            (e) => VillageModel(
          id: e["id"],
          name: e["name"],
          hobliId: e["hobli_id"], // ✅ fixed typo
        ),
      )
          .toList();
    } catch (e) {
      debugPrint("Address load error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  List<DistrictModel> get filteredDistricts =>
      districts.where((d) => d.stateId == selectedStateId).toList();

  List<TalukModel> get filteredTaluks =>
      taluks.where((t) => t.districtId == selectedDistrictId).toList();

  List<HobliModel> get filteredHoblis =>
      hoblis.where((h) => h.talukId == selectedTalukId).toList();

  List<VillageModel> get filteredVillages =>
      villages.where((v) => v.hobliId == selectedHobliId).toList();
}
