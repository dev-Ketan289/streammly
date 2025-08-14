import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/main.dart';
import 'package:streammly/services/constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> sendOtp({required String phone}) async {
    return await apiClient.postData(AppConstants.sendOtp, {"phone": phone, "app_signature": await SmsAutoFill().getAppSignature});
  }

  Future<Response> verifyOtp({required String phone, required String otp, required String deviceId}) async {
    return await apiClient.postData(AppConstants.verifyOtp, {"phone": phone, "otp": otp, "device_id": await messaging.getToken()});
  }

  Future<Response> signInWithGoogle({required String token, required String firebaseUid, required String deviceId}) async {
    return await apiClient.postData(AppConstants.signInWithGoogle, {"token": token, "device_id": await messaging.getToken(), "firebase_uid": firebaseUid});
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
    required String alternatePhone, // Add alternate phone parameter
    File? profileImage,
    File? coverImage,
  }) async {
    // Prepare form fields
    Map<String, String> fields = {'name': name, 'email': email, 'phone': phone, 'alternate_phone': alternatePhone};

    // Add optional fields only if they are provided
    if (dob != null) {
      fields['dob'] = dob;
    }

    if (gender != null) {
      fields['gender'] = gender;
    }

    // Call the multipart upload API
    return await apiClient.postMultipartData(AppConstants.updateUserProfile, fields, profileImage: profileImage, coverImage: coverImage);
  }

  Future<Response> updateUserAddress(
     String id,
    String title,
    String lineOne,
    String lineTwo,
    String landMark,
    String city,
    String state,
    String pinCode,
    String latitude,
    String longitude,
    String isDefault,
  ) async {
    return await apiClient.postData(AppConstants.updateUserAddress, {
      'id': id,
      'title': title,
      'line_one': lineOne,
      'line_two': lineTwo,
      'landmark': landMark,
      'city': city,
      'state': state,
      'pincode': pinCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    });
  }

  Future<Response> deleteUserAddress({required String id}) async {
    return await apiClient.postData(AppConstants.deleteUserAddress, {'id': id});
  }

  Future<Response> addUserAddress(
    String title,
    String lineOne,
    String lineTwo,
    String landMark,
    String city,
    String state,
    String pinCode,
    String latitude,
    String longitude,
    String isDefault,
  ) async {
    return await apiClient.postData(AppConstants.addUserAddress, {
      'title': title,
      'line_one': lineOne,
      'line_two': lineTwo,
      'landmark': landMark,
      'city': city,
      'state': state,
      'pincode': pinCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
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
