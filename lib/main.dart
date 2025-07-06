import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/data/init.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/auth_screens/login_screen.dart';
import 'package:streammly/views/screens/common/location_screen.dart';
import 'package:streammly/views/screens/common/webview_screen.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';

import 'navigation_menu.dart';
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
      theme: CustomTheme.light,
      darkTheme: CustomTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/Location', page: () => const LocationScreen()),
        GetPage(name: '/home', page: () => NavigationMenu()),
        GetPage(name: '/login', page: () => LoginScreen()),

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
