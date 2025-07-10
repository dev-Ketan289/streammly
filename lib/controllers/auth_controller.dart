import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:uuid/uuid.dart';

import '../models/profile/user_profile.dart';
import '../views/screens/auth_screens/create_user.dart';
import '../views/screens/auth_screens/welcome.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  String? loginMethod;

  // --- User Profile ---
  UserProfile? userProfile;

  Future<ResponseModel?> fetchUserProfile() async {
    isLoading = true;
    update();
    ResponseModel? responseModel;
    try {
      Response response = await authRepo.getUserProfile();
      log(response.bodyString ?? "", name: "***** Response in fetchUserProfile () ******");
      if (response.statusCode == 200 && response.body['data'] != null) {
        userProfile = UserProfile.fromJson(response.body['data']);
        
        // Populate controllers with user profile data
        if (userProfile!.phone != null && userProfile!.phone!.isNotEmpty) {
          phoneController.text = userProfile!.phone!;
        }
        if (userProfile!.email != null && userProfile!.email!.isNotEmpty) {
          emailController.text = userProfile!.email!;
        }
        
        responseModel = ResponseModel(true, "User profile fetched successfully");
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

  Future<ResponseModel?> updateUserProfile({required String name, required String email, String? dob, String? gender, required String phone}) async {
    isLoading = true;
    update();
    ResponseModel? responseModel;
    try {
      Response response = await authRepo.updateUserProfile(name: name, email: email, dob: dob, gender: gender, phone: phone);
      log("${response.bodyString}", name: "***** Response in updateUserProfile () ******");
      if (response.statusCode == 200) {
        fetchUserProfile();
        responseModel = ResponseModel(true, "User profile updated successfully");
      } else {
        responseModel = ResponseModel(false, "Failed to update user profile");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in update user profile");
      log(e.toString(), name: "***** Error in updateUserProfile () ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> sendOtp() async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
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

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
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

      Response response = await authRepo.signInWithGoogle(token: firebaseIdToken ?? "", firebaseUid: firebaseUid, deviceId: deviceId);

      if (response.statusCode == 200 && response.body["token"] != null) {
        setUserToken(response.body['token']);
        loginMethod = 'google';
        await fetchUserProfile();
        if (userProfile == null || userProfile!.name == null || userProfile!.email == null) {
          Get.offAll(() => ProfileFormScreen());
        } else {
          Get.offAll(() => const WelcomeScreen());
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

  // /// Google Login Setup
  // void signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       Fluttertoast.showToast(msg: "Google sign-in cancelled");
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(credential);
  //     final User? firebaseUser = userCredential.user;

  //     if (firebaseUser == null) {
  //       Fluttertoast.showToast(msg: "Firebase authentication failed");
  //       return;
  //     }

  //     final String firebaseUid = firebaseUser.uid;
  //     final String firebaseProjectId = Firebase.app().options.projectId;
  //     String deviceId = await getOrCreateDeviceId();

  //     if (deviceId.isEmpty) {
  //       Fluttertoast.showToast(msg: "Device ID not found");
  //       return;
  //     }

  //     final url = Uri.parse(
  //       "http://192.168.1.10:8000/api/v1/user/auth/googleLogin",
  //     );

  //     final body = jsonEncode({
  //       "token": firebaseProjectId,
  //       "device_id": deviceId,
  //       "firebase_uid": firebaseUid,
  //     });

  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //       body: body,
  //     );

  //     final jsonResponse = jsonDecode(response.body);

  //     if (response.statusCode == 200 && jsonResponse['success'] == true) {
  //       Fluttertoast.showToast(msg: "Login Successful");
  //       Get.offAll(() => WelcomeScreen());
  //     } else {
  //       String errorMessage =
  //           jsonResponse['message']?.toString() ?? "Login failed";
  //       if (errorMessage.length > 100) {
  //         errorMessage = "${errorMessage.substring(0, 100)}...";
  //       }
  //       Fluttertoast.showToast(msg: errorMessage);
  //     }
  //   } catch (e) {
  //     await FirebaseAuth.instance.signOut();
  //     await GoogleSignIn().signOut();

  //     Fluttertoast.showToast(msg: "Error: $e");
  //   }
  // }

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
}
