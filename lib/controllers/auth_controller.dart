import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../views/screens/auth_screens/otp_verification_screen.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  void generateOTP() async {
    String phone = phoneController.text.trim();

    if (phone.length != 10) {
      Get.snackbar("Invalid", "Please enter a valid 10-digit phone number");
      return;
    }

    final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");

    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({"phone": phone}));

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        final otpMessage = responseBody['data'];
        final otpCode = otpMessage.toString().split(" ").first;

        Get.snackbar("OTP Sent", otpMessage);

        if (Get.isRegistered<OtpController>()) {
          Get.delete<OtpController>();
        }

        final otpController = Get.put(OtpController());
        otpController.receivedOTP.value = otpCode;

        Get.to(() => OtpScreen(), arguments: "+91 $phone");
      } else {
        Get.snackbar("Failed", responseBody['message'] ?? "Could not send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not connect to server");
    }
  }

  void signInWithGoogle() {
    print("Google Sign-In tapped");
  }
}

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  RxInt secondsRemaining = 30.obs;
  RxString receivedOTP = ''.obs;
  late Timer _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void confirmOTP({VoidCallback? onVerified}) {
    final otp = otpController.text.trim();
    if (otp.length == 6 && otp == receivedOTP.value) {
      Get.snackbar('OTP Verified', 'Proceeding to next page');
      if (onVerified != null) onVerified();
      Get.delete<OtpController>();
    } else {
      Get.snackbar('Invalid', 'Enter a valid 6-digit code');
    }
  }

  void resendOTP() {
    secondsRemaining.value = 30;
    startTimer();
    // Optionally re-call backend for OTP
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer.cancel();
    super.onClose();
  }
}
