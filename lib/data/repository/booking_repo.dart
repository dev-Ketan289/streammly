import 'dart:convert';

import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../services/constants.dart';
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

  Future<Map<String, dynamic>?> placeBatchBooking(
    Map<String, dynamic> batchBookingData,
  ) async {
    try {
      final String token = Get.find<AuthController>().getUserToken();

      final response = await apiClient.postData(
        'api/v1/booking/direct-booking',
        batchBookingData,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Return full JSON map, e.g. with thankyouPage data
        if (response.body is Map<String, dynamic>) {
          return Map<String, dynamic>.from(response.body);
        } else if (response.bodyString != null) {
          return jsonDecode(response.bodyString!);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Lead Response
  // In booking_repo.dart
  Future<Response> storeLead({
    required int companyId,
    required int packageId,
  }) async {
    final String token = Get.find<AuthController>().getUserToken();

    return await apiClient.postData(
      AppConstants.storeLeadsUri,
      {'company_id': companyId, 'package_id': packageId},
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Map<String, dynamic>?> getUserBookings() async {
    try {
      final token = Get.find<AuthController>().getUserToken();
      final response = await apiClient.getData(
        'api/v1/booking/my-bookings',
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (response.body is Map<String, dynamic>) {
          return Map<String, dynamic>.from(response.body);
        } else if (response.bodyString != null) {
          return jsonDecode(response.bodyString!);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
