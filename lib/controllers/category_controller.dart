import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/category/category_model.dart';

class CategoryController extends GetxController {
  var categories = <CategoryModel>[].obs;
  var isLoading = true.obs;
  final String baseUrl = 'http://192.168.1.27:8000/';

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('${baseUrl}api/v1/basic/categories'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dataList = jsonData['data'];

        categories.value = dataList.map((item) => CategoryModel.fromJson(item)).toList();
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
