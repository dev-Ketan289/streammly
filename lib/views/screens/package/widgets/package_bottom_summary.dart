import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/theme.dart';

import '../../../../controllers/package_page_controller.dart';
import '../booking/booking_page.dart';

class PackagesBottomBar extends StatelessWidget {
  final PackagesController controller;
  final List<dynamic> companyLocations;
  const PackagesBottomBar({super.key, required this.controller, required this.companyLocations});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final selectedPackages = controller.getSelectedPackagesForBilling();
      final selectedCount = controller.getSelectedPackageCount();
      final totalPrice = controller.getTotalPrice();

      return Container(
        padding: const EdgeInsets.all(16),
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedPackages.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(8), border: Border.all(color: primaryColor, width: 1)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Selected Packages: $selectedCount", style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: primaryColor)),
                        Text("Total: ₹$totalPrice/-", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children:
                          selectedPackages.map((pkg) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: primaryColor.withAlpha(25), borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                "${pkg['title']} (${pkg['selectedHours'].join(', ')})",
                                style: theme.textTheme.bodySmall?.copyWith(color: primaryColor, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),
            ],
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: selectedPackages.isEmpty ? theme.disabledColor : primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed:
                  selectedPackages.isEmpty
                      ? null
                      : () {
                        final mainState = context.findAncestorStateOfType<NavigationFlowState>();

                        /// 💡 Attach correct companyLocation to each selected package
                        final enrichedPackages =
                            selectedPackages.map((pkg) {
                              final matchedLocation = companyLocations.firstWhereOrNull(
                                (loc) => loc['id'] == pkg['company_location_id'] || loc.id == pkg['company_location_id'], // if object
                              );
                              return {...pkg, 'companyLocation': matchedLocation};
                            }).toList();

                        log(enrichedPackages.firstOrNull.toString(), name: "SelectedPackageWithCompanyLocation");

                        mainState?.pushToCurrentTab(BookingPage(packages: enrichedPackages, companyLocations: companyLocations), hideBottomBar: true);
                      },
              child: Text(
                selectedPackages.isEmpty ? "Select packages to continue" : "Let's Continue (${selectedPackages.length} packages)",
                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    });
  }
}
