import 'dart:async';

import 'package:flutter/material.dart';
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
      Navigator.pushReplacementNamed(context, '/login'); // change route as needed
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
            Image.asset('assets/images/splash.gif', height: size.height, width: size.height, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
