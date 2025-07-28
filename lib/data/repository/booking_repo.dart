import 'package:get/get_connect/http/src/response/response.dart';
import 'package:streammly/services/constants.dart';

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
}
