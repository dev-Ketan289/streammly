import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// Controller to manage company locations
class MapController extends GetxController {
  RxList<CompanyLocation> companies = <CompanyLocation>[].obs;
  Rx<CompanyLocation?> selectedCompany = Rx<CompanyLocation?>(null);
  RxInt selectedCategoryId = 1.obs;

  /// Fetch companies based on categoryId
  Future<void> fetchCompaniesByCategory(int categoryId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.27:8000/api/v1/basic/getcompanyslocations/$categoryId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        // Map to CompanyLocation and filter out null coordinates
        final validCompanies = data.map((item) => CompanyLocation.fromJson(item)).where((c) => c.latitude != null && c.longitude != null).toList();

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

/// Model class for company location
class CompanyLocation {
  final String companyName;
  final double? latitude;
  final double? longitude;

  CompanyLocation({required this.companyName, required this.latitude, required this.longitude});

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    return CompanyLocation(
      companyName: json['company_name'] ?? 'Unknown',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    );
  }
}
