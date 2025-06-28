import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/category/sub_category_model.dart';
import '../models/category/sub_vertical_model.dart';
import '../models/company/company_location.dart';

class CompanyController extends GetxController {
  // Reactive states
  var companies = <CompanyLocation>[].obs;
  var isLoading = true.obs;

  CompanyLocation? selectedCompany;
  int selectedCategoryId = 1;

  final List<CompanySubCategory> subCategories = [];
  final List<SubVertical> subVerticals = [];

  final List<Map<String, String>> subVerticalCards = [];
  bool isSubVerticalLoading = false;

  Position? userPosition;

  // Get user's current location
  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );
  }

  // Calculate distance in KM
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  // Estimate time from distance
  String _estimateTimeFromDistance(double distanceKm) {
    const double speedKmph = 25.0;
    final double timeHours = distanceKm / speedKmph;
    final int minutes = (timeHours * 60).round();

    if (minutes < 1) return "1 min";
    if (minutes <= 60) return "$minutes mins";
    final int hours = minutes ~/ 60;
    final int remainingMinutes = minutes % 60;
    return "$hours hr${hours > 1 ? 's' : ''}${remainingMinutes > 0 ? ' $remainingMinutes mins' : ''}";
  }

  // Fetch companies by category
  Future<void> fetchCompaniesByCategory(int categoryId) async {
    try {
      isLoading.value = true;
      userPosition = await _getCurrentLocation();

      final response = await http.get(
        Uri.parse('http://192.168.1.113:8000/api/v1/company/getcompanyslocations/$categoryId'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;

        final loadedCompanies = data.map((item) {
          final company = CompanyLocation.fromJson(item);
          if (company.latitude != null && company.longitude != null && userPosition != null) {
            company.distanceKm = calculateDistance(
              userPosition!.latitude,
              userPosition!.longitude,
              company.latitude!,
              company.longitude!,
            );
            company.estimatedTime = _estimateTimeFromDistance(company.distanceKm!);
          }
          return company;
        }).where((c) => c.latitude != null && c.longitude != null).toList();

        companies.assignAll(loadedCompanies);
      } else {
        companies.clear();
        Get.snackbar("Error", "Failed to load companies.");
      }
    } catch (e) {
      companies.clear();
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch company details
  Future<void> fetchCompanyById(int companyId) async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.113:8000/api/v1/company/getcompanysprofile/$companyId"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final data = jsonData['data'];
        selectedCompany = CompanyLocation.fromJson(data);
        update();
      } else {
        Get.snackbar("Error", "Failed to fetch company details.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  // Fetch subcategories for a company
  Future<void> fetchCompanySubCategories(int companyId) async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.113:8000/api/v1/company/getcompanysubcategories/$companyId"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        subCategories.clear();
        subCategories.addAll(
          data.map((item) => CompanySubCategory.fromJson(item['subcategory'])),
        );
        update();
      } else {
        Get.snackbar("Error", "Failed to load subcategories.");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  // Fetch sub-verticals using POST
  Future<void> fetchSubVerticals(int companyId, int subCategoryId) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.113:8000/api/v1/company/getsubvertical"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"company_id": companyId, "sub_category_id": subCategoryId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        subVerticals.clear();
        subVerticals.addAll(data.map((item) => SubVertical.fromJson(item)));
        update();
      } else {
        subVerticals.clear();
        update();
        Get.snackbar("Error", "Failed to load sub-verticals (${response.statusCode})");
      }
    } catch (e) {
      subVerticals.clear();
      update();
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  // Fetch sub-verticals as card data (used in VendorGroup screen)
  Future<void> fetchSubVerticalCards(int companyId, int subCategoryId) async {
    try {
      isSubVerticalLoading = true;
      update();

      final response = await http.post(
        Uri.parse("http://192.168.1.113:8000/api/v1/company/getsubvertical"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"company_id": companyId, "sub_category_id": subCategoryId}),
      );

      subVerticalCards.clear();

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['success'] == true && jsonBody['data'] is List) {
          subVerticalCards.addAll(
            (jsonBody['data'] as List).map<Map<String, String>>((item) {
              final rawPath = item["image"]?.toString() ?? "";
              final cleanedPath = rawPath.replaceFirst(RegExp(r'^/+'), '');
              final imageUrl =
              cleanedPath.isNotEmpty ? "http://192.168.1.113:8000/$cleanedPath" : "";

              return {
                "id": item["id"].toString(),
                "image": imageUrl,
                "label": item["title"] ?? "Untitled",
              };
            }),
          );
        }
      } else {
        Get.snackbar("Error", "Failed to fetch sub-verticals: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Exception", "Something went wrong: $e");
    } finally {
      isSubVerticalLoading = false;
      update();
    }
  }

  void clearSelectedCompany() {
    selectedCompany = null;
    update();
  }

  void setCategoryId(int id) {
    selectedCategoryId = id;
    update();
  }
}
