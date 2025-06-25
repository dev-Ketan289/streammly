import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/data/repository/auth_repo.dart';

import '../services/constants.dart';
import 'api/api_client.dart';

class Init {
  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      //Repo initialization
      Get.lazyPut(
        () => ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      );
      Get.lazyPut(
        () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
      );

      //Controller initialization
      Get.lazyPut(() => AuthController(authRepo: Get.find()));
      Get.lazyPut(() => OtpController());
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
