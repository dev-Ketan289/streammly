import 'dart:developer';

import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/data/repository/wishlist_repo.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';

class WishlistController extends GetxController implements GetxService {
  final CompanyController companyController;
  WishlistController({required this.companyController});

  List<RecommendedVendors> bookmarks = [];
  bool isLoading = true;

  Future<ResponseModel> loadBookmarks() async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await Get.find<WishlistRepo>().getBookMark();
      log('${response.bodyString}', name: 'ljkdfs');
      if (response.statusCode == 200) {
        bookmarks =
            (response.body['data'] as List<dynamic>)
                .map((item) => RecommendedVendors.fromJson(item))
                .toList();
        responseModel = ResponseModel(true, "Got Bookmarks");
      } else {
        bookmarks = [];
        responseModel = ResponseModel(false, "Failed to get Bookmarks");
      }
    } catch (e) {
      bookmarks = [];
      responseModel = ResponseModel(false, "Error in getting bookmarks");
      log(e.toString(), name: "***** Error in loadBookmarks () ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> addBookmark(int? typeId, String type) async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await Get.find<WishlistRepo>().postBookmark(
        typeId,
        type,
      );
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, "Bookmark added");
        await loadBookmarks(); // Refresh bookmarks after adding/removing
      } else {
        responseModel = ResponseModel(false, "Failed to add bookmark");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in adding bookmark");
      log(e.toString(), name: "***** Error in postBookmark() ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }
}
