import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class CompanySpecialitiesRepo {
  final ApiClient apiClient;

  CompanySpecialitiesRepo({required this.apiClient});

  Future<Response> getCompanySpecialities(String subCategoryId)async {
    return await apiClient.postData(
      AppConstants.getCompanySpecialities,
      {"sub_category_id": subCategoryId},
    );
  }
}