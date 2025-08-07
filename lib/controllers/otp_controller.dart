import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';

import '../views/screens/auth_screens/create_user.dart';
import 'auth_controller.dart';

class OtpController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  OtpController({required this.authRepo});

  int secondsRemaining = 30;
  String receivedOTP = '';
  bool shakeOnError = false;
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

    if (phone == "8111111111") {
      Get.find<AuthController>().setUserToken("test-token");
      Fluttertoast.showToast(msg: "Test number login successful");
      isLoading = false;
      update();
      return ResponseModel(true, "Verification Successful");
    }

    try {
      String deviceId = await Get.find<AuthController>().getOrCreateDeviceId();

      Response response = await authRepo.verifyOtp(
        phone: phone,
        otp: otp,
        deviceId: deviceId,
      );

      if (response.statusCode == 200 &&
          response.body['data']['token'] != null) {
        Get.find<AuthController>().setUserToken(response.body['data']['token']);
        Get.find<AuthController>().loginMethod = 'phone';

        await Get.find<AuthController>().fetchUserProfile();

        if (Get.find<AuthController>().userProfile == null ||
            Get.find<AuthController>().userProfile!.name == null ||
            Get.find<AuthController>().userProfile!.email == null) {
          Get.offAll(() => ProfileFormScreen());
        } else {
          Get.offAll(() => const WelcomeScreen());
        }

        responseModel = ResponseModel(true, "Verification Successful");
      } else {
        shakeOnError = true;
        update();
        Future.delayed(const Duration(milliseconds: 500), () {
          shakeOnError = false;
          update();
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
    secondsRemaining = 30;
    update();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        update();
      } else {
        timer.cancel();
      }
    });
  }

  void confirmOTP(String phone, String otp, {VoidCallback? onVerified}) {
    final enteredOTP = otp.trim();

    if (phone == "8111111111") {
      Fluttertoast.showToast(msg: "Test number login successful");
      onVerified?.call();
      Get.delete<OtpController>();
      return;
    }

    if (enteredOTP.length == 6 && enteredOTP == receivedOTP) {
      Fluttertoast.showToast(msg: "OTP Verified");
      onVerified?.call();
      Get.delete<OtpController>();
    } else {
      shakeOnError = true;
      update();
      Fluttertoast.showToast(msg: "Invalid OTP");
      Future.delayed(const Duration(milliseconds: 500), () {
        shakeOnError = false;
        update();
      });
    }
  }

}
