import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/otp_controller.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/data/repository/business_settings_repo.dart';
import 'package:streammly/data/repository/category_repo.dart';
import 'package:streammly/data/repository/company_repo.dart';
import 'package:streammly/data/repository/header_repo.dart';
import 'package:streammly/data/repository/promo_slider_repo.dart';
import 'package:streammly/data/repository/wishlist_repo.dart';

import '../controllers/business_setting_controller.dart';
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
      final String token = sharedPreferences.getString(AppConstants.token) ?? "";
      final apiClient = ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: sharedPreferences);
      apiClient.updateHeader(token);
      Get.lazyPut(() => apiClient);

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

      //Wishlist
      Get.lazyPut(() => WishlistRepo(apiClient: Get.find()));
      Get.lazyPut(() => WishlistController(companyController: Get.find()));
      // Package
      // Get.lazyPut(() => PackageRepo(apiClient: Get.find()));
      // Get.lazyPut(() => PackagesController(packageRepo: Get.find()));

      //Business setting
      Get.lazyPut(() => BusinessSettingRepo(apiClient: Get.find()));
      Get.lazyPut(() => BusinessSettingController(businessSettingRepo: Get.find()));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }

  // Location save & check methods

  Future<bool> isLocationSaved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('saved_location');
  }

  Future<void> saveUserLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_location', location);
  }

  Future<String?> getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_location');
  }

  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_location');
  }
}
