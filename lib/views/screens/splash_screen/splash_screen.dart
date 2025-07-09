import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/navigation_menu.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/auth_screens/login_screen.dart';
// Add your custom image widget if needed

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      // Navigate to next screen after splash
      if (Get.find<AuthController>().isLoggedIn()) {
        Navigator.push(context, getCustomRoute(child: NavigationMenu()));

        // Navigator.pushReplacementNamed(context, '/home'); //
      } else {
        Navigator.push(context, getCustomRoute(child: LoginScreen()));
        // Navigator.pushReplacementNamed(
        //   context,
        //   '/login',
        // ); // change route as needed
        // Navigator.push(context, getCustomRoute(child: LocationScreen()));
      }
    });
  }

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
            Image.asset(Assets.imagesSplash, height: size.height, width: size.height, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
