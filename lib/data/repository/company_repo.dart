import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class CompanyRepo {
  final ApiClient apiClient;
  CompanyRepo({required this.apiClient});

  Future<Response> getCompaniesByCategory(int categoryId) async {
    return await apiClient.getData('${AppConstants.baseUrl}api/v1/basic/getcompanyslocations/$categoryId');
  }

  Future<Response> getCompanyById(int companyId) async {
    return await apiClient.getData('${AppConstants.baseUrl}api/v1/basic/getcompanysprofile/$companyId');
  }
}
