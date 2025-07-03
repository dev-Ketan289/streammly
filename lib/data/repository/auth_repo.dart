import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.sendOtp, {"phone": phone});
  }

  Future<Response> verifyOtp({required String phone, required String otp}) async {
    return await apiClient.postData(AppConstants.verifyOtp, {"phone": phone, "otp": otp, "device_id": "fhif"});
  }

  Future<Response> signInWithGoogle({required String token, required String firebaseUid}) async {
    return await apiClient.postData(AppConstants.signInWithGoogle, {
      "token": token,
      "device_id": "fiukjfkhskjahfkljshfkljhsdkjfhksjdfkjhskjhfkshdkfhksjhdfkjhskjh",
      "firebase_uid": firebaseUid,
    });
  }

  Future<Response> getUserProfile() async {
    return await apiClient.getData(AppConstants.getUserProfile);
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<bool> saveUserId(String id) async {
    log(getUserId());
    return await sharedPreferences.setString(AppConstants.userId, id);
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.userId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userId);
    apiClient.token = null;
    apiClient.updateHeader(null);
    return true;
  }
}
