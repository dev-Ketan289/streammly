import 'dart:developer';

import '../../models/company/company_location.dart';
import '../api/api_client.dart';

class CompanyRepo {
  final ApiClient apiClient;
  CompanyRepo({required this.apiClient});

  Future<List<CompanyLocation>> fetchCompaniesByCategory(int categoryId) async {
    final response = await apiClient.getData("api/v1/company/getcompanyslocations/$categoryId");
    final List<dynamic> data = response.body['data'] ?? [];
    log(data.toString(), name: 'data');
    log(response.bodyString.toString() ,name: 'data');
    return data.map((e) => CompanyLocation.fromJson(e)).toList();
  }

  Future<CompanyLocation?> fetchCompanyById(int companyId) async {
    final response = await apiClient.getData("api/v1/company/getcompanysprofile/$companyId");
    return CompanyLocation.fromJson(response.body['data']);
  }

  Future<List<dynamic>> fetchCompanySubCategories(int companyId) async {
    final response = await apiClient.getData("api/v1/company/getcompanysubcategories/$companyId");
    return response.body['data'];
  }

  Future<List<dynamic>> fetchSubVerticals({required int companyId, required int subCategoryId}) async {
    final response = await apiClient.postData("api/v1/company/getsubvertical", {"company_id": companyId, "sub_category_id": subCategoryId});
    return response.body['data'];
  }
}
