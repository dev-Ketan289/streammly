import 'package:get/get.dart';

class PackagesController extends GetxController {
  var isGridView = false.obs;
  var expandedStates = <int, bool>{}.obs;
  var selectedHours = <int, Set<String>>{}.obs;

  // For billing purposes - multiple packages can be selected
  var selectedPackagesForBilling = <Map<String, dynamic>>[].obs;
  var selectedPackageIndices = <int>{}.obs; // Track selected package indices

  final List<Map<String, dynamic>> packages = [
    {
      "title": "Cuteness",
      "type": "HomeShoot",
      "price": 5999,
      "oldPrice": 8999,
      "hours": ["1hr", "2hrs", "3hrs"],
      "highlight": "Today 50% discount on all products in Chapter with online orders",
      "shortDescription": "Excuse me... Who could ever resist a discount feast? 👀",
      "fullDescription":
          "Excuse me... Who could ever resist a discount feast? 👀\n\nHear me out. Today, October 21, 2021, Chapter has a 50% discount for any product. What are you waiting for, let's order now before it runs out.",
      "specialOffer": true,
    },
    {
      "title": "Moments",
      "type": "StudioShoot",
      "price": 15999,
      "oldPrice": 19999,
      "hours": ["1hr", "2hrs", "3hrs"],
      "highlight": "",
      "shortDescription": "",
      "fullDescription": "",
      "specialOffer": true,
    },
    {
      "title": "Wonders",
      "type": "HomeShoot",
      "price": 13999,
      "oldPrice": null,
      "hours": ["1hr", "2hrs", "3hrs"],
      "highlight": "",
      "shortDescription": "",
      "fullDescription": "",
      "specialOffer": false,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // Initialize selected hours for each package
    for (int i = 0; i < packages.length; i++) {
      selectedHours[i] = {"2hrs"}; // Default to 2hrs as shown in image
      expandedStates[i] = false;
    }
  }

  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  void setGridView(bool value) {
    isGridView.value = value;
  }

  void togglePackageSelection(int index) {
    if (selectedPackageIndices.contains(index)) {
      // Remove from selection
      selectedPackageIndices.remove(index);
      selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == index);
    } else {
      // Add to selection
      selectedPackageIndices.add(index);
      _addPackageForBilling(index);
    }
  }

  void _addPackageForBilling(int index) {
    final pkg = packages[index];
    final selectedHoursForPackage = selectedHours[index] ?? {"2hrs"};

    final billingPackage = {
      ...pkg,
      'selectedHours': selectedHoursForPackage.toList(),
      'packageIndex': index,
      'finalPrice': pkg["price"], // You can add hour-based pricing logic here
    };

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

    // Update billing package if this package is selected
    if (selectedPackageIndices.contains(packageIndex)) {
      // Remove old entry and add updated one
      selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == packageIndex);
      _addPackageForBilling(packageIndex);
    }
  }

  // Get all selected packages for billing
  List<Map<String, dynamic>> getSelectedPackagesForBilling() {
    return selectedPackagesForBilling.toList();
  }

  // Check if package is selected for billing
  bool isPackageSelected(int index) {
    return selectedPackageIndices.contains(index);
  }

  // Get total price of all selected packages
  int getTotalPrice() {
    return selectedPackagesForBilling.fold(0, (sum, pkg) => sum + (pkg['finalPrice'] as int));
  }

  // Get count of selected packages
  int getSelectedPackageCount() {
    return selectedPackagesForBilling.length;
  }

  void toggleExpanded(int index) {
    expandedStates[index] = !(expandedStates[index] ?? false);
    expandedStates.refresh();
  }

  // New method to switch to list view
  void switchToListView() {
    isGridView.value = false;
  }

  // Clear all selections
  void clearAllSelections() {
    selectedPackageIndices.clear();
    selectedPackagesForBilling.clear();
  }

  // Select all packages
  void selectAllPackages() {
    clearAllSelections();
    for (int i = 0; i < packages.length; i++) {
      selectedPackageIndices.add(i);
      _addPackageForBilling(i);
    }
  }

  // Remove specific package from selection
  void removePackageFromSelection(int index) {
    selectedPackageIndices.remove(index);
    selectedPackagesForBilling.removeWhere((pkg) => pkg['packageIndex'] == index);
  }

  // Get package by index
  Map<String, dynamic>? getPackageByIndex(int index) {
    if (index >= 0 && index < packages.length) {
      return packages[index];
    }
    return null;
  }

  // Check if any package is selected
  bool hasSelectedPackages() {
    return selectedPackagesForBilling.isNotEmpty;
  }

  // Get selected hours for a specific package
  Set<String> getSelectedHoursForPackage(int index) {
    return selectedHours[index] ?? {"2hrs"};
  }

  // Update pricing based on hours (you can customize this logic)
  int calculatePriceForPackage(int packageIndex, Set<String> hours) {
    final basePrice = packages[packageIndex]["price"] as int;
    // Example: add 1000 for each additional hour beyond 2hrs
    int additionalCost = 0;
    if (hours.contains("1hr") && hours.contains("3hrs")) {
      additionalCost = 2000; // Both 1hr and 3hrs selected
    } else if (hours.contains("1hr") || hours.contains("3hrs")) {
      additionalCost = 1000; // Either 1hr or 3hrs selected
    }
    return basePrice + additionalCost;
  }

  // Update package pricing when hours change
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
