import 'dart:developer';

import 'package:get/get.dart';
import 'package:streammly/data/repository/company_business_settings_repo.dart';
import 'package:streammly/models/company/company_business_settings.dart';
import 'package:streammly/models/response/response_model.dart';

class CompanyBusinessSettingsController extends GetxController {
  final CompanyBusinessSettingsRepo companyBusinessSettingsRepo;

  CompanyBusinessSettingsController({required this.companyBusinessSettingsRepo});

  CompanyBusinessSettings? settings;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    // Placeholder companyId - replace with actual logic to get companyId (e.g., from user session)
    fetchCompanyBusinessSettings("default_company_id");
  }

  Future<ResponseModel?> fetchCompanyBusinessSettings(String companyId) async {
    isLoading = true;
    update();
    ResponseModel? responseModel;
    try {
      Response response = await companyBusinessSettingsRepo.getCompanyBusinessSettings(companyId);
      log(
        response.bodyString ?? "",
        name: "***** Response in fetchCompanyBusinessSettings () ******",
      );
      if (response.statusCode == 200 && response.body['data'] != null) {
        settings = CompanyBusinessSettings.fromJson(response.body['data']);
        log('Parsed working schedule: ${settings?.workingShedule}', name: "***** Parsed Data ******");
        try {
          log('Parsed working days: ${settings?.getDayTimeSlots()}', name: "***** Parsed Data ******");
        } catch (e) {
          log('Error parsing getDayTimeSlots: $e', name: "***** Parsed Data ******");
        }
        responseModel = ResponseModel(
          true,
          "Company business settings fetched successfully",
        );
      } else {
        responseModel = ResponseModel(false, "Failed to fetch company business settings");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in fetch company business settings");
      log(e.toString(), name: "***** Error in fetchCompanyBusinessSettings () ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  // Getter for working hours
  String? get workingHours => settings?.workingShedule;

  // Getter for day-time slots
  Map<String, String> get dayTimeSlots => settings?.getDayTimeSlots() ?? {
    "Monday": "Closed",
    "Tuesday": "Closed",
    "Wednesday": "Closed",
    "Thursday": "Closed",
    "Friday": "Closed",
    "Saturday": "Closed",
    "Sunday": "Closed",
  };
}