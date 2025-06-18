import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/package_page_controller.dart';
import '../booking/booking_page.dart';

class PackagesBottomBar extends StatelessWidget {
  final PackagesController controller;
  const PackagesBottomBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedPackages = controller.getSelectedPackagesForBilling();
      final selectedCount = controller.getSelectedPackageCount();
      final totalPrice = controller.getTotalPrice();

      return Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF5F6FA),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedPackages.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF4A6CF7), width: 1)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Selected Packages: $selectedCount", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A6CF7))),
                        Text("Total: ₹$totalPrice/-", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A6CF7))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children:
                          selectedPackages
                              .map(
                                (pkg) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFF4A6CF7).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Text(
                                    "${pkg['title']} (${pkg['selectedHours'].join(', ')})",
                                    style: const TextStyle(fontSize: 12, color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ],
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: selectedPackages.isEmpty ? Colors.grey : const Color(0xFF4A6CF7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed:
                  selectedPackages.isEmpty
                      ? null
                      : () {
                        Get.to(() => BookingPage(), arguments: selectedPackages);
                      },
              child: Text(
                selectedPackages.isEmpty ? "Select packages to continue" : "Let's Continue (${selectedPackages.length} packages)",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    });
  }
}
