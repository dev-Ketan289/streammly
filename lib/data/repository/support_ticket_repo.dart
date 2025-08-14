import 'package:get/get.dart';
import 'package:streammly/services/constants.dart';

import '../../controllers/auth_controller.dart';
import '../api/api_client.dart';

class SupportTicketRepo extends GetxService {
  final ApiClient apiClient;

  SupportTicketRepo({required this.apiClient});

  Future<Response?> getSupportTickets() async {
    final String token = Get.find<AuthController>().getUserToken();

    try {
      // Changed from getData to postData with empty body
      final response = await apiClient.postData(
        AppConstants.getSupportTicket,
        {}, // Empty data object for POST request
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      print('Error in getSupportTickets: $e');
      return null;
    }
  }

  Future<Response?> createSupportTicket({
    required String title,
    required String description,
    int? bookingId,
    String? referenceImage,
  }) async {
    final String token = Get.find<AuthController>().getUserToken();

    try {
      final data = {
        'title': title,
        'description': description,
        if (bookingId != null) 'booking_id': bookingId.toString(),
        if (referenceImage != null) 'reference_image': referenceImage,
      };

      final response = await apiClient.postData(
        AppConstants.addSupportTicket,
        data,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return response;
    } catch (e) {
      print('Error in createSupportTicket: $e');
      return null;
    }
  }
}
