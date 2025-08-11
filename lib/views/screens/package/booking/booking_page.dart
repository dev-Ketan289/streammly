import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/models/company/company_location.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/booking/booking_summary.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_form_page.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_personal_info.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/booking_form_controller.dart';
import '../../../../navigation_flow.dart';

class BookingPage extends StatelessWidget {
  final List<Map<String, dynamic>> packages;
  final List<dynamic> companyLocations;
  final CompanyLocation? companyLocation;
  final int companyId;

  const BookingPage({
    super.key,
    required this.packages,
    required this.companyLocations,
    required this.companyLocation,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    log(companyLocation.toString(), name: 'companylocation');
    log(packages.toString());

    // Remove the existing controller if it exists to avoid conflicts
    if (Get.isRegistered<BookingController>()) {
      Get.delete<BookingController>();
    }

    final controller = Get.put(
      BookingController(
        bookingrepo: BookingRepo(
          apiClient: ApiClient(
            appBaseUrl: AppConstants.baseUrl,
            sharedPreferences: Get.find(),
          ),
        ),
      ),
      permanent: false, // Changed to false to allow proper cleanup
    );

    // Initialize packages and refresh user profile in correct order
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // First refresh user profile to ensure latest data
      final authController = Get.find<AuthController>();
      await authController.fetchUserProfile();

      // Then initialize packages
      controller.initSelectedPackages(packages, companyLocations);

      // Finally trigger autofill with refreshed data
      controller.refreshPersonalInfo();
    });

    return CustomBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: GetBuilder<BookingController>(
            builder: (_) {
              if (controller.selectedPackages.isNotEmpty) {
                return Text(
                  "Booking",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                );
              } else {
                return const Text(
                  "Booking",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }
            },
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: Colors.transparent,
        body: GetBuilder<BookingController>(
          builder: (_) {
            // Show loading while initializing
            if (controller.isLoading || controller.selectedPackages.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentPage = controller.currentPage;
            final packagesLength = controller.selectedPackages.length;

            final safePageIndex =
                (currentPage >= 0 && currentPage < packagesLength)
                    ? currentPage
                    : 0;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PersonalInfoSection(),
                        const SizedBox(height: 32),

                        if (packagesLength > 1) ...[
                          SizedBox(
                            height: 45,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: packagesLength,
                              itemBuilder: (context, index) {
                                final isSelected = safePageIndex == index;
                                return ElevatedButton(
                                  onPressed: () {
                                    controller.currentPage = index;
                                    controller.update();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isSelected
                                            ? primaryColor
                                            : Colors.grey.shade100,
                                    foregroundColor:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      side: BorderSide(
                                        color:
                                            isSelected
                                                ? primaryColor
                                                : Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    controller
                                            .selectedPackages[index]['title'] ??
                                        'Package ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        PackageFormCard(
                          index: safePageIndex,
                          package: controller.selectedPackages[safePageIndex],
                          companyId: companyId,
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final controller = Get.find<BookingController>();

                        if (controller.canSubmit()) {
                          final mainState =
                              context
                                  .findAncestorStateOfType<
                                    NavigationFlowState
                                  >();

                          mainState?.pushToCurrentTab(
                            BookingSummaryPage(),
                            hideBottomBar: true,
                          );
                        } else {
                          Get.snackbar(
                            'Incomplete Details',
                            'Please fill all required fields and accept terms and conditions before continuing.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4A6CF7),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Let's Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
