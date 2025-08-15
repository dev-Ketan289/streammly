import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/models/profile/user_profile_model.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/views/screens/auth_screens/create_user.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';
import 'package:uuid/uuid.dart';

import '../services/custom_error_pop_widget.dart';
import 'booking_form_controller.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;
  List<Address> address = [];

  String? loginMethod;

  // --- User Profile ---
  UserProfileModel? userProfile;

  Future<ResponseModel?> fetchUserProfile() async {
    isLoading = true;
    update();
    ResponseModel? responseModel;
    try {
      Response response = await authRepo.getUserProfile();
      log(
        response.bodyString ?? "",
        name: "***** Response in fetchUserProfile () ******",
      );
      if (response.statusCode == 200 && response.body['data'] != null) {
        userProfile = UserProfileModel.fromJson(response.body['data']);
        // If address is supposed to be a list, try to parse it from the response if available
        if (response.body['data']['addresses'] != null &&
            response.body['data']['addresses'] is List) {
          address =
              (response.body['data']['addresses'] as List)
                  .map((e) => Address.fromJson(e))
                  .toList();
        } else {
          address = [];
        }
        // Populate controllers with user profile data
        if (userProfile!.phone != null && userProfile!.phone!.isNotEmpty) {
          phoneController.text = userProfile!.phone!;
        }
        if (userProfile!.email != null && userProfile!.email!.isNotEmpty) {
          emailController.text = userProfile!.email!;
        }

        responseModel = ResponseModel(
          true,
          "User profile fetched successfully",
        );
      } else {
        responseModel = ResponseModel(false, "Failed to fetch user profile");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in fetch user profile");
      log(e.toString(), name: "***** Error in fetchUserProfile () ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel?> updateFullUserProfile({
    required String name,
    required String email,
    String? dob,
    String? gender,
    required String phone,
    String? alternatePhone,
    File? profileImage,
    File? coverImage,
  }) async {
    isLoading = true;
    update();

    ResponseModel? responseModel;

    try {
      // Validation
      if (name.trim().isEmpty || email.trim().isEmpty) {
        return ResponseModel(false, "Name and email are required");
      }
      if (!GetUtils.isEmail(email)) {
        return ResponseModel(false, "Invalid email format");
      }

      // API call
      Response response = await authRepo.updateFullUserProfile(
        name: name.trim(),
        email: email.trim(),
        dob: dob?.trim(),
        gender: gender,
        phone: phone.trim(),
        alternatePhone: alternatePhone!.trim(),
        profileImage: profileImage,
        coverImage: coverImage,
      );

      log(
        "Response Status: ${response.statusCode}",
        name: "updateFullUserProfile",
      );
      log(
        "Response Body: ${response.bodyString}",
        name: "updateFullUserProfile",
      );

      if (response.statusCode == 200 && response.body is Map<String, dynamic>) {
        final body = response.body as Map<String, dynamic>;

        bool isSuccess =
            body['success'] == true ||
            body['status'] == 'success' ||
            body['code'] == 200;

        if (isSuccess) {
          if (body['data'] is Map<String, dynamic>) {
            // Parse full user profile
            userProfile = UserProfileModel.fromJson(body['data']);
          }
          // If string, treat as success message only
          final msg = body['message'] ?? body['data'] ?? "Profile updated";
          responseModel = ResponseModel(true, msg.toString());
        } else {
          responseModel = ResponseModel(
            false,
            body['message'] ?? "Profile update failed",
          );
        }
      } else {
        final errorMessage =
            (response.body is Map && response.body['message'] != null)
                ? response.body['message']
                : "Server error occurred";
        log("HTTP Error: ${response.statusCode} - $errorMessage");
        responseModel = ResponseModel(false, errorMessage);
      }
    } catch (e, st) {
      log("Unexpected Error: $e\n$st", name: "updateFullUserProfile");
      responseModel = ResponseModel(false, "An unexpected error occurred");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  //address
  // Address Operations
  Future<ResponseModel> addUserAddress(
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
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await authRepo.addUserAddress(
        title,
        lineOne,
        lineTwo,
        landMark,
        city,
        state,
        pinCode,
        latitude,
        longitude,
        isDefault,
      );
      if (response.statusCode == 200 && response.body['success']) {
        fetchUserProfile();
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Address added successfully",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ?? "Failed to add address",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateUserAddress(
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
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await authRepo.updateUserAddress(
        id,
        title,
        lineOne,
        lineTwo,
        landMark,
        city,
        state,
        pinCode,
        latitude,
        longitude,
        isDefault,
      );
      if (response.statusCode == 200 && response.body['success']) {
        fetchUserProfile();
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Address updated successfully",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ?? "Failed to update address",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteUserAddress(String id) async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await authRepo.deleteUserAddress(id: id);
      if (response.statusCode == 200 && response.body['success']) {
        fetchUserProfile();
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Address deleted successfully",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ?? "Failed to delete address",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  // Otp Login
  Future<ResponseModel> sendOtp() async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      await SmsAutoFill().listenForCode().then((value) {
        log("listinnign for code ");
      });
      Response response = await authRepo.sendOtp(phone: phoneController.text);
      if (response.statusCode == 200) {
        loginMethod = 'phone';
        responseModel = ResponseModel(true, "Otp sent successfully");
      } else {
        responseModel = ResponseModel(false, "Failed to send OTP");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in send OTP");
      log(e.toString(), name: "***** Error in sendOtp () ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  // Google Login
  Future<ResponseModel?> signInWithGoogle() async {
    isLoading = true;
    update();
    ResponseModel responseModel;

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut(); // Force account picker
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google sign-in cancelled");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      final firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseUser == null) {
        Fluttertoast.showToast(msg: "Firebase authentication failed");
        return null;
      }

      final String firebaseUid = firebaseUser.uid;
      String deviceId = await getOrCreateDeviceId();

      if (deviceId.isEmpty) {
        Fluttertoast.showToast(msg: "Device ID not found");
        return null;
      }

      Response response = await authRepo.signInWithGoogle(
        token: firebaseIdToken ?? "",
        firebaseUid: firebaseUid,
        deviceId: deviceId,
      );

      if (response.statusCode == 200 && response.body["token"] != null) {
        setUserToken(response.body['token']);
        loginMethod = 'google';
        await fetchUserProfile();

        // NEW: Check for redirection target
        final args = Get.arguments as Map<String, dynamic>?;

        if (userProfile == null ||
            userProfile!.name == null ||
            userProfile!.email == null) {
          Get.offAll(() => ProfileFormScreen());
        } else {
          if (args != null && args['returnTo'] == 'quote') {
            Get.offAllNamed('/quote', arguments: args['quoteData']);
          } else {
            Get.offAll(() => const WelcomeScreen());
          }
        }

        responseModel = ResponseModel(true, "Google Sign-In Successful");
        emailController.text = googleUser.email;
      } else {
        responseModel = ResponseModel(false, "Failed to Google Sign-In");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in Google Sign-In");
      log(e.toString(), name: "*****  Error in signInWithGoogle () *****");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<String> getOrCreateDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? existingDeviceId = prefs.getString('device_id');

      if (existingDeviceId != null && existingDeviceId.length == 36) {
        return existingDeviceId;
      }

      const uuid = Uuid();
      String newDeviceId = uuid.v4();

      await prefs.setString('device_id', newDeviceId);

      return newDeviceId;
    } catch (e) {
      return '';
    }
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  void setUserToken(String id) {
    authRepo.saveUserToken(id);
  }

  bool isPhoneLogin() {
    return loginMethod == 'phone';
  }

  bool isGoogleLogin() {
    return loginMethod == 'google';
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Get.find<BookingController>().clearBookings();

      authRepo.clearSharedData();
      userProfile = null;
      loginMethod = null;
      phoneController.clear();
      emailController.clear();

      update();
    } catch (e) {
      log("Logout error: $e");
    }
  }

  void requireLogin(
    BuildContext context, {
    required String message,
    required VoidCallback onSuccess,
  }) {
    if (isLoggedIn()) {
      onSuccess();
    } else {
      CommonPopupDialog.show(
        context,
        imagePath: 'assets/images/access_denied.png', // your image asset
        title: "Login Required",
        message: message,
        primaryBtnText: "Login",
        onPrimaryPressed: () => Get.toNamed('/login'),
        secondaryBtnText: "Cancel",
        onSecondaryPressed: () {},
      );
    }
  }
}
