
import 'dart:developer';

import 'package:flutter/material.dart';
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

class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
  String fullNumber = "";
  late String phone;
  final TextEditingController otpTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phone = Get.find<AuthController>().phoneController.text;

    WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.find<OtpController>().startTimer();
      final String fullPhone = Get.find<AuthController>().phoneController.text;
      phone = fullPhone.replaceAll("+91 ", "");

      setState(() {
        fullNumber = 'Via SMS (+91 $fullPhone)';
      });

      if (phone == "8111111111") {
        otpTextController.text = "123456";
      }

      SmsAutoFill().listenForCode();
    });
  }

  @override
  void dispose() {
    otpTextController.clear();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: appTheme.scaffoldBackgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "STREAMMLY",
                        style: GoogleFonts.cinzelDecorative(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Image.asset("assets/images/loginpage.gif", height: 300),
                      ),
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
                                  style: appTheme.textTheme.bodySmall?.copyWith(
                                    fontSize: 14,
                                    color: theme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fullNumber,
                                  style: appTheme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                /// OTP Field
                                ShakeWidget(
                                  shake: otpController.shakeOnError,
                                  child: PinCodeTextField(
                                    appContext: context,
                                    controller: otpTextController,
                                    length: 6,
                                    keyboardType: TextInputType.number,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 55,
                                      fieldWidth: 45,
                                      inactiveColor: appTheme.dividerColor,       
                                      selectedColor: theme.secondaryColor,
                                      activeColor: theme.primaryColor,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                ),
                                const SizedBox(height: 10),

                                /// Timer & Resend
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.watch_later_outlined, size: 16, color: appTheme.dividerColor),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Resend code in 00:${otpController.secondsRemaining.toString().padLeft(2, '0')}",
                                      style: appTheme.textTheme.bodySmall?.copyWith(
                                        fontSize: 13,
                                        color: theme.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: otpController.secondsRemaining == 0
                                          ? () {
                                            Get.find<AuthController>().sendOtp();
                                            otpController.startTimer();
                                          }
                                          : null,
                                      child: Text(
                                        "Resend OTP",
                                        style: appTheme.textTheme.bodySmall?.copyWith(
                                          color: otpController.secondsRemaining == 0
                                              ? theme.primaryColor
                                              : theme.textSecondary,
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                    ),
                                    onPressed: () {
                                      Get.find<OtpController>()
                                          .verifyOtp(phone: phone, otp: otpTextController.text)
                                          .then((value) {
                                        if (value.isSuccess) {
                                          
                                          final loginArgs = Get.arguments;
                                          final redirectTo = loginArgs?['redirectTo'];
                                          final formData = loginArgs?['formData'];
                                          log(redirectTo, name: "fjfufu" );
                                          Get.off(() => const WelcomeScreen(), arguments: {
                                            'redirectTo': redirectTo,
                                            'formData': formData,
                                          });
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Confirm OTP",
                                      style: appTheme.textTheme.bodyLarge?.copyWith(
                                        fontSize: 19,
                                        color: Colors.white,
                                      ),
                                    ),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 321,
                          height: 24,
                          alignment: Alignment.center,
                          child: Text.rich(
                            TextSpan(
                              text: "By providing my phone number, I hereby agree and accept the ",
                              style: GoogleFonts.publicSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                              children: [
                                TextSpan(
                                  text: "Terms & Condition",
                                  style: GoogleFonts.publicSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                const TextSpan(text: " & "),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: GoogleFonts.publicSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                const TextSpan(text: " in use of this app."),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
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
  
  @override
  void codeUpdated() {
    otpTextController.text = code??"";
  }
}
