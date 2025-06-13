import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

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

    // API call in background
    Future.delayed(Duration.zero, () async {
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"phone": phone}),
        );

        final responseBody = jsonDecode(response.body);

        if (response.statusCode == 200 && responseBody['success'] == true) {
          final otpMessage = responseBody['data'];
          final otpCode = otpMessage.toString().split(" ").first;

          otpController.receivedOTP.value = otpCode;

          Fluttertoast.showToast(msg: "OTP Sent: $otpCode");
        } else {
          Fluttertoast.showToast(msg: responseBody['message'] ?? "Could not send OTP");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Could not connect to server");
      }
    });
  }
///-Google Login Setup
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(msg: "Google sign-in cancelled");
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        Fluttertoast.showToast(msg: "Failed to get ID token");
        return;
      }

      // Backend call
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/googleLogin");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        Fluttertoast.showToast(msg: "Login Successful");

        // Navigate to WelcomeScreen
        Get.offAll(() => WelcomeScreen());
      } else {
        Fluttertoast.showToast(msg: responseData['message'] ?? "Sign-in failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Sign-in error: $e");
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
    _timer?.cancel(); // cancel previous timer if any
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
    try {
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phone": phone}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        final otpMessage = responseBody['data'];
        final otpCode = otpMessage.toString().split(" ").first;

        receivedOTP.value = otpCode;
        Fluttertoast.showToast(msg: "OTP resent");
        startTimer();
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