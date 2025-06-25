import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> sendOtp({required String phone}) async =>
      await apiClient.postData(AppConstants.sendOtp, {"phone": phone});

  Future<Response> verifyOtp({
    required String phone,
    required String otp,
  }) async => await apiClient.postData(AppConstants.verifyOtp, {
    "phone": phone,
    "otp": otp,
    "device_id": "fhif",
  });
}
