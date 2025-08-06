import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class CompanyBusinessSettingsRepo {
  final ApiClient apiClient;

  CompanyBusinessSettingsRepo({required this.apiClient});

  Future<Response> getCompanyBusinessSettings(String companyId) async {
    return await apiClient.postData(
      AppConstants.getCompanyBusinessSettings,
      {"company_id": companyId},
    );
  }
}