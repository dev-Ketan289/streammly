import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/quote_controller.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/views/screens/auth_screens/create_user.dart';

import '../../../controllers/auth_controller.dart';
import '../../../services/theme.dart' as theme;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final authController = Get.find<AuthController>();
      await authController.fetchUserProfile();

      if (!mounted) return;

      final args = Get.arguments ?? {};
      final redirectTo = args['redirectTo'];
      final formData = args['formData'];
      final packageData = args['packageData']; // ✅ Get package data

      log('WelcomeScreen - redirectTo: $redirectTo');
      log('WelcomeScreen - packageData: $packageData');
      log((Get.find<QuoteController>().companyId != null).toString());

      if (authController.userProfile == null ||
          (authController.userProfile!.name ?? '').isEmpty ||
          (authController.userProfile!.email ?? '').isEmpty) {
        // New user: show profile form with redirect info
        Get.off(
          () => ProfileFormScreen(),
          arguments: {
            'redirectTo': redirectTo,
            'packageData': packageData,
            'formData': formData,
          },
        );
      } else {
        // User profile is complete, navigate to main app
        if (redirectTo != null && redirectTo == 'home') {
          // Redirect to home with package data if available
          Get.offAll(() => NavigationFlow());
        } else if (packageData != null) {
          // Handle package-related navigation
          Get.offAll(() => NavigationFlow());
        } else {
          // Default navigation to main app
          Get.offAll(() => NavigationFlow());
        }
      }
    });
  }

  // Removed unused package redirect helper

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;
    final textTheme = themeData.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'STREAMMLY',
                          style: themeData.textTheme.headlineSmall!.copyWith(
                            fontFamily: 'CinzelDecorative',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/Thumb.gif',
                                height: 240,
                              ),
                              const SizedBox(height: 40),
                              Text(
                                "You're in!",
                                style: textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Welcome to Streammly",
                                style: textTheme.titleMedium!.copyWith(
                                  color: colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
