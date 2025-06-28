import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompanyRepo {
  final String baseUrl = 'http://192.168.1.113:8000/api/v1/company';

  Future<Response> fetchCompaniesByCategory(int categoryId) async {
    final url = Uri.parse('$baseUrl/getcompanyslocations/$categoryId');
    return await http.get(url).then((r) => Response(statusCode: r.statusCode, body: r.body));
  }

  Future<Response> fetchCompanyById(int companyId) async {
    final url = Uri.parse('$baseUrl/getcompanysprofile/$companyId');
    return await http.get(url).then((r) => Response(statusCode: r.statusCode, body: r.body));
  }

  Future<Response> fetchCompanySubCategories(int companyId) async {
    final url = Uri.parse('$baseUrl/getcompanysubcategories/$companyId');
    return await http.get(url).then((r) => Response(statusCode: r.statusCode, body: r.body));
  }

  Future<Response> fetchSubVerticals({required int companyId, required int subCategoryId}) async {
    final url = Uri.parse('$baseUrl/getsubvertical');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"company_id": companyId, "sub_category_id": subCategoryId}),
    ).then((r) => Response(statusCode: r.statusCode, body: r.body));
  }
}
