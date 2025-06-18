import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';

import '../../../generated/animation/shake_widget.dart';
import '../../../services/theme.dart' as theme;

class OtpScreen extends StatelessWidget {
  final OtpController controller = Get.find();

  OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String fullPhone = Get.arguments ?? "+91 0000000000";
    final String phone = fullPhone.replaceAll("+91 ", "");
    final String fullNumber = 'Via SMS $fullPhone';

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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
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
                                Obx(
                                  () => ShakeWidget(
                                    shake: controller.shakeOnError.value,
                                    child: PinCodeTextField(
                                      appContext: context,
                                      controller: controller.otpController,
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
                                ),
                                const SizedBox(height: 10),

                                /// Resend or Timer
                                Obx(() {
                                  return controller.secondsRemaining.value > 0
                                      ? Text("Resend OTP in 00:${controller.secondsRemaining.value.toString().padLeft(2, '0')}")
                                      : TextButton(onPressed: () => controller.resendOTP(phone), child: const Text("Resend OTP"));
                                }),
                                const SizedBox(height: 30),

                                /// Confirm OTP Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                                    onPressed: () {
                                      controller.confirmOTP(
                                        phone,
                                        onVerified: () {
                                          Get.offAll(() => const WelcomeScreen());
                                        },
                                      );
                                    },
                                    child: const Text("Confirm OTP", style: TextStyle(fontSize: 19, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
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
