import '../../models/package/package_model.dart';
import '../api/api_client.dart';

class PackageRepo {
  final ApiClient apiClient;
  PackageRepo({required this.apiClient});

  Future<List<PackageModel>> fetchPackages({required int companyId, required int subCategoryId, required int subVerticalId}) async {
    final response = await apiClient.postData("api/v1/package/getpackages", {"company_id": companyId, "sub_category_id": subCategoryId, "sub_vertical_id": subVerticalId});

    final List<dynamic> data = response.body['data'] ?? [];
    return data.map((e) => PackageModel.fromJson(e)).toList();
  }
}
