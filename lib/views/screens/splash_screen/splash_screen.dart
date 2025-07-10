import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/navigation_menu.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/auth_screens/login_screen.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';
import 'package:streammly/views/screens/home/home_screen.dart';
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

    Timer(const Duration(seconds: 2), () { 
      // Navigate to next screen after splash
      if (Get.find<AuthController>().isLoggedIn()) {
        Navigator.push(context, getCustomRoute(child: NavigationMenu()));

     
      } else {
        Navigator.push(context, getCustomRoute(child: NavigationMenu()));
        
      }
    });
  }  
  void initMethos(){ 
    final authCtrl=Get.find<AuthController>(); 
    if(authCtrl.isLoggedIn()){
      // Navigator.of(context).push(getCustomRoute(child: ));
      Navigator.of(context).pushAndRemoveUntil(getCustomRoute(child: NavigationMenu()), (route) => false,); 
      
    }else{
      Navigator.of(context).pushAndRemoveUntil(getCustomRoute(child: WelcomeScreen()), (route) => false,);
      
    }

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
