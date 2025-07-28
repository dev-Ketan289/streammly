import 'package:get/get.dart';
import '../data/repository/quote_repo.dart';
import 'auth_controller.dart';
import '../views/screens/package/widgets/get_quote_conformation.dart';

class QuoteController extends GetxController implements GetxService {
  final QuoteRepo quoteRepo;

  QuoteController({required this.quoteRepo});

  bool isSubmitting = false;
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
    required String shootType,
  }) async {
    isSubmitting = true;
    update();

    final String token = authController.getUserToken();
    if (token.isEmpty) {
      Get.snackbar("Error", "You must be logged in to submit a quote.");
      isSubmitting = false;
      update();
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

    try {
      final response = await quoteRepo.submitQuote(body);

      if (response.statusCode == 200) {
        final formattedDateTime = "$dateOfShoot, $startTime";
        Get.off(() => QuoteSubmittedScreen(
          shootType: shootType,
          submittedDateTime: formattedDateTime,
        ));
        Get.snackbar("Success", "Quote request submitted!");
      } else {
        Get.snackbar("Error", "Failed to submit quote.");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isSubmitting = false;
      update();
    }
  }
}
