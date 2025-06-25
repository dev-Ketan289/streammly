import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/otp_controller.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/data/repository/category_repo.dart';
import 'package:streammly/data/repository/company_repo.dart';

import '../controllers/category_controller.dart';
import '../controllers/company_controller.dart';
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
      Get.lazyPut(() => OtpController(authRepo: Get.find()));
      // Category
      Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
      Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
      //Company
      Get.lazyPut(() => CompanyRepo(apiClient: Get.find()));
      Get.lazyPut(() => CompanyMapController(companyRepo: Get.find()));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
