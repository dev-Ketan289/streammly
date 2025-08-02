import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:streammly/services/constants.dart';

import '../../controllers/auth_controller.dart';
import '../../models/response/response_model.dart';
import '../api/api_client.dart';

class BookingRepo {
  final ApiClient apiClient;

  BookingRepo({required this.apiClient});

  Future<Response> fetchAvailableSlots({
    required String studioId,
    required String typeId,
    required String date,
    required String companyId,
  }) async {
    return await apiClient.postData(AppConstants.storeBooking, {
      "studio_id": studioId,
      "type_id": typeId,
      "date": date,
      "company_id": companyId,
    });
  }
  Future<ResponseModel> placeBooking(Map<String, dynamic> bookingData) async {
    try {
      // Retrieve token from wherever you store it, e.g. from AuthController
      final String token = Get.find<AuthController>().getUserToken();

      // Send POST request with bearer token authorization header
      Response response = await apiClient.postData(
        'api/v1/booking/direct-booking',
        bookingData,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',  // ensure content type if required
        },
      );

      if (response.statusCode == 200) {
        return ResponseModel(true, "Booking successful");
      } else {
        return ResponseModel(false, response.statusText ?? "Booking failed");
      }
    } catch (e) {
      return ResponseModel(false, e.toString());
    }
  }

}
