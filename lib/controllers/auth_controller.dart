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

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  Future<ResponseModel> sendOtp() async {
    isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await authRepo.sendOtp(phone: phoneController.text);
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, "Otp sent successfull");
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
      log(name: "googleDebig", "etes");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      log(name: "googleDebig", "first");
      if (googleUser == null) {
        log(name: "googleDebig", "googleUser");
        Fluttertoast.showToast(msg: "Google sign-in cancelled");
        return null;
      }
      log(name: "googleDebig", "second");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      log(name: "googleDebig", "thid");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;
      log(name: "googleDebig", "four");
      final firebaseIdToken = await userCredential.user?.getIdToken();
      if (firebaseUser == null) {
        log(name: "googleDebig", "firebaseUser");

        Fluttertoast.showToast(msg: "Firebase authentication failed");
        return null;
      }

      final String firebaseUid = firebaseUser.uid;
      // final String firebaseProjectId = Firebase.app().options.projectId;
      String deviceId = await getOrCreateDeviceId();

      if (deviceId.isEmpty) {
        log(name: "googleDebig", "deviceId");

        Fluttertoast.showToast(msg: "Device ID not found");
        return null;
      }
      Response response = await authRepo.signInWithGoogle(
        token: firebaseIdToken ?? "",
        // token: googleAuth.accessToken ?? "",
        firebaseUid: firebaseUid,
      );
      if (response.statusCode == 200 && response.body["token"] != null) {
        setUserToken(response.body['token']);
        responseModel = ResponseModel(true, "Google Sign-In Successful");
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
}
