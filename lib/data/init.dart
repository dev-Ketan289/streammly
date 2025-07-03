import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/otp_controller.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/data/repository/category_repo.dart';
import 'package:streammly/data/repository/company_repo.dart';
import 'package:streammly/data/repository/header_repo.dart';
import 'package:streammly/data/repository/promo_slider_repo.dart';

import '../controllers/category_controller.dart';
import '../controllers/company_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/promo_slider_controller.dart';
import '../services/constants.dart';
import 'api/api_client.dart';

class Init {
  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      //Repo initialization
      Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
      Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

      // Home
      Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
      Get.lazyPut(() => HomeRepo(apiClient: Get.find()));
      Get.lazyPut(() => HomeController(homeRepo: Get.find()));

      //Controller initialization
      Get.lazyPut(() => AuthController(authRepo: Get.find()));
      Get.lazyPut(() => OtpController(authRepo: Get.find()));
      // Category

      Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
      // Promo Slider
      Get.lazyPut(() => PromoSliderRepo(apiClient: Get.find()));
      Get.lazyPut(() => PromoSliderController(promoSliderRepo: Get.find()));
      //Company
      Get.lazyPut(() => CompanyRepo(apiClient: Get.find()));
      Get.lazyPut(() => CompanyController(companyRepo: Get.find()));
      // Package
      // Get.lazyPut(() => PackageRepo(apiClient: Get.find()));
      // Get.lazyPut(() => PackagesController(packageRepo: Get.find()));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
