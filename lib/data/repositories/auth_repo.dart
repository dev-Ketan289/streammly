import 'package:get/get.dart';
import '../api/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;

  AuthRepo({required this.apiClient});

  Future<Response> generateOtp(String phone) async {
    return await apiClient.postData("/api/v1/user/auth/generateOtp", {
      "phone": phone,
    });
  }

  Future<Response> googleLogin(String idToken) async {
    return await apiClient.postData("/api/v1/user/auth/googleLogin", {
      "token": idToken,
    });
  }
}
