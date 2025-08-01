import 'dart:developer';

import '../../models/company/company_location.dart';
import '../api/api_client.dart';

class CompanyRepo {
  final ApiClient apiClient;
  CompanyRepo({required this.apiClient});

  // 1. Fetch companies by category + location (uses lat/lng headers)
  Future<List<CompanyLocation>> fetchCompaniesByCategory(int categoryId, {required double userLat, required double userLng}) async {
    final response = await apiClient.getData("api/v1/company/getcompanyslocations?category_id=$categoryId", headers: {'lat': userLat.toString(), 'long': userLng.toString()});

    if (response.statusCode == 200 && response.body['data'] != null) {
      final List<dynamic> data = response.body['data'];
      return data.map((e) => CompanyLocation.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch companies: ${response.body}");
    }
  }

  // 2. Fetch single company by ID (with location headers)
  Future<CompanyLocation?> fetchCompanyById(int companyId, {required double userLat, required double userLng}) async {
    final response = await apiClient.getData("api/v1/company/getcompanysprofile/$companyId", headers: {'latitude': userLat.toString(), 'longitude': userLng.toString()});
    if (response.body['data'] != null) {
      return CompanyLocation.fromJson(response.body['data']);
    }
    return null;
  }

  // 3. Fetch subcategories for a company
  Future<List<dynamic>> fetchCompanySubCategories(int companyId) async {
    final response = await apiClient.getData("api/v1/company/getcompanysubcategories/$companyId");
    return response.body['data'];
  }

  // 4. Fetch sub-verticals
  Future<List<dynamic>> fetchSubVerticals({required int companyId, required int subCategoryId}) async {
    final response = await apiClient.postData("api/v1/company/getsubvertical", {"company_id": companyId, "sub_category_id": subCategoryId});
    return response.body['data'];
  }

  // 5. Fetch specialized sub-verticals for a company
  Future<List<dynamic>> fetchSpecialized(int companyId) async {
    final response = await apiClient.postData("api/v1/company/getspecializedin", {"company_id": companyId});

    if (response.statusCode == 200 && response.body['data'] != null) {
      log(response.body.toString()); // ensure log always takes a String
      return response.body['data'];
    } else {
      throw Exception("Failed to fetch specialized sub-verticals: ${response.body.toString()}"); // fix here
    }
  }
}
