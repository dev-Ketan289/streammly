import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/auth_screens/create_user.dart';
import 'package:streammly/views/screens/common/location_screen.dart';

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
      // Ensure userProfile is loaded
      if (authController.userProfile == null) {
        await authController.fetchUserProfile();
      }
      if (authController.userProfile == null || authController.userProfile!.name == null || authController.userProfile!.email == null) {
        // New user: show profile form
        Get.off(() => ProfileFormScreen());
      } else {
        // Existing user: go to location screen
        Get.off(() => const LocationScreen());
      }
    });
  }

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
                            color: theme.primaryColor, // Using your theme file color
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/Thumb.gif', height: 240),
                              const SizedBox(height: 40),
                              Text("You're in!", style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary), textAlign: TextAlign.center),
                              const SizedBox(height: 8),
                              Text("Welcome to Streammly", style: textTheme.titleMedium!.copyWith(color: colorScheme.primary), textAlign: TextAlign.center),
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
