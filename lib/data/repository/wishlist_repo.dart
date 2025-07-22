import 'package:get/get_connect/http/src/response/response.dart';
import 'package:streammly/data/api/api_client.dart';
import 'dart:developer';

import '../../services/constants.dart';

class WishlistRepo {
  final ApiClient apiClient;

  WishlistRepo({required this.apiClient});

  Future<Response> getBookMark(String type) async {
    Response response = await apiClient.postData(AppConstants.getBookMark, {
      "type": type,
    });
    log('Status: ${response.statusCode}', name: 'BOOKMARK');
    log('Body: ${response.body}', name: 'BOOKMARK');
    log('BodyString: ${response.bodyString}', name: 'BOOKMARK');
    return response;
  }

  Future<Response> postBookmark(int? typeId, String type) async {
    return await apiClient.postData(AppConstants.postBookmark, {
      "type_id": typeId,
      "type": type,
    });
  }
}
