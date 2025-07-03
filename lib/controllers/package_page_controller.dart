import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PackagesController extends GetxController {
  var isGridView = false.obs;
  var expandedStates = <int, bool>{}.obs;
  var selectedHours = <int, Set<String>>{}.obs;

  var selectedPackagesForBilling = <Map<String, dynamic>>[].obs;
  var selectedPackageIndices = <int>{}.obs;

  RxList<Map<String, dynamic>> packages = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> popularPackagesList = <Map<String, dynamic>>[].obs;

  late int companyId;
  late int subCategoryId;
  late int subVerticalId;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.113:8000/api/v1/package/getpackages"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"company_id": companyId, "sub_category_id": subCategoryId, "sub_vertical_id": subVerticalId}),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List data = jsonBody["data"] ?? [];

        packages.assignAll(
          data.map<Map<String, dynamic>>((pkg) {
            final List<dynamic>? variations = pkg["packagevariations"];
            final firstVariation = (variations != null && variations.isNotEmpty) ? variations[0] : null;

            return {
              "title": pkg["title"] ?? "",
              "type": pkg["type"] ?? "N/A",
              "price": int.tryParse(firstVariation?["amount"]?.toString() ?? "0") ?? 0,
              "oldPrice": null,
              "hours":
                  variations != null
                      ? variations.map<String>((v) {
                        final duration = v["duration"] ?? "";
                        final type = (v["duration_type"] ?? "").toString().toLowerCase();
                        final suffix = type.startsWith("hour") ? "hr" : "";
                        return "$duration$suffix";
                      }).toList()
                      : ["1hr", "2hrs", "3hrs"],
              "highlight": pkg["long_description"] ?? "",
              "shortDescription": pkg["short_description"] ?? "",
              "fullDescription": pkg["long_description"] ?? "",
              "specialOffer": (pkg["status"] ?? "").toString().toLowerCase() == "active",
              "packageIndex": data.indexOf(pkg),
            };
          }).toList(),
        );

        for (int i = 0; i < packages.length; i++) {
          selectedHours[i] = {"2hrs"};
          expandedStates[i] = false;
        }
      } else {
        Get.snackbar("Error", "Failed to fetch packages");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
    isLoading.value = false;
  }

  Future<void> fetchPopularPackages() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.1.113:8000/api/v1/package/getpopularpackages"), headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List data = jsonBody["data"] ?? [];

        popularPackagesList.assignAll(
          data.map<Map<String, dynamic>>((pkg) {
            final List<dynamic>? variations = pkg["packagevariations"];
            final firstVariation = (variations != null && variations.isNotEmpty) ? variations[0] : null;

            return {
              "title": pkg["title"] ?? "",
              "type": pkg["type"] ?? "N/A",
              "price": int.tryParse(firstVariation?["amount"]?.toString() ?? "0") ?? 0,
              "shortDescription": pkg["short_description"] ?? "",
              "highlight": pkg["short_description"] ?? "",
              "packageIndex": data.indexOf(pkg),
              "image":
                  pkg["image_upload"] != null && pkg["image_upload"].isNotEmpty
                      ? 'http://192.168.1.113:8000/${pkg["image_upload"]}'
                      : 'assets/images/category/vendor_category/Baby.jpg',
            };
          }).toList(),
        );
      } else {
        Get.snackbar("Error", "Failed to fetch popular packages");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }

  // Other methods (toggleView, togglePackageSelection, etc.) remain unchanged...
  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  void setGridView(bool value) {
    isGridView.value = value;
  }

  void togglePackageSelection(int index) {
    if (selectedPackageIndices.contains(index)) {
      selectedPackageIndices.remove(index);
      selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == index);
    } else {
      selectedPackageIndices.add(index);
      _addPackageForBilling(index);
    }
  }

  void _addPackageForBilling(int index) {
    final pkg = packages[index];
    final selectedHoursForPackage = selectedHours[index] ?? {"2hrs"};
    final billingPackage = {...pkg, 'selectedHours': selectedHoursForPackage.toList(), 'packageIndex': index, 'finalPrice': pkg["price"]};
    selectedPackagesForBilling.add(billingPackage);
  }

  void toggleHour(int packageIndex, String hour) {
    selectedHours[packageIndex] ??= <String>{};
    if (selectedHours[packageIndex]!.contains(hour)) {
      selectedHours[packageIndex]!.remove(hour);
    } else {
      selectedHours[packageIndex]!.add(hour);
    }
    selectedHours.refresh();
    if (selectedPackageIndices.contains(packageIndex)) {
      selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == packageIndex);
      _addPackageForBilling(packageIndex);
    }
  }

  List<Map<String, dynamic>> getSelectedPackagesForBilling() {
    return selectedPackagesForBilling.toList();
  }

  bool isPackageSelected(int index) {
    return selectedPackageIndices.contains(index);
  }

  int getTotalPrice() {
    return selectedPackagesForBilling.fold(0, (sum, pkg) => sum + (pkg['finalPrice'] as int));
  }

  int getSelectedPackageCount() {
    return selectedPackagesForBilling.length;
  }

  void toggleExpanded(int index) {
    expandedStates[index] = !(expandedStates[index] ?? false);
    expandedStates.refresh();
  }

  void switchToListView() {
    isGridView.value = false;
  }

  void clearAllSelections() {
    selectedPackageIndices.clear();
    selectedPackagesForBilling.clear();
  }

  void selectAllPackages() {
    clearAllSelections();
    for (int i = 0; i < packages.length; i++) {
      selectedPackageIndices.add(i);
      _addPackageForBilling(i);
    }
  }

  void removePackageFromSelection(int index) {
    selectedPackageIndices.remove(index);
    selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == index);
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
    return selectedHours[index] ?? {"2hrs"};
  }

  int calculatePriceForPackage(int packageIndex, Set<String> hours) {
    final basePrice = packages[packageIndex]["price"] as int;
    int additionalCost = 0;
    if (hours.contains("1hr") && hours.contains("3hrs")) {
      additionalCost = 2000;
    } else if (hours.contains("1hr") || hours.contains("3hrs")) {
      additionalCost = 1000;
    }
    return basePrice + additionalCost;
  }

  void updatePackagePricing(int packageIndex) {
    if (selectedPackageIndices.contains(packageIndex)) {
      selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == packageIndex);
      final pkg = packages[packageIndex];
      final selectedHoursForPackage = selectedHours[packageIndex] ?? {"2hrs"};
      final calculatedPrice = calculatePriceForPackage(packageIndex, selectedHoursForPackage);
      final billingPackage = {...pkg, 'selectedHours': selectedHoursForPackage.toList(), 'packageIndex': packageIndex, 'finalPrice': calculatedPrice};
      selectedPackagesForBilling.add(billingPackage);
    }
  }
}
