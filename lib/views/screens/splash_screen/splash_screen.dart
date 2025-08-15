import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/navigation_menu.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';
import 'package:streammly/views/screens/common/location_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      final authController = Get.find<AuthController>();
      final locationController = Get.find<LocationController>();

      // Check if user is already logged in
      if (authController.isLoggedIn()) {
        // User is logged in, fetch profile and navigate accordingly
        await authController.fetchUserProfile();

        if (authController.userProfile == null ||
            (authController.userProfile!.name ?? '').isEmpty ||
            (authController.userProfile!.email ?? '').isEmpty) {
          // User profile incomplete, go to profile form
          Get.offAll(() => const WelcomeScreen());
        } else {
          // User profile complete, check location and navigate to home
          final hasSavedLocation = await locationController.hasSavedLocation();

          if (hasSavedLocation) {
            // Get current GPS location and navigate to home
            await locationController.getCurrentLocation();
            locationController.saveSelectedLocation();
            Get.offAll(() => NavigationFlow());
          } else {
            // No saved location, go to location screen
            Get.offAll(() => const LocationScreen());
          }
        }
      } else {
        // User not logged in, check location and navigate accordingly
        final hasSavedLocation = await locationController.hasSavedLocation();

        if (hasSavedLocation) {
          // Get current GPS location and navigate to home
          await locationController.getCurrentLocation();
          locationController.saveSelectedLocation();
          Get.offAll(() => NavigationFlow());
        } else {
          // First time - go to Location screen
          Get.offAll(() => const LocationScreen());
        }
      }
    });
  }

  // ... existing code ...

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // App Logo or GIF
            Image.asset(
              Assets.imagesSplash,
              height: size.height,
              width: size.height,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
