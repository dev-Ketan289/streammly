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

  Future<Response> verifyOtp({
    required String phone,
    required String otp,
    required String deviceId,
  }) async {
    return await apiClient.postData(AppConstants.verifyOtp, {
      "phone": phone,
      "otp": otp,
      "device_id": deviceId,
    });
  }

  Future<Response> signInWithGoogle({
    required String token,
    required String firebaseUid,
    required String deviceId,
  }) async {
    return await apiClient.postData(AppConstants.signInWithGoogle, {
      "token": token,
      "device_id": deviceId,
      "firebase_uid": firebaseUid,
    });
  }

  Future<Response> getUserProfile() async {
    return await apiClient.getData(AppConstants.getUserProfile);
  }

  Future<Response> updateUserProfile({
    required String name,
    required String email,
    String? dob,
    String? gender,
    required String phone,
  }) async {
    return await apiClient.postData(AppConstants.updateUserProfile, {
      "name": name,
      "email": email,
      "dob": dob,
      "gender": gender,
      "phone": phone,
    });
  }

  Future<Response> saveUserProfile({
    required String name,
    required String email,
    String? dob,
    String? gender,
  }) async {
    return await apiClient.postData("/api/v1/user", {
      "name": name,
      "email": email,
      "dob": dob,
      "gender": gender,
    });
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
