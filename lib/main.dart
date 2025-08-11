import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streammly/controllers/home_screen_controller.dart';
import 'package:streammly/controllers/package_page_controller.dart';
import 'package:streammly/controllers/promo_slider_controller.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/init.dart';
import 'package:streammly/data/repository/business_settings_repo.dart';
import 'package:streammly/data/repository/category_repo.dart';
import 'package:streammly/data/repository/company_repo.dart';
import 'package:streammly/data/repository/header_repo.dart';
import 'package:streammly/data/repository/promo_slider_repo.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/auth_screens/login_screen.dart';
import 'package:streammly/views/screens/common/location_screen.dart';
import 'package:streammly/views/screens/common/webview_screen.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/package/get_quote_page.dart';

import 'controllers/business_setting_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/company_controller.dart';
import 'controllers/location_controller.dart';
import 'views/screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,

    overlays: [SystemUiOverlay.top],
  );
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize core data/services
  await Init().initialize();

  // Register global controllers (singleton)
  Get.put(
    BusinessSettingController(
      businessSettingRepo: BusinessSettingRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
  );
  Get.put(
    HomeController(
      homeRepo: HomeRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
    permanent: true,
  );
  Get.put(
    PromoSliderController(
      promoSliderRepo: PromoSliderRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
  );
  Get.put(LocationController(), permanent: true);
  Get.put(
    CategoryController(
      categoryRepo: CategoryRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
    permanent: true,
  );
  Get.put(
    CompanyController(
      companyRepo: CompanyRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
    permanent: true,
  );
  Get.put(PackagesController());

  // Ask permissions (optional before launch)
  await requestPermissions();

  runApp(StreammlyApp());
}

final GlobalKey<NavigatorState> subnavigator = GlobalKey<NavigatorState>();
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
    return GetMaterialApp(
      navigatorKey: subnavigator,
      debugShowCheckedModeBanner: false,
      title: 'Streammly',
      theme: CustomTheme.light,
      themeMode: ThemeMode.light,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/Location', page: () => const LocationScreen()),
        GetPage(name: '/home', page: () => NavigationFlow()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/getQuote', page: () => GetQuoteScreen()),

        // Promo slider redirection routes
        GetPage(name: '/webview', page: () => const WebViewScreen()),
        GetPage(name: '/category', page: () => CategoryListScreen()),
      ],
    );
  }
}
