import 'dart:developer';

import 'package:get/get.dart';
import 'package:streammly/models/profile/business_setting_model.dart';

import '../data/repository/business_settings_repo.dart';

class BusinessSettingController extends GetxController {
  final BusinessSettingRepo businessSettingRepo;

  BusinessSettingController({required this.businessSettingRepo});

  BusinessSettings? settings;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchBusinessSettings();
  }

  Future<void> fetchBusinessSettings() async {
    try {
      isLoading = true;
      update();

      final response = await businessSettingRepo.getBusinessSettings();
      settings = BusinessSettings.fromJson(response.body);
    } catch (e, st) {
      log("Error fetching business settings: $e\n$st");
    } finally {
      isLoading = false;
      update();
    }
  }
}
