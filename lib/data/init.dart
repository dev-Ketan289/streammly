import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/data/api/api_client.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../services/constants.dart';

class Init {
  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      Get.lazyPut(
        () => ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      );
      // Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

      Get.lazyPut(() => HomeController());
      Get.lazyPut(() => LoginController());
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
