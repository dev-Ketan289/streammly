import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
    Get.put(otpController, permanent: false);
    Get.to(() => OtpScreen(), arguments: "+91 $phone");

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

      // Get device ID
      final deviceInfo = DeviceInfoPlugin();
      String deviceId = '';
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
      }

      if (deviceId.isEmpty) {
        Fluttertoast.showToast(msg: "Device ID not found");
        return;
      }

      // Make API call
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/googleLogin");
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({"token": idToken, "device_id": deviceId}));

      final jsonResponse = jsonDecode(response.body);
      debugPrint("✅ API Response: $jsonResponse");

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        Fluttertoast.showToast(msg: "Login Successful");

        // Navigate to Welcome Screen
        Get.offAll(() => WelcomeScreen());
      } else {
        Fluttertoast.showToast(msg: jsonResponse['message'] ?? "Login failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
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
    if (phone.isEmpty || phone.length != 10) {
      Fluttertoast.showToast(msg: "Invalid phone number");
      return;
    }

    try {
      final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");

      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode({"phone": phone}));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['success'] == true) {
          final otpMessage = responseBody['data'];
          final otpCode = otpMessage.toString().split(" ").first;

          receivedOTP.value = otpCode;
          Fluttertoast.showToast(msg: "OTP resent: $otpCode");

          startTimer();
        } else {
          Fluttertoast.showToast(msg: responseBody['message'] ?? "Could not resend OTP");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not connect to server: $e");
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
