import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompanyMapController extends GetxController {
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
    final speedKmph = 25.0; // You can change this to 5.0 for walking
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

      final response = await http.get(Uri.parse('http://192.168.1.10:8000/api/v1/basic/getcompanyslocations/$categoryId'));

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
      final response = await http.get(Uri.parse("http://192.168.1.10:8000/api/v1/basic/getcompanysprofile/$companyId"));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        final company = CompanyLocation.fromJson(data);
        selectedCompany.value = company;
      } else {
        Get.snackbar("Error", "Failed to fetch company details.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }
}

class CompanyLocation {
  final int? id;
  final String companyName;
  final double? latitude;
  final double? longitude;
  double? distanceKm;
  String? estimatedTime;

  final String? bannerImage;
  final String? logo;
  final String? description;
  final String? categoryName;
  final double? rating;

  CompanyLocation({
    this.id,
    required this.companyName,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
    this.estimatedTime,
    this.bannerImage,
    this.logo,
    this.description,
    this.categoryName,
    this.rating,
  });

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    return CompanyLocation(
      id: json['id'],
      companyName: json['company_name'] ?? 'Unknown',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      bannerImage: json['banner_image'],
      logo: json['logo'],
      description: json['description'],
      categoryName: json['category_name'],
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : 3.9,
    );
  }
}
