import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/data/init.dart';
import 'package:streammly/views/screens/common/webview_screen.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';

import 'navigation_menu.dart';
import 'views/screens/auth_screens/login_screen.dart';
import 'views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Init().initialize();
  runApp(const StreammlyApp());
}

class StreammlyApp extends StatelessWidget {
  const StreammlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Streammly',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Open Sans', color: Colors.black),
          bodyMedium: TextStyle(fontFamily: 'Open Sans', color: Colors.black54),
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => NavigationMenu()),

        // Promo slider redirection routes
        GetPage(name: '/webview', page: () => const WebViewScreen()),
        GetPage(name: '/category', page: () => CategoryListScreen()),
        // GetPage(name: '/subcategory', page: () => const SubcategoryScreen()),
        // GetPage(name: '/vendor', page: () => const VendorScreen()),
        // GetPage(name: '/company', page: () => const CompanyScreen()),
      ],
    );
  }
}
