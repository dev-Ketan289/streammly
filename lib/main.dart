import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streammly/controllers/home_screen_controller.dart';
import 'package:streammly/data/init.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/splash_screen/splash_screen.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomeController);
  await Firebase.initializeApp();
  await Init().initialize();

  // Request permissions before app starts
  await requestPermissions();

  runApp(const StreammlyApp());
}

Future<void> requestPermissions() async {
  // Request SMS permission
  await Permission.sms.request();

  // Request Location permission
  await Permission.location.request();
}

class StreammlyApp extends StatelessWidget {
  const StreammlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Streammly',
      theme: CustomTheme.light,
      darkTheme: CustomTheme.dark,
      themeMode: ThemeMode.system, 
      home: SplashScreen(),
      // initialRoute: '/splash',
      // getPages: [
      //   GetPage(name: '/splash', page: () => const SplashScreen()),
      //   GetPage(name: '/Location', page: () => const LocationScreen()),
      //   GetPage(name: '/home', page: () => NavigationMenu()),
      //   GetPage(name: '/login', page: () => LoginScreen()),

      //   // Promo slider redirection routes
      //   GetPage(name: '/webview', page: () => const WebViewScreen()),
      //   GetPage(name: '/category', page: () => CategoryListScreen()),
      // ],
    );
  }
}
