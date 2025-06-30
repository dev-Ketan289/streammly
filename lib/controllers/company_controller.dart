import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../data/repository/company_repo.dart';
import '../models/category/sub_category_model.dart';
import '../models/category/sub_vertical_model.dart';
import '../models/company/company_location.dart';

class CompanyController extends GetxController {
  final CompanyRepo companyRepo;

  CompanyController({required this.companyRepo});

  var companies = <CompanyLocation>[].obs;
  var isLoading = true.obs;

  CompanyLocation? selectedCompany;
  int selectedCategoryId = 1;

  final List<CompanySubCategory> subCategories = [];
  final List<SubVertical> subVerticals = [];

  final List<Map<String, String>> subVerticalCards = [];
  bool isSubVerticalLoading = false;

  Position? userPosition;

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best));
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  String _estimateTimeFromDistance(double distanceKm) {
    const speed = 25.0;
    final timeInHours = distanceKm / speed;
    final minutes = (timeInHours * 60).round();

    if (minutes < 1) return "1 min";
    if (minutes <= 60) return "$minutes mins";
    final hrs = minutes ~/ 60;
    final mins = minutes % 60;
    return "$hrs hr${hrs > 1 ? 's' : ''}${mins > 0 ? ' $mins mins' : ''}";
  }

  Future<void> fetchCompaniesByCategory(int categoryId) async {
    try {
      isLoading.value = true;
      userPosition = await _getCurrentLocation();

      final data = await companyRepo.fetchCompaniesByCategory(categoryId);

      final enrichedCompanies =
          data.map((company) {
            if (company.latitude != null && company.longitude != null && userPosition != null) {
              company.distanceKm = calculateDistance(userPosition!.latitude, userPosition!.longitude, company.latitude!, company.longitude!);
              company.estimatedTime = _estimateTimeFromDistance(company.distanceKm!);
            }
            return company;
          }).toList();

      companies.assignAll(enrichedCompanies);
    } catch (e) {
      companies.clear();
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompanyById(int companyId) async {
    try {
      selectedCompany = await companyRepo.fetchCompanyById(companyId);
      update();
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> fetchCompanySubCategories(int companyId) async {
    try {
      final data = await companyRepo.fetchCompanySubCategories(companyId);
      subCategories.clear();
      subCategories.addAll(data.map((e) => CompanySubCategory.fromJson(e['subcategory'])));
      update();
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> fetchSubVerticals(int companyId, int subCategoryId) async {
    try {
      final data = await companyRepo.fetchSubVerticals(companyId: companyId, subCategoryId: subCategoryId);
      subVerticals.clear();
      subVerticals.addAll(data.map((e) => SubVertical.fromJson(e)));
      update();
    } catch (e) {
      subVerticals.clear();
      update();
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> fetchSubVerticalCards(int companyId, int subCategoryId) async {
    try {
      isSubVerticalLoading = true;
      update();

      final data = await companyRepo.fetchSubVerticals(companyId: companyId, subCategoryId: subCategoryId);

      subVerticalCards.clear();

      subVerticalCards.addAll(
        data.map<Map<String, String>>((item) {
          final rawPath = item["image"]?.toString() ?? "";
          final cleanedPath = rawPath.replaceFirst(RegExp(r'^/+'), '');
          final imageUrl = cleanedPath.isNotEmpty ? "http://192.168.1.113:8000/$cleanedPath" : "";

          return {"id": item["id"].toString(), "image": imageUrl, "label": item["title"] ?? "Untitled"};
        }),
      );
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

  @override
  void onInit() {
    super.onInit();
    fetchCompaniesByCategory(selectedCategoryId);
  }
}
