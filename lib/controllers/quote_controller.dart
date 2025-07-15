import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'auth_controller.dart';

class QuoteController extends GetxController {
  final RxBool isSubmitting = false.obs;
  final AuthController authController = Get.find<AuthController>();

  Future<void> submitQuote({
    required int companyId,
    required int subCategoryId,
    required int subVerticalId,
    required String userName,
    required String phone,
    required String email,
    required String message,
  }) async {
    isSubmitting.value = true;

    final String token = authController.getUserToken();
    if (token.isEmpty) {
      Get.snackbar("Error", "You must be logged in to submit a quote.");
      isSubmitting.value = false;
      return;
    }

    final body = {
      "company_id": companyId,
      "sub_category_id": subCategoryId,
      "sub_vertical_id": subVerticalId,
      "user_name": userName,
      "phone": phone,
      "email": email,
      "message": message,
    };

    try {
      final response = await http.post(
        Uri.parse("https://admin.streammly.com/api/v1/quotation/addquotation"),
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Quote request submitted!");
        Get.back(); // Optionally close screen
      } else {
        Get.snackbar("Error", "Failed to submit quote. Please try again.");
        print("Status Code: ${response.statusCode}");

        print("Response: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
