import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:streammly/models/company/speciality_model.dart';

import '../data/repository/company_repo.dart';
import '../models/category/sub_category_model.dart';
import '../models/category/sub_vertical_model.dart';
import 'package:streammly/models/company/company_location.dart';
import '../models/company/specialized_in.dart';

class CompanyController extends GetxController {
  final CompanyRepo companyRepo;

  CompanyController({required this.companyRepo});

  final List<Speciality> specialities = [];
  bool isSpecialityLoading = false;

  final List<SpecializedItem> specialized = [];
  bool isSpecializedLoading = false;

  var companies = <CompanyLocation>[];
  var isLoading = true;

  CompanyLocation? selectedCompany;
  int selectedCategoryId = 1;

  final List<CompanySubCategory> subCategories = [];
  final List<SubVertical> subVerticals = [];

  final List<Map<String, String>> subVerticalCards = [];
  bool isSubVerticalLoading = false;

  Position? userPosition;

  Future<Position> _getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
      ),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  String _estimateTimeFromDistance(double distanceKm) {
    const speed = 15.0; // km/h average
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
      isLoading = true;
      update();

      userPosition = await _getCurrentLocation();
      final lat = userPosition?.latitude;
      final lng = userPosition?.longitude;

      if (lat == null || lng == null) {
        throw "Location not available";
      }

      final data = await companyRepo.fetchCompaniesByCategory(
        categoryId,
        userLat: lat,
        userLng: lng,
      );

      for (var company in data) {
        if (company.latitude != null && company.longitude != null) {
          final distance = calculateDistance(
            lat,
            lng,
            company.latitude!,
            company.longitude!,
          );
          company.distanceKm = distance;
          company.estimatedTime = _estimateTimeFromDistance(distance);
        }
      }

      companies.assignAll(data);
    } catch (e) {
      companies.clear();
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchCompanyById(int companyId) async {
    try {
      userPosition ??= await _getCurrentLocation();
      final lat = userPosition?.latitude;
      final lng = userPosition?.longitude;

      if (lat == null || lng == null) {
        throw "Location not available";
      }

      final company = await companyRepo.fetchCompanyById(
        companyId,
        userLat: lat,
        userLng: lng,
      );

      selectedCompany = company;
      update();
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> fetchCompanySubCategories(int companyId) async {
    try {
      final data = await companyRepo.fetchCompanySubCategories(companyId);
      subCategories
        ..clear()
        ..addAll(
          data.map((e) => CompanySubCategory.fromJson(e['subcategory'])),
        );
      update();
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    }
  }

  Future<void> fetchSubVerticals(int companyId, int subCategoryId) async {
    try {
      final data = await companyRepo.fetchSubVerticals(
        companyId: companyId,
        subCategoryId: subCategoryId,
      );
      subVerticals
        ..clear()
        ..addAll(data.map((e) => SubVertical.fromJson(e)));
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

      final data = await companyRepo.fetchSubVerticals(
        companyId: companyId,
        subCategoryId: subCategoryId,
      );

      subVerticalCards
        ..clear()
        ..addAll(
          data.map<Map<String, String>>((item) {
            final rawPath = item["image"]?.toString() ?? "";
            final cleanedPath = rawPath.replaceFirst(RegExp(r'^/+'), '');
            final imageUrl = cleanedPath.isNotEmpty ? cleanedPath : "";

            return {
              "id": item["id"].toString(),
              "image": imageUrl,
              "label": item["title"] ?? "Untitled"
            };
          }),
        );
    } catch (e) {
      Get.snackbar("Exception", "Something went wrong: $e");
    } finally {
      isSubVerticalLoading = false;
      update();
    }
  }

  Future<CompanyLocation?> fetchAndCacheCompanyById(int companyId) async {
    try {
      userPosition ??= await _getCurrentLocation();
      final lat = userPosition?.latitude;
      final lng = userPosition?.longitude;

      if (lat == null || lng == null) {
        throw "Location not available";
      }

      final company = await companyRepo.fetchCompanyById(
        companyId,
        userLat: lat,
        userLng: lng,
      );

      if (company != null &&
          !companies.any((c) => c.id == company.id)) {
        companies.add(company);
      }

      update();
      return company;
    } catch (e) {
      Get.snackbar("Error", "Could not load vendor $companyId: $e");
      return null;
    }
  }

  Future<void> fetchSpecialized(int companyId) async {
    try {
      isSpecializedLoading = true;
      update();

      final data = await companyRepo.fetchSpecialized(companyId);
      specialized
        ..clear()
        ..addAll(data.map((e) => SpecializedItem.fromJson(e)));

      print("🔍 Specialized fetched: ${specialized.map((s) => s.title).toList()}");
      update();
    } catch (e) {
      specialized.clear();
      // Get.snackbar(
      //   "Error",
      //   "Could not fetch specialization: ${e.toString()}",
      // );
      update();
    } finally {
      isSpecializedLoading = false;
      update();
    }
  }

  Future<void> fetchSpecialities() async {
    try {
      isSpecialityLoading = true;
      update();

      final data = await companyRepo.fetchSpecialities();
      specialities
        ..clear()
        ..addAll(data);
    } catch (e) {
      specialities.clear();
      // Get.snackbar("Error", "Could not fetch specialities: ${e.toString()}");
    } finally {
      isSpecialityLoading = false;
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

  /// Lifecycle improvement
  @override
  void onInit() {
    super.onInit();
    // Only DNS/cache-independent minimal setup here
  }

  @override
  void onReady() {
    super.onReady();
    // Fetch data after the widget is rendered to avoid blocking initial UI
    fetchCompaniesByCategory(selectedCategoryId);
  }

  @override
  void onClose() {
    // Cleanup future streams / controllers here if added later
    super.onClose();
  }
}
