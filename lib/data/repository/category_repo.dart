import 'package:get/get.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class CategoryRepo {
  final ApiClient apiClient;

  CategoryRepo({required this.apiClient});

  Future<Response> getCategories() async {
    return await apiClient.getData(AppConstants.categoriesUrl);
  }

  Future<Response> getBookMark() async {
    return await apiClient.getData(AppConstants.getBookMark);
  }

  Future<Response> postBookmark(int? typeId,String type) async {
    return await apiClient.postData(AppConstants.postBookmark, {
      "type_id": typeId,
      "type": type,
    });
  }
}
