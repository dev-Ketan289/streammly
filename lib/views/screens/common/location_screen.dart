import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/views/screens/common/enter_location_manually.dart';

import '../../../navigation_menu.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final locationController = Get.put(LocationController());

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Expanded(
                      child: Text(
                        "Location",
                        style: textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign:
                            Navigator.canPop(context)
                                ? TextAlign.start
                                : TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Let us know the spot.....\nwe'll bring the magic there.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(color: theme.hintColor),
                ),
              ),
              const SizedBox(height: 20),

              Image.asset(
                'assets/images/location_girl_map.png',
                height: 220,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      size: 80,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Use Current Location Button
                    GetBuilder<LocationController>(
                      builder:
                          (controller) => SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              onPressed:
                                  controller.isLoading
                                      ? null
                                      : () async {
                                        try {
                                          await controller.getCurrentLocation();
                                          controller.saveSelectedLocation();
                                          Get.to(() => NavigationFlow());
                                        } catch (e) {
                                          Get.snackbar(
                                            'Error',
                                            'Failed to get current location. Please try again or enter manually.',
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      },
                              child:
                                  controller.isLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        "Use Current Location",
                                        style: textTheme.bodyLarge!.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 15),

                    // Enter Manually Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => EnterLocationManuallyScreen());
                        },
                        child: Text(
                          "Enter Location Manually",
                          style: textTheme.bodyLarge!.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
