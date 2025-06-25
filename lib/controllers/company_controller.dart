import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../data/repository/company_repo.dart';
import '../models/company/company_location_model.dart';

class CompanyMapController extends GetxController {
  final CompanyRepo companyRepo;
  CompanyMapController({required this.companyRepo});

  RxList<CompanyLocation> companies = <CompanyLocation>[].obs;
  Rx<CompanyLocation?> selectedCompany = Rx<CompanyLocation?>(null);
  RxInt selectedCategoryId = 1.obs;
  Position? userPosition;

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best));
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  String _estimateTimeFromDistance(double distanceKm) {
    final speedKmph = 25.0;
    final timeHours = distanceKm / speedKmph;
    final minutes = (timeHours * 60).round();

    if (minutes < 1) return "1 min";
    if (minutes <= 60) return "$minutes mins";
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return "$hours hr${hours > 1 ? 's' : ''}${remainingMinutes > 0 ? ' $remainingMinutes mins' : ''}";
  }

  Future<void> fetchCompaniesByCategory(int categoryId) async {
    try {
      userPosition = await _getCurrentLocation();
      final response = await companyRepo.getCompaniesByCategory(categoryId);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        final validCompanies =
            data
                .map((item) {
                  final c = CompanyLocation.fromJson(item);
                  if (c.latitude != null && c.longitude != null && userPosition != null) {
                    c.distanceKm = calculateDistance(userPosition!.latitude, userPosition!.longitude, c.latitude!, c.longitude!);
                    c.estimatedTime = _estimateTimeFromDistance(c.distanceKm!);
                  }
                  return c;
                })
                .where((c) => c.latitude != null && c.longitude != null)
                .toList();

        companies.value = validCompanies;
      } else {
        Get.snackbar("Error", "Failed to load companies");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> fetchCompanyById(int companyId) async {
    try {
      final response = await companyRepo.getCompanyById(companyId);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        final company = CompanyLocation.fromJson(jsonData);
        selectedCompany.value = company;
      } else {
        Get.snackbar("Error", "Failed to fetch company details.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}
