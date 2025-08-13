  import 'dart:developer';

  import 'package:get/get.dart';
  import 'package:streammly/models/company/company_specialities_model.dart';
  import 'package:streammly/models/response/response_model.dart';

import '../data/repository/company_specialities_repo.dart';

  class CompanySpecialitiesController extends GetxController {
    final CompanySpecialitiesRepo companySpecialitiesRepo;

    CompanySpecialitiesController({required this.companySpecialitiesRepo});

    CompanySpecialities? companySpecialities;
    bool isLoading = true;
    List<Speciality> specialities = [];

    Future<ResponseModel?> getCompanySpecialities(String subCategorId) async {
      isLoading = true;
      specialities = [];

      update();
      ResponseModel? responseModel;
      try {
        Response response = await companySpecialitiesRepo.getCompanySpecialities(subCategorId);
        log(response.bodyString ?? "", name: "***** Response in fetchCompanySpecialities () ******");
        if (response.statusCode == 200 && response.body['data'] != null) {
          final companySpecialitiesList = response.body["data"] as List;
        log("Company specialities: $companySpecialitiesList", name: "fetchCompanySpecialitiessss");
        specialities = companySpecialitiesList.map((e) => Speciality.fromJson(e['speciality'])).toList();
        log(specialities[0].toJson().toString(), name: "Parsed Specialities");
          // }
          responseModel = ResponseModel(true, "Company specialities fetched successfully");
        } else {
          responseModel = ResponseModel(false, "Failed to fetch company specialities");
        }
      } catch (e) {
        responseModel = ResponseModel(false, "Error in fetch company specialities");
        log(e.toString(), name: "***** Error in fetchCompanySpecialities () ******");
      }
      isLoading = false;
      update();
      return responseModel;
    }
  }
