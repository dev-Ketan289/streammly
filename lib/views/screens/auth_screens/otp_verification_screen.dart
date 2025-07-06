import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/otp_controller.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';

import '../../../generated/animation/shake_widget.dart';
import '../../../services/theme.dart' as theme;

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String fullNumber = "";
  late String phone;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String fullPhone = Get.find<AuthController>().phoneController.text;
      phone = fullPhone.replaceAll("+91 ", "");
      fullNumber = 'Via SMS $fullPhone';

      /// ✅ Auto-fill test number OTP
      if (phone == "8111111111") {
        Get.find<OtpController>().otpController.text = "123456";
      }

      /// ✅ Start listening for SMS autofill
      SmsAutoFill().listenForCode();
    });
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        body: SafeArea(
          child: LayoutBuilder(
            builder:
                (context, constraints) => SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Text("STREAMMLY", style: GoogleFonts.cinzelDecorative(fontSize: 28, fontWeight: FontWeight.bold, color: theme.primaryColor)),
                          const SizedBox(height: 20),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 40.0), child: Image.asset("assets/images/loginpage.gif", height: 300)),
                          const SizedBox(height: 20),

                          /// OTP Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: GetBuilder<OtpController>(
                              builder: (otpController) {
                                return Column(
                                  children: [
                                    Text(
                                      "Please enter the code we just sent to your phone number",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(fullNumber, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 24),

                                    /// OTP Field
                                    ShakeWidget(
                                      shake: otpController.shakeOnError.value,
                                      child: PinCodeTextField(
                                        appContext: context,
                                        controller: otpController.otpController,
                                        length: 6,
                                        keyboardType: TextInputType.number,
                                        pinTheme: PinTheme(
                                          shape: PinCodeFieldShape.box,
                                          borderRadius: BorderRadius.circular(10),
                                          fieldHeight: 55,
                                          fieldWidth: 45,
                                          inactiveColor: Colors.grey.shade300,
                                          selectedColor: Colors.blue.shade300,
                                          activeColor: Colors.indigo,
                                        ),
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    /// Timer & Resend
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.watch_later_outlined, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Obx(() {
                                          return Text(
                                            "Resend code in 00:${otpController.secondsRemaining.value.toString().padLeft(2, '0')}",
                                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                                          );
                                        }),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: otpController.secondsRemaining.value == 0 ? () => otpController.resendOTP(phone) : null,
                                          child: Text(
                                            "Resend OTP",
                                            style: TextStyle(
                                              color: otpController.secondsRemaining.value == 0 ? Colors.indigo : Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 30),

                                    /// Confirm OTP Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                                        onPressed:
                                            otpController.isLoading
                                                ? null
                                                : () {
                                                  otpController.verifyOtp().then((value) async {
                                                    if (value.isSuccess) {
                                                      /// Check if user is new or old
                                                      await Get.find<AuthController>().fetchUserProfile();

                                                      if (Get.find<AuthController>().userProfile.value == null ||
                                                          Get.find<AuthController>().userProfile.value!.name == null ||
                                                          Get.find<AuthController>().userProfile.value!.email == null) {
                                                        /// New User → Show Profile Form
                                                        Get.offAll(() => const WelcomeScreen());
                                                      } else {
                                                        /// Old User → Go to Welcome Screen
                                                        Get.offAll(() => const WelcomeScreen());
                                                      }
                                                    } else {
                                                      Fluttertoast.showToast(msg: value.message);
                                                    }
                                                  });
                                                },
                                        child: const Text("Confirm OTP", style: TextStyle(fontSize: 19, color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const Spacer(),

                          /// Footer
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                            child: Text.rich(
                              TextSpan(
                                text: "By providing my phone number, I hereby agree and accept the ",
                                children: [
                                  TextSpan(text: "Terms & Condition", style: TextStyle(color: Colors.indigo, decoration: TextDecoration.underline)),
                                  const TextSpan(text: " & "),
                                  TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.indigo, decoration: TextDecoration.underline)),
                                  const TextSpan(text: " in use of this app."),
                                ],
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
