import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bundle_package_card.dart'; // <-- Your reusable card widget

class BundlePackageSelectionScreen extends StatefulWidget {
  final List<String> selectedVendorIds;

  const BundlePackageSelectionScreen({super.key, required this.selectedVendorIds});

  @override
  State<BundlePackageSelectionScreen> createState() => _BundlePackageSelectionScreenState();
}

class _BundlePackageSelectionScreenState extends State<BundlePackageSelectionScreen> {
  final Map<String, List<Map<String, dynamic>>> vendorPackages = {}; // vendorId -> list of packages
  final Map<String, int> selectedIndexPerVendor = {}; // vendorId -> selected package index
  final Map<String, String> selectedHourPerVendor = {}; // vendorId -> selected hour
  final Map<String, bool> expandedPerVendor = {}; // vendorId+index -> expanded flag

  @override
  void initState() {
    super.initState();
    // Simulate fetching packages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPackages();
    });
  }

  Future<void> _loadPackages() async {
    for (final vendorId in widget.selectedVendorIds) {
      vendorPackages[vendorId] = List.generate(
        2,
        (index) => {
          "title": "Package ${index + 1}",
          "type": "Standard",
          "price": 499,
          "oldPrice": 599,
          "priceMap": {"1hr": 499, "2hr": 899},
          "hours": ["1hr", "2hr"],
          "highlight": "Free 1-day trial included",
          "shortDescription": "Basic cleaning package",
          "fullDescription": "Basic cleaning package with premium service options included.",
        },
      );
      selectedIndexPerVendor[vendorId] = 0;
      selectedHourPerVendor[vendorId] = "1hr";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Select Packages"), centerTitle: true, backgroundColor: theme.primaryColor, foregroundColor: Colors.white),
      body:
          vendorPackages.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.selectedVendorIds.length,
                itemBuilder: (context, vendorIndex) {
                  final vendorId = widget.selectedVendorIds[vendorIndex];
                  final packages = vendorPackages[vendorId]!;
                  final selectedIndex = selectedIndexPerVendor[vendorId] ?? 0;
                  final selectedHour = selectedHourPerVendor[vendorId] ?? "1hr";

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vendor: $vendorId", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Column(
                        children: List.generate(packages.length, (pkgIndex) {
                          final pkg = packages[pkgIndex];
                          final isSelected = selectedIndex == pkgIndex;
                          final isExpanded = expandedPerVendor['$vendorId-$pkgIndex'] ?? false;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: BundlePackageCard(
                              vendorId: vendorId,
                              companyName: vendorId,
                              package: pkg,
                              isSelected: isSelected,
                              selectedHour: selectedHour,
                              onPackageTap: () {
                                setState(() {
                                  selectedIndexPerVendor[vendorId] = pkgIndex;
                                });
                              },
                              onHourTap: (hour) {
                                setState(() {
                                  selectedHourPerVendor[vendorId] = hour;
                                });
                              },
                              isExpanded: isExpanded,
                              onExpandToggle: () {
                                setState(() {
                                  expandedPerVendor['$vendorId-$pkgIndex'] = !isExpanded;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                      const Divider(thickness: 1.5, color: Colors.grey),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Handle submission logic here
            Get.snackbar("Submitted", "Packages selected for ${widget.selectedVendorIds.length} vendors");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E5CDA),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
