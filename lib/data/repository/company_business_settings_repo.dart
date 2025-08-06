import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class CompanyBusinessSettingsRepo {
  final ApiClient apiClient;

  CompanyBusinessSettingsRepo({required this.apiClient});

  Future<Response> getCompanyBusinessSettings() async {
    return await apiClient.getData(AppConstants.getCompanyBusinessSettings);
  }
}
