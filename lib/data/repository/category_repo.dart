import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class CategoryRepo {
  final ApiClient apiClient;

  CategoryRepo({required this.apiClient});

  Future<Response> getCategories() async {
    return await apiClient.getData(AppConstants.categoriesUrl);
  }
}
