import 'package:get/get_connect/http/src/response/response.dart';
import 'package:streammly/data/api/api_client.dart';

import '../../services/constants.dart';

class WishlistRepo {
  final ApiClient apiClient;

  WishlistRepo({required this.apiClient});

  Future<Response> getBookMark() async {
    return await apiClient.getData(AppConstants.getBookMark);
  }

  Future<Response> postBookmark(int? typeId, String type) async {
    return await apiClient.postData(AppConstants.postBookmark, {
      "type_id": typeId,
      "type": type,
    });
  }
}
