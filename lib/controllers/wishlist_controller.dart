import 'dart:developer';

import 'package:get/get.dart';
import 'package:streammly/data/repository/category_repo.dart';
import 'package:streammly/models/category/category_model.dart';
import 'package:streammly/models/response/response_model.dart';

class WishlistController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  WishlistController({required this.categoryRepo});

  List<Bookmark> bookmarks = [];
  bool isLoading = true;

  Future<ResponseModel> loadBookmarks() async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await categoryRepo.getBookMark();
      log('${response.bodyString}', name: 'ljkdfs');
      if (response.statusCode == 200) {
        bookmarks = (response.body['data'] as List<dynamic>).map((item) => Bookmark.fromJson(item)).toList();
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
      Response response = await categoryRepo.postBookmark(typeId, type);
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
