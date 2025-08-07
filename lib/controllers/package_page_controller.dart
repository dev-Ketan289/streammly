import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:streammly/services/constants.dart';

import '../models/company/company_location.dart';
import '../models/package/free_add_on_model.dart';
import '../models/package/paid_addon_model.dart';

class PackagesController extends GetxController {
  final double gstPercentage = 18;

  CompanyLocation? _companyLocation;

  CompanyLocation? get companyLocation => _companyLocation;

  void setCompanyLocation(CompanyLocation location) {
    _companyLocation = location;
    update();
  }

  bool isGridView = false;
  Map<int, bool> expandedStates = {};
  Map<int, Set<String>> selectedHours = {};

  List<Map<String, dynamic>> selectedPackagesForBilling = [];
  Set<int> selectedPackageIndices = {};

  List<Map<String, dynamic>> packages = [];
  bool isLoading = false;

  List<Map<String, dynamic>> popularPackagesList = [];

  List<Map<String, dynamic>> productsInPackageList = [];

  // New: Free Item & Extra Add-On Selections
  Map<String, dynamic> selectedFreeItem = {};
  List<Map<String, dynamic>> selectedExtraAddons = [];

  late int companyId;
  late int subCategoryId;
  late int subVerticalId;
  late int studioId;

  void initialize({
    required int companyId,
    required int subCategoryId,
    required int subVerticalId,
    required int studioId,
  }) {
    this.companyId = companyId;
    this.subCategoryId = subCategoryId;
    this.subVerticalId = subVerticalId;
    this.studioId = studioId;

    // Rest The Package page
    selectedPackageIndices.clear();
    selectedPackagesForBilling.clear();
    selectedFreeItem.clear();
    selectedExtraAddons.clear();
    expandedStates.clear();
    selectedHours.clear();
    fetchPackages();
  }

  String getDurationLabel(Map<String, dynamic> variation) {
    final duration = variation["duration"]?.toString() ?? "";
    final type = (variation["duration_type"] ?? "").toString().toLowerCase();
    if (type.contains("minute")) return "${duration}min";
    if (type.contains("hour")) return "${duration}hr";
    return duration;
  }

  Future<void> fetchPackages() async {
    isLoading = true;
    packages.clear();
    update();

    try {
      final response = await http.post(
        Uri.parse(AppConstants.getPackagesUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "company_id": companyId,
          "subcategory_id": subCategoryId,
          "sub_vertical_id": subVerticalId,
          'studio_id': studioId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List data = jsonBody["data"] ?? [];
        final filteredData =
            data
                .where(
                  (pkg) =>
                      pkg['sub_vertical_id'].toString() ==
                          subVerticalId.toString() ||
                      subVerticalId == 0,
                )
                .toList();

        packages =
            filteredData.map<Map<String, dynamic>>((pkg) {
              final List<dynamic>? variations = pkg["packagevariations"];
              final firstVariation =
                  (variations != null && variations.isNotEmpty)
                      ? variations[0]
                      : null;

              final List<String> hours =
                  variations != null
                      ? variations
                          .map<String>((v) => getDurationLabel(v))
                          .toList()
                      : ["1hr", "2hr", "3hr"];

              final priceMap = {
                for (var v in variations ?? [])
                  getDurationLabel(v):
                      int.tryParse(v["amount"]?.toString() ?? "0") ?? 0,
              };

              return {
                'id': pkg['id'], // <-- Add id here properly
                "title": pkg["title"] ?? "",
                "type": pkg["type"] ?? "N/A",
                "typeId": pkg['type_id'],
                "price": priceMap[getDurationLabel(firstVariation ?? {})] ?? 0,
                "priceMap": priceMap,
                "hours": hours,
                "highlight": pkg["short_description"] ?? "",
                "shortDescription": pkg["long_description"] ?? "",
                "fullDescription": pkg["long_description"] ?? "",
                "termsAndCondition": pkg["terms_and_condition"] ?? "",
                "specialOffer":
                    (pkg["status"] ?? "").toString().toLowerCase() == "active",
                "packageIndex": data.indexOf(pkg),
                "extraQuestions": pkg["packageextra_questions"] ?? [],
                "packagevariations": variations ?? [], // <-- This is important
                'companyId': companyId,
              };
            }).toList();

        expandedStates = {};
        selectedHours = {};
        for (int i = 0; i < packages.length; i++) {
          selectedHours[i] = {packages[i]["hours"].first};
          expandedStates[i] = false;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch packages");
      }
    } catch (e) {
      print("==> Exception during fetch: $e");
      Get.snackbar("Exception", e.toString());
    }

    isLoading = false;
    update();
    print("==> Package fetch completed. Total packages: ${packages.length}");
  }

  bool isFetchingFreeAddOns = false;
  FreeAddOnResponse? freeAddOnResponse;
  int selectedFreeAddOnIndex = -1;

  Future<void> fetchFreeAddOns(int packageId) async {
    isFetchingFreeAddOns = true;
    freeAddOnResponse = null;
    update();

    try {
      final url = Uri.parse(
        '${AppConstants.baseUrl}api/v1/package/getfreeadons/?package_id=$packageId',
      );

      final res = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(res.body);
        freeAddOnResponse = FreeAddOnResponse.fromJson(body);
      } else {
        Get.snackbar(
          "Error",
          "Unable to fetch free add ons (${res.statusCode})",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    }

    isFetchingFreeAddOns = false;
    update();
  }

  bool isFetchingPaidAddOns = false;
  PaidAddOnResponse? paidAddOnResponse;
  int selectedPaidAddOnIndex = -1;

  Future<void> fetchPaidAddOns(int packageId, int studioId) async {
    isFetchingPaidAddOns = true;
    paidAddOnResponse = null;
    selectedPaidAddOnIndex = -1;
    update();
    try {
      final url = Uri.parse(
        'https://admin.streammly.com/api/v1/package/getpaidadons/?package_id=$packageId&studio_id=$studioId',
        // 'http://192.168.1.113:8000/api/v1/package/getpaidadons/?package_id=$packageId&studio_id=$studioId',
      );
      final res = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(res.body);
        paidAddOnResponse = PaidAddOnResponse.fromJson(
          body,
          studioId: studioId,
        );
      }
    } catch (e) {}
    isFetchingPaidAddOns = false;
    update();
  }

  void setSelectedPaidAddOnIndex(int index) {
    selectedPaidAddOnIndex = index;
    update();
  }

  PaidAddOn? get selectedPaidAddOn {
    if (selectedPaidAddOnIndex >= 0 &&
        paidAddOnResponse != null &&
        selectedPaidAddOnIndex < paidAddOnResponse!.addons.length) {
      return paidAddOnResponse!.addons[selectedPaidAddOnIndex];
    }
    return null;
  }

  void setSelectedFreeAddOnIndex(int index) {
    selectedFreeAddOnIndex = index;
    update();
  }

  FreeAddOn? get selectedFreeAddOn {
    if (selectedFreeAddOnIndex >= 0 &&
        freeAddOnResponse != null &&
        selectedFreeAddOnIndex < freeAddOnResponse!.addons.length) {
      return freeAddOnResponse!.addons[selectedFreeAddOnIndex];
    }
    return null;
  }

  void clearSelectedFreeAddOn() {
    selectedFreeAddOnIndex = -1;
    update();
  }

  // Free Item Selection Logic
  void selectFreeItem(Map<String, dynamic> item) {
    selectedFreeItem = Map<String, dynamic>.from(item);
    update();
  }

  void clearFreeItem() {
    selectedFreeItem.clear();
    update();
  }

  // Extra Add-Ons Selection Logic
  void addExtraAddon(Map<String, dynamic> item) {
    if (!selectedExtraAddons.any((e) => e['id'] == item['id'])) {
      selectedExtraAddons.add(item);
      update();
    }
  }

  void removeExtraAddon(Map<String, dynamic> item) {
    selectedExtraAddons.removeWhere((e) => e['id'] == item['id']);
    update();
  }

  void toggleView() {
    isGridView = !isGridView;
    update();
  }

  void setGridView(bool value) {
    isGridView = value;
    update();
  }

  void togglePackageSelection(int index) {
    if (selectedPackageIndices.contains(index)) {
      selectedPackageIndices.remove(index);
      selectedPackagesForBilling.removeWhere(
        (pkg) => pkg['packageIndex'] == index,
      );
    } else {
      selectedPackageIndices.add(index);
      _addPackageForBilling(index);
    }
    update();
  }

  void _addPackageForBilling(int index) {
    final pkg = packages[index];

    final List<dynamic> variations = pkg["packagevariations"] ?? [];
    final selectedHoursForPackage =
        selectedHours[index] ?? {pkg["hours"].first};
    final selectedHour = selectedHoursForPackage.first;
    final priceMap = pkg["priceMap"] as Map<String, int>;

    // Utility function as you have:
    String getDurationLabel(dynamic variation) {
      final duration = variation["duration"]?.toString() ?? "";
      final type = (variation["duration_type"] ?? "").toString().toLowerCase();
      if (type.contains("minute")) return "${duration}min";
      if (type.contains("hour")) return "${duration}hr";
      return duration;
    }

    // Match the correct variation by selected hour
    final matchedVariation = variations.firstWhere(
      (v) => getDurationLabel(v) == selectedHour,
      orElse: () => variations.isNotEmpty ? variations[0] : null,
    );

    final variationId =
        matchedVariation != null ? matchedVariation["id"] : null;

    // Prepare correct billing package map
    final billingPackage = {
      ...pkg,
      'selectedHours': selectedHoursForPackage.toList(),
      'package_id': pkg['id'], // <-- Correct Package ID
      'packageIndex': index,
      'finalPrice': priceMap[selectedHour] ?? pkg["price"],
      'studio_id': studioId,
      'company_id': companyId,
      'subCategory': subCategoryId,
      'sub_vertical_id': subVerticalId,
      'type_id':
          pkg['typeId'] is int
              ? pkg['typeId']
              : int.tryParse(pkg['type_id']?.toString() ?? "0") ?? 0,
      'type': pkg['type'],
      'package_variation_id': variationId, // <-- Correct Variation ID
      'selectedHour': selectedHour,
      'advanceBookingDays': companyLocation?.company?.advanceBookingDays ?? 0,
      'companyLocation': companyLocation,
    };

    log(
      "Adding package for billing: advanceBookingDays=${billingPackage['advanceBookingDays']}, package_variation_id=${billingPackage['package_variation_id']}",
    );

    selectedPackagesForBilling.add(billingPackage);
  }

  void toggleHour(int packageIndex, String hour) {
    selectedHours[packageIndex] = {hour};
    if (selectedPackageIndices.contains(packageIndex)) {
      selectedPackagesForBilling.removeWhere(
        (pkg) => pkg['packageIndex'] == packageIndex,
      );
      _addPackageForBilling(packageIndex);
    }
    update();
  }

  List<Map<String, dynamic>> getSelectedPackagesForBilling() {
    return List<Map<String, dynamic>>.from(selectedPackagesForBilling);
  }

  double get packageTotal => selectedPackagesForBilling.fold(
    0.0,
    (sum, pkg) => sum + (pkg['finalPrice'] as num).toDouble(),
  );
  double get totalExtraAddOnPrice => selectedExtraAddons.fold(
    0.0,
    (sum, addon) => sum + (addon['price'] as num).toDouble(),
  );
  double _exclusiveFromInclusive(double inclusive) =>
      inclusive * (100 / (100 + gstPercentage));
  double get packageBaseTotal => _exclusiveFromInclusive(packageTotal);
  double get addonBaseTotal => _exclusiveFromInclusive(totalExtraAddOnPrice);
  double get subtotal => packageBaseTotal + addonBaseTotal;
  double get gstAmount => subtotal * gstPercentage / 100;
  double get finalAmount => packageTotal + totalExtraAddOnPrice;

  bool isPackageSelected(int index) {
    return selectedPackageIndices.contains(index);
  }

  int getTotalPrice() {
    return selectedPackagesForBilling.fold(
      0,
      (sum, pkg) => sum + (pkg['finalPrice'] as int),
    );
  }

  int getSelectedPackageCount() {
    return selectedPackagesForBilling.length;
  }

  void toggleExpanded(int index) {
    expandedStates[index] = !(expandedStates[index] ?? false);
    update();
  }

  void switchToListView() {
    isGridView = false;
    update();
  }

  void clearAllSelections() {
    selectedPackageIndices.clear();
    selectedPackagesForBilling.clear();
    update();
  }

  void selectAllPackages() {
    clearAllSelections();
    for (int i = 0; i < packages.length; i++) {
      selectedPackageIndices.add(i);
      _addPackageForBilling(i);
    }
    update();
  }

  void removePackageFromSelection(int index) {
    selectedPackageIndices.remove(index);
    selectedPackagesForBilling.removeWhere(
      (pkg) => pkg['packageIndex'] == index,
    );
    update();
  }

  Map<String, dynamic>? getPackageByIndex(int index) {
    if (index >= 0 && index < packages.length) {
      return packages[index];
    }
    return null;
  }

  bool hasSelectedPackages() {
    return selectedPackagesForBilling.isNotEmpty;
  }

  Set<String> getSelectedHoursForPackage(int index) {
    return selectedHours[index] ?? {packages[index]["hours"].first};
  }

  int calculatePriceForPackage(int packageIndex, Set<String> hours) {
    final pkg = packages[packageIndex];
    final priceMap = pkg["priceMap"] as Map<String, int>;
    final hour = hours.first;
    return priceMap[hour] ?? pkg["price"];
  }

  void updatePackagePricing(int packageIndex) {
    if (selectedPackageIndices.contains(packageIndex)) {
      selectedPackagesForBilling.removeWhere(
        (pkg) => pkg['packageIndex'] == packageIndex,
      );
      _addPackageForBilling(packageIndex);
      update();
    }
  }

  Future<void> fetchPopularPackages() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://admin.streammly.com/api/v1/package/getpopularpackages",
          // "http://192.168.1.113:8000/api/v1/package/getpopularpackages",
        ),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List data = jsonBody["data"] ?? [];

        popularPackagesList =
            data.map<Map<String, dynamic>>((pkg) {
              final List<dynamic>? variations = pkg["packagevariations"];
              final firstVariation =
                  (variations != null && variations.isNotEmpty)
                      ? variations[0]
                      : null;

              return {
                "title": pkg["title"] ?? "",
                "type": pkg["type"] ?? "N/A",
                "price":
                    int.tryParse(
                      firstVariation?["amount"]?.toString() ?? "0",
                    ) ??
                    0,
                "shortDescription": pkg["short_description"] ?? "",
                "highlight": pkg["fullDescription"] ?? "",
                "packageIndex": data.indexOf(pkg),
                "image":
                    (pkg["image_upload"] != null &&
                            pkg["image_upload"].isNotEmpty)
                        ? 'https://admin.streammly.com/${pkg["image_upload"]}'
                        : 'assets/images/category/vendor_category/Baby.jpg',
              };
            }).toList();
        update();
      } else {
        Get.snackbar("Error", "Failed to fetch popular packages");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }
}
