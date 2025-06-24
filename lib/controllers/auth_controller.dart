import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../views/screens/auth_screens/otp_verification_screen.dart';
import '../views/screens/auth_screens/welcome.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  void generateOTP() {
    String phone = phoneController.text.trim();

    if (phone.length != 10) {
      Fluttertoast.showToast(msg: "Please enter a valid 10-digit phone number");
      return;
    }

    // Remove any existing OTP controller
    if (Get.isRegistered<OtpController>()) {
      Get.delete<OtpController>();
    }

    final otpController = Get.put(OtpController());

    // Navigate to OTP screen immediately
    Get.to(() => OtpScreen(), arguments: "+91 $phone");

    // TEST NUMBER HANDLING (Auto-set OTP)
    if (phone == "8111111111") {
      otpController.receivedOTP.value = "123456";
      otpController.startTimer();
      Fluttertoast.showToast(msg: "Test OTP auto-filled: 123456");
      return;
    }

    // API call in background
    Future.delayed(Duration.zero, () async {
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");

      try {
        final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({"phone": phone}));

        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 200 && responseBody['success'] == true) {
          final otpMessage = responseBody['data'];
          final otpCode = otpMessage.toString().split(" ").first;

          otpController.receivedOTP.value = otpCode;
          otpController.startTimer();

          Fluttertoast.showToast(msg: "OTP Sent: $otpCode");
        } else {
          Fluttertoast.showToast(msg: responseBody['message'] ?? "Could not send OTP");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Could not connect to server");
      }
    });
  }

  /// Google Login Setup
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google sign-in cancelled");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        Fluttertoast.showToast(msg: "Firebase authentication failed");
        return;
      }

      final String firebaseUid = firebaseUser.uid;
      final String firebaseProjectId = Firebase.app().options.projectId ?? "unknown-project";
      String deviceId = await getOrCreateDeviceId();

      if (deviceId.isEmpty) {
        Fluttertoast.showToast(msg: "Device ID not found");
        return;
      }

      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/googleLogin");

      final body = jsonEncode({"token": firebaseProjectId, "device_id": deviceId, "firebase_uid": firebaseUid});

      final response = await http.post(url, headers: {'Content-Type': 'application/json', 'Accept': 'application/json'}, body: body);

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        Fluttertoast.showToast(msg: "Login Successful");
        Get.offAll(() => WelcomeScreen());
      } else {
        String errorMessage = jsonResponse['message']?.toString() ?? "Login failed";
        if (errorMessage.length > 100) {
          errorMessage = errorMessage.substring(0, 100) + "...";
        }
        Fluttertoast.showToast(msg: errorMessage);
      }
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      Fluttertoast.showToast(msg: "Error: $e");
    }
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
}

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  RxInt secondsRemaining = 30.obs;
  RxString receivedOTP = ''.obs;
  RxBool shakeOnError = false.obs;

  Timer? _timer;

  void startTimer() {
    _timer?.cancel();
    secondsRemaining.value = 30;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void confirmOTP(String phone, {VoidCallback? onVerified}) {
    final enteredOTP = otpController.text.trim();

    ///  Bypass check for test number
    if (phone == "8111111111") {
      Fluttertoast.showToast(msg: "Test number login successful");
      onVerified?.call();
      Get.delete<OtpController>();
      return;
    }

    if (enteredOTP.length == 6 && enteredOTP == receivedOTP.value) {
      Fluttertoast.showToast(msg: "OTP Verified");
      onVerified?.call();
      Get.delete<OtpController>();
    } else {
      shakeOnError.value = true;
      Fluttertoast.showToast(msg: "Invalid OTP");
      Future.delayed(const Duration(milliseconds: 500), () {
        shakeOnError.value = false;
      });
    }
  }

  void resendOTP(String phone) async {
    if (phone == "8111111111") {
      receivedOTP.value = "123456";
      startTimer();
      Fluttertoast.showToast(msg: "Test OTP resent: 123456");
      return;
    }

    try {
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({"phone": phone}));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        final otpMessage = responseBody['data'];
        final otpCode = otpMessage.toString().split(" ").first;

        receivedOTP.value = otpCode;
        startTimer();
        Fluttertoast.showToast(msg: "OTP resent: $otpCode");
      } else {
        Fluttertoast.showToast(msg: responseBody['message'] ?? "Could not resend OTP");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not connect to server");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
