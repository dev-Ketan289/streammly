import 'package:get/get.dart';
import 'package:streammly/data/repository/category_repo.dart';

import '../models/category/category_model.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;

  CategoryController({required this.categoryRepo});

  List<CategoryModel> categories = [];  
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      isLoading = true;
      update();

      Response response = await categoryRepo.getCategories();

      if (response.statusCode == 200 && response.body['data'] != null) {
        categories = (response.body['data'] as List).map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to load categories");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
