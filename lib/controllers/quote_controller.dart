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
    print("DEBUG TOKEN: $token");

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

    final url = Uri.parse("https://admin.streammly.com/api/v1/quotation/addquotation");

    print("POST URL: $url");
    print("POST BODY: $body");
    print("HEADERS: ${{"Content-Type": "application/json", "Authorization": "Bearer $token"}}");

    try {
      final response = await http.post(url, headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: jsonEncode(body));

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Quote request submitted!");
        Get.back(); // Optionally close the screen
      } else if (response.statusCode == 302) {
        Get.snackbar("Redirected", "You were redirected. Check token or endpoint.");
      } else {
        Get.snackbar("Error", "Failed to submit quote. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
      print("EXCEPTION: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
