import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/package/free_add_on_model.dart';
import '../models/package/paid_addon_model.dart';

class PackagesController extends GetxController {
  var isGridView = false.obs;
  var expandedStates = <int, bool>{}.obs;
  var selectedHours = <int, Set<String>>{}.obs;

  var selectedPackagesForBilling = <Map<String, dynamic>>[].obs;
  var selectedPackageIndices = <int>{}.obs;

  RxList<Map<String, dynamic>> packages = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;

  RxList<Map<String, dynamic>> popularPackagesList = <Map<String, dynamic>>[].obs;

  RxList<Map<String, dynamic>> productsInPackageList = <Map<String, dynamic>>[].obs;

  // New: Free Item & Extra Add-On Selections
  RxMap<String, dynamic> selectedFreeItem = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> selectedExtraAddons = <Map<String, dynamic>>[].obs;

  late int companyId;
  late int subCategoryId;
  late int subVerticalId;
  late int studioId;

  void initialize({required int companyId, required int subCategoryId, required int subVerticalId, required int studioId}) {
    this.companyId = companyId;
    this.subCategoryId = subCategoryId;
    this.subVerticalId = subVerticalId;
    this.studioId = studioId;
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
    isLoading.value = true;
    packages.clear();

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.113:8000/api/v1/package/getpackages"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"company_id": companyId, "subcategory_id": subCategoryId, "sub_vertical_id": subVerticalId, 'studio_id': studioId}),
      );
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final List data = jsonBody["data"] ?? [];
        final filteredData = data.where((pkg) => pkg['sub_vertical_id'] == subVerticalId || subVerticalId == 0).toList();

        packages.assignAll(
          filteredData.map<Map<String, dynamic>>((pkg) {
            final List<dynamic>? variations = pkg["packagevariations"];
            final firstVariation = (variations != null && variations.isNotEmpty) ? variations[0] : null;

            final List<String> hours = variations != null ? variations.map<String>((v) => getDurationLabel(v)).toList() : ["1hr", "2hr", "3hr"];

            final priceMap = {for (var v in variations ?? []) getDurationLabel(v): int.tryParse(v["amount"]?.toString() ?? "0") ?? 0};

            return {
              "title": pkg["title"] ?? "",
              "type": pkg["type"] ?? "N/A",
              "price": priceMap[getDurationLabel(firstVariation ?? {})] ?? 0,
              "priceMap": priceMap,
              "hours": hours,
              "highlight": pkg["short_description"] ?? "",
              "shortDescription": pkg["long_description"] ?? "",
              "fullDescription": pkg["long_description"] ?? "",
              "termsAndCondition": pkg["terms_and_condition"] ?? "",
              "specialOffer": (pkg["status"] ?? "").toString().toLowerCase() == "active",
              "packageIndex": data.indexOf(pkg),
              "extraQuestions": pkg["packageextra_questions"] ?? [],
              "packageId": pkg["id"] ?? 0,
              "companyId": companyId,
            };
          }).toList(),
        );

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

    isLoading.value = false;
    print("==> Package fetch completed. Total packages: ${packages.length}");
  }

  RxBool isFetchingFreeAddOns = false.obs;
  Rx<FreeAddOnResponse?> freeAddOnResponse = Rx<FreeAddOnResponse?>(null);
  RxInt selectedFreeAddOnIndex = RxInt(-1);

  Future<void> fetchFreeAddOns(int packageId) async {
    isFetchingFreeAddOns.value = true;
    freeAddOnResponse.value = null;

    try {
      final url = Uri.parse('http://192.168.1.113:8000/api/v1/package/getfreeadons/?package_id=$packageId');

      final res = await http.get(url, headers: {"Content-Type": "application/json"});

      if (res.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(res.body);
        freeAddOnResponse.value = FreeAddOnResponse.fromJson(body);
      } else {
        Get.snackbar("Error", "Unable to fetch free add ons (${res.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
    }

    isFetchingFreeAddOns.value = false;
  }

  RxBool isFetchingPaidAddOns = false.obs;
  Rx<PaidAddOnResponse?> paidAddOnResponse = Rx<PaidAddOnResponse?>(null);
  RxInt selectedPaidAddOnIndex = RxInt(-1);

  Future<void> fetchPaidAddOns(int packageId, int studioId) async {
    isFetchingPaidAddOns.value = true;
    paidAddOnResponse.value = null;
    selectedPaidAddOnIndex.value = -1;
    try {
      final url = Uri.parse('http://192.168.1.113:8000/api/v1/package/getpaidadons/?package_id=$packageId&studio_id=$studioId');
      final res = await http.get(url, headers: {"Content-Type": "application/json"});
      if (res.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(res.body);
        paidAddOnResponse.value = PaidAddOnResponse.fromJson(body, studioId: studioId);
      } else {
        // handle error
      }
    } catch (e) {
      // handle error
    }
    isFetchingPaidAddOns.value = false;
  }

  void setSelectedPaidAddOnIndex(int index) {
    selectedPaidAddOnIndex.value = index;
  }

  PaidAddOn? get selectedPaidAddOn {
    if (selectedPaidAddOnIndex.value >= 0 && paidAddOnResponse.value != null && selectedPaidAddOnIndex.value < paidAddOnResponse.value!.addons.length) {
      return paidAddOnResponse.value!.addons[selectedPaidAddOnIndex.value];
    }
    return null;
  }

  void setSelectedFreeAddOnIndex(int index) {
    selectedFreeAddOnIndex.value = index;
  }

  FreeAddOn? get selectedFreeAddOn {
    if (selectedFreeAddOnIndex.value >= 0 && freeAddOnResponse.value != null && selectedFreeAddOnIndex.value < freeAddOnResponse.value!.addons.length) {
      return freeAddOnResponse.value!.addons[selectedFreeAddOnIndex.value];
    }
    return null;
  }

  void clearSelectedFreeAddOn() {
    selectedFreeAddOnIndex.value = -1;
  }

  // Free Item Selection Logic
  void selectFreeItem(Map<String, dynamic> item) {
    selectedFreeItem.value = item;
  }

  void clearFreeItem() {
    selectedFreeItem.clear();
  }

  // Extra Add-Ons Selection Logic
  void addExtraAddon(Map<String, dynamic> item) {
    if (!selectedExtraAddons.any((e) => e['id'] == item['id'])) {
      selectedExtraAddons.add(item);
    }
  }

  void removeExtraAddon(Map<String, dynamic> item) {
    selectedExtraAddons.removeWhere((e) => e['id'] == item['id']);
  }

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
    final selectedHoursForPackage = selectedHours[index] ?? {pkg["hours"].first};
    final selectedHour = selectedHoursForPackage.first;
    final priceMap = pkg["priceMap"] as Map<String, int>;

    final billingPackage = {
      ...pkg,
      'selectedHours': selectedHoursForPackage.toList(),
      'packageIndex': index,
      'finalPrice': priceMap[selectedHour] ?? pkg["price"],
      'studio_id': studioId,
      'company_id': companyId,
      'subCategory': subCategoryId,
      'sub_vertical_id': subVerticalId,
      'type_id': pkg['type_id'],
      'type': pkg['type'],
    };

    selectedPackagesForBilling.add(billingPackage);
  }

  void toggleHour(int packageIndex, String hour) {
    selectedHours[packageIndex] = {hour};
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
      selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == packageIndex);
      _addPackageForBilling(packageIndex);
    }
  }

  Future<void> fetchPopularPackages() async {
    try {
      // final response = await http.get(Uri.parse("https://admin.streammly.com/api/v1/package/getpopularpackages"), headers: {"Content-Type": "application/json"});
      final response = await http.get(Uri.parse("http://192.168.1.113/api/v1/package/getpopularpackages"), headers: {"Content-Type": "application/json"});

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
              "highlight": pkg["fullDescription"] ?? "",
              "packageIndex": data.indexOf(pkg),
              "image":
                  (pkg["image_upload"] != null && pkg["image_upload"].isNotEmpty)
                      // ? 'https://admin.streammly.com/${pkg["image_upload"]}'
                      ? 'http://192.168.1.113/${pkg["image_upload"]}'
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
}
