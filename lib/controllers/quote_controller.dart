import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/screens/package/widgets/get_quote_conformation.dart';
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
    required String dateOfShoot,
    required String startTime,
    required String endTime,
    required String favorableDate,
    required String favorableStartTime,
    required String favorableEndTime,
    required String requirement,
    required String shootType, // <-- Added shootType dynamically
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
      "name": userName,
      "phone": phone,
      "email": email,
      "date_of_shoot": dateOfShoot,
      "start_time": startTime,
      "end_time": endTime,
      "requirement": requirement,
      "favorable_date": favorableDate,
      "favorable_start_time": favorableStartTime,
      "favorable_end_time": favorableEndTime,
    };
    
    // final url = Uri.parse("https://admin.streammly.com/api/v1/quotation/addquotation");
    final url = Uri.parse("http://192.168.1.113:8000/api/v1/quotation/addquotation");


    print("POST URL: $url");
    print("POST BODY: $body");
    print("HEADERS: ${{"Content-Type": "application/json", "Authorization": "Bearer $token"}}");

    try {
      final response = await http.post(url, headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: jsonEncode(body));

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        // Combine date and time into a readable format
        final formattedDateTime = "$dateOfShoot, $startTime";

        // Navigate to confirmation screen
        Get.off(() => QuoteSubmittedScreen(shootType: shootType, submittedDateTime: formattedDateTime));

        Get.snackbar("Success", "Quote request submitted!");
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
