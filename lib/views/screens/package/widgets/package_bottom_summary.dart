import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/models/company/company_location.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/theme.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/package_page_controller.dart';
import '../../../../services/custom_error_widget.dart';
import '../booking/booking_page.dart';

class PackagesBottomBar extends StatelessWidget {
  final PackagesController controller;
  final CompanyLocation? companyLocation;
  final List<dynamic> companyLocations;
  const PackagesBottomBar({
    super.key,
    required this.controller,
    required this.companyLocations,
    required this.companyLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<PackagesController>(
      builder: (_) {
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
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primaryColor, width: 1),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Selected Packages: $selectedCount",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            "Total: ₹$totalPrice/-",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 4,
                        children:
                            selectedPackages.map((pkg) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryColor.withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${pkg['title']} (${pkg['selectedHours'].join(', ')})",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                  backgroundColor:
                      selectedPackages.isEmpty
                          ? theme.disabledColor
                          : primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    selectedPackages.isEmpty
                        ? null
                        : () async {
                          final authController = Get.find<AuthController>();
                          if (!authController.isLoggedIn()) {
                            // Navigate to custom full-screen error page
                            Get.to(
                              () => CustomErrorWidget(
                                imagePath: 'assets/images/access_denied.png',
                                title: 'Access Denied',
                                subtitle:
                                    'You don’t have permission to access this page',
                                primaryButtonText: 'Go Home',
                                onPrimaryPressed: () {
                                  Get.offAllNamed('/home');
                                },
                                secondaryButtonText: 'Login',
                                onSecondaryPressed: () {
                                  Get.toNamed('/login');
                                },
                              ),
                            );
                            return;
                          }

                          // Proceed to Booking Page flow as before
                          final mainState =
                              context
                                  .findAncestorStateOfType<
                                    NavigationFlowState
                                  >();

                          final enrichedPackages =
                              selectedPackages.map((pkg) {
                                final matchedLocation = companyLocations
                                    .firstWhereOrNull(
                                      (loc) =>
                                          loc['id'] ==
                                              pkg['company_location_id'] ||
                                          loc.id == pkg['company_location_id'],
                                    );
                                return {
                                  ...pkg,
                                  'companyLocation': matchedLocation,
                                };
                              }).toList();

                          mainState?.pushToCurrentTab(
                            BookingPage(
                              packages: enrichedPackages,
                              companyLocations: companyLocations,
                              companyLocation: companyLocation,
                            ),
                            hideBottomBar: true,
                          );
                        },

                child: Text(
                  selectedPackages.isEmpty
                      ? "Select packages to continue"
                      : "Let's Continue (${selectedPackages.length} packages)",
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
