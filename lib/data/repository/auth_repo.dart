import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/services/constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.sendOtp, {
      "phone": phone,
      "app_signature": await SmsAutoFill().getAppSignature,
    });
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

  Future<Response> updateFullUserProfile({
    required String name,
    required String email,
    required String phone,
    String? dob,
    String? gender,
    String? alternatePhone, // Add alternate phone parameter
    File? profileImage,
    File? coverImage,
  }) async {
    // Prepare form fields
    Map<String, String> fields = {'name': name, 'email': email, 'phone': phone};

    // Add optional fields only if they are provided
    if (dob != null) {
      fields['dob'] = dob;
    }

    if (gender != null) {
      fields['gender'] = gender;
    }

    if (alternatePhone != null && alternatePhone.isNotEmpty) {
      fields['alternate_phone'] = alternatePhone;
    }

    // Call the multipart upload API
    return await apiClient.postMultipartData(
      AppConstants.updateUserProfile,
      fields,
      profileImage: profileImage,
      coverImage: coverImage,
    );
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
