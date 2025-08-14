import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:streammly/models/company/speciality_model.dart';

import '../../models/company/company_location.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class CompanyRepo {
  final ApiClient apiClient;
  CompanyRepo({required this.apiClient});

  // 1. Fetch companies by category + location (uses lat/lng headers)
  Future<List<CompanyLocation>> fetchCompaniesByCategory(
    int categoryId, {
    required double userLat,
    required double userLng,
    int? limit,
  }) async {
    try {
      // Build query parameters
      final Map<String, String> queryParams = {
        'category_id': categoryId.toString(),
      };

      // Add limit if specified
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      // Build URL with query parameters
      final uri = Uri.parse(
        'api/v1/company/getcompanyslocations',
      ).replace(queryParameters: queryParams);

      final response = await apiClient.getData(
        uri.toString(),
        headers: {
          'lat': userLat.toString(),
          'long': userLng.toString(),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      log('API Response Status: ${response.statusCode}', name: 'CompanyRepo');
      log('API Response Body: ${response.body}', name: 'CompanyRepo');

      if (response.statusCode == 200) {
        final responseData = response.body;

        // Check if response has the expected structure
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];

          log('Raw data count from API: ${data.length}', name: 'CompanyRepo');

          // Convert to CompanyLocation objects
          final companies =
              data
                  .map((json) {
                    try {
                      return CompanyLocation.fromJson(json);
                    } catch (e) {
                      log('Error parsing company: $e', name: 'CompanyRepo');
                      return null; // Skip invalid entries
                    }
                  })
                  .where((company) => company != null)
                  .cast<CompanyLocation>()
                  .toList();

          log(
            'Successfully parsed ${companies.length} companies',
            name: 'CompanyRepo',
          );
          return companies;
        } else {
          throw Exception(
            "Invalid response structure: ${responseData['message'] ?? 'Unknown error'}",
          );
        }
      } else {
        throw Exception("API Error ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      log('Repository error: $e', name: 'CompanyRepo');
      throw Exception('Failed to fetch companies: $e');
    }
  }

  // 2. Fetch single company by ID (with location headers)
  Future<CompanyLocation?> fetchCompanyById(
    int companyId, {
    required double userLat,
    required double userLng,
  }) async {
    final response = await apiClient.getData(
      "api/v1/company/getcompanysprofile/$companyId",
      headers: {
        'latitude': userLat.toString(),
        'longitude': userLng.toString(),
      },
    );
    if (response.body['data'] != null) {
      return CompanyLocation.fromJson(response.body['data']);
    }
    return null;
  }

  // 3. Fetch subcategories for a company
  Future<List<dynamic>> fetchCompanySubCategories(int companyId) async {
    final response = await apiClient.getData(
      "api/v1/company/getcompanysubcategories/$companyId",
    );
    return response.body['data'];
  }

  // 4. Fetch sub-verticals
  Future<List<dynamic>> fetchSubVerticals({
    required int companyId,
    required int subCategoryId,
  }) async {
    final response = await apiClient.postData("api/v1/company/getsubvertical", {
      "company_id": companyId,
      "sub_category_id": subCategoryId,
    });
    return response.body['data'];
  }

  // 5. Fetch specialized sub-verticals for a company
  Future<List<dynamic>> fetchSpecialized(int companyId) async {
    final response = await apiClient.postData(
      "api/v1/company/getspecializedin",
      {"company_id": companyId},
    );

    if (response.statusCode == 200 && response.body['data'] != null) {
      log(response.body.toString()); // ensure log always takes a String
      return response.body['data'];
    } else {
      throw Exception(
        "Failed to fetch specialized sub-verticals: ${response.body.toString()}",
      ); // fix here
    }
  }

  // 6. Fetch speciality for a company
  Future<List<Speciality>> fetchSpecialities() async {
    final response = await apiClient.getData("api/v1/company/getspecialities");

    if (response.statusCode == 200 && response.body['data'] != null) {
      final List<dynamic> data = response.body['data'];
      return data.map((e) => Speciality.fromJson(e)).toList();
    } else {
      throw Exception(
        "Failed to fetch specialities: ${response.body.toString()}",
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchPopularPackages(
    int companyId,
    int studioId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}api/v1/package/getpopularpackages"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'company_id': companyId, 'studio_id': studioId}),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonBody["data"] ?? []);
      }
      throw Exception(
        'Failed to load popular packages: ${response.statusCode}',
      );
    } catch (e) {
      throw Exception('Error fetching popular packages: $e');
    }
  }
}
