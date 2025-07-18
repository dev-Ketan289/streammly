import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';

import '../views/screens/auth_screens/create_user.dart';
import 'auth_controller.dart';

class OtpController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  OtpController({required this.authRepo});

  RxInt secondsRemaining = 30.obs;
  RxString receivedOTP = ''.obs;
  RxBool shakeOnError = false.obs;
  bool isLoading = false;

  Timer? _timer;

  Future<ResponseModel> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    isLoading = true;
    update();
    ResponseModel responseModel;

    final phone = Get.find<AuthController>().phoneController.text.trim();

    /// Bypass check for test number
    if (phone == "8111111111") {
      Get.find<AuthController>().setUserToken("test-token");
      Fluttertoast.showToast(msg: "Test number login successful");
      isLoading = false;
      update();
      return ResponseModel(true, "Verification Successful");
    }

    try {
      /// Fetch device ID
      String deviceId = await Get.find<AuthController>().getOrCreateDeviceId();

      /// Verify OTP with device ID
      Response response = await authRepo.verifyOtp(
        phone: phone,
        otp: otp,
        deviceId: deviceId,
      );

      if (response.statusCode == 200 &&
          response.body['data']['token'] != null) {
        Get.find<AuthController>().setUserToken(response.body['data']['token']);
        Get.find<AuthController>().loginMethod = 'phone';

        /// Fetch user profile after login
        await Get.find<AuthController>().fetchUserProfile();

        /// Check if user is new or existing
        if (Get.find<AuthController>().userProfile == null ||
            Get.find<AuthController>().userProfile!.name == null ||
            Get.find<AuthController>().userProfile!.email == null) {
          /// New User → Show Profile Form
          Get.offAll(() => ProfileFormScreen());
        } else {
          /// Existing User → Go to Welcome Screen
          Get.offAll(() => const WelcomeScreen());
        }

        responseModel = ResponseModel(true, "Verification Successful");
      } else {
        shakeOnError.value = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          shakeOnError.value = false;
        });
        responseModel = ResponseModel(false, "Verification Failed");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in Verification");
      log(e.toString(), name: "***** Error in verifyOtp() *****");
    }

    isLoading = false;
    update();
    return responseModel;
  }

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

  void confirmOTP(String phone, String otp, {VoidCallback? onVerified}) {
    final enteredOTP = otp.trim();

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
      final url = Uri.parse(
        "https://admin.streammly.com/api/v1/user/auth/generateOtp",
      );
      // final url = Uri.parse("http://192.168.1.113:8000/api/v1/user/auth/generateOtp");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"phone": phone}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == true) {
        final otpMessage = responseBody['data'] ?? '';
        final otpCode = RegExp(r'\d{6}').firstMatch(otpMessage)?.group(0) ?? '';

        if (otpCode.isNotEmpty) {
          receivedOTP.value = otpCode;
          startTimer();
          Fluttertoast.showToast(msg: "OTP resent: $otpCode");
        } else {
          Fluttertoast.showToast(msg: "OTP format error");
        }
      } else {
        Fluttertoast.showToast(
          msg: responseBody['message'] ?? "Could not resend OTP",
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not connect to server");
    }
  }
}
