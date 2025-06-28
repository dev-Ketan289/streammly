import 'package:get/get.dart';
import 'package:streammly/data/repository/category_repo.dart';

import '../models/category/category_model.dart';

class CategoryController extends GetxController {
  final CategoryRepo categoryRepo;

  CategoryController({required this.categoryRepo});

  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      Response response = await categoryRepo.getCategories();

      if (response.statusCode == 200 && response.body['data'] != null) {
        categories.value = (response.body['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to load categories");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}

// class SubCategoryController extends GetxController {
//   final SubCategoryRepo subCategoryRepo;
//
//   SubCategoryController({required this.subCategoryRepo});
//
//   RxBool isLoading = false.obs;
//   RxList<SubCategoryModel> subCategories = <SubCategoryModel>[].obs;
//
//   Future<void> fetchSubCategories(int categoryId) async {
//     isLoading.value = true;
//     final response = await subCategoryRepo.getSubCategories(categoryId);
//     if (response.statusCode == 200) {
//       final List data = response.body['data'];
//       subCategories.value = data.map((e) => SubCategoryModel.fromJson(e)).toList();
//     }
//     isLoading.value = false;
//   }
// }
