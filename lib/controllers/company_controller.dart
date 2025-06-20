import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MapController extends GetxController {
  RxList<CompanyLocation> companies = <CompanyLocation>[].obs;
  Rx<CompanyLocation?> selectedCompany = Rx<CompanyLocation?>(null);
  RxInt selectedCategoryId = 1.obs;
  Position? userPosition;

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best));
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  Future<void> fetchCompaniesByCategory(int categoryId) async {
    try {
      userPosition = await _getCurrentLocation();

      final response = await http.get(Uri.parse('http://192.168.1.27:8000/api/v1/basic/getcompanyslocations/$categoryId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        final validCompanies =
            data
                .map((item) {
                  final c = CompanyLocation.fromJson(item);
                  if (c.latitude != null && c.longitude != null && userPosition != null) {
                    c.distanceKm = _calculateDistance(userPosition!.latitude, userPosition!.longitude, c.latitude!, c.longitude!);
                  }
                  return c;
                })
                .where((c) => c.latitude != null && c.longitude != null)
                .toList();

        companies.value = validCompanies;
        print("Loaded ${companies.length} companies for category $categoryId.");
      } else {
        Get.snackbar("Error", "Failed to load company locations");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("Error fetching companies: $e");
    }
  }

  void selectCompany(CompanyLocation company) {
    selectedCompany.value = company;
  }
}

class CompanyLocation {
  final String companyName;
  final double? latitude;
  final double? longitude;
  double? distanceKm;

  CompanyLocation({required this.companyName, required this.latitude, required this.longitude, this.distanceKm});

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    return CompanyLocation(
      companyName: json['company_name'] ?? 'Unknown',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    );
  }
}
