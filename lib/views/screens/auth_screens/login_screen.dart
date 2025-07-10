import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/views/screens/auth_screens/otp_verification_screen.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';

import '../../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void dispose() {
    super.dispose();
    Get.find<AuthController>().phoneController.clear();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: GetBuilder<AuthController>(
                    builder: (authController) {
                      return Column(
                        children: [
                          const SizedBox(height: 40),
                          Center(child: Text("STREAMMLY", style: GoogleFonts.cinzelDecorative(fontSize: 28, fontWeight: FontWeight.bold, color: theme.primaryColor))),
                          const SizedBox(height: 40),
                          Image.asset('assets/images/loginpage.gif', height: 280),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Mobile Number", style: theme.textTheme.bodyMedium),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: authController.phoneController,
                                  keyboardType: TextInputType.phone,
                                  style: theme.textTheme.bodyMedium,
                                  maxLength: 10,
                                  decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [Text("🇮🇳 +91", style: TextStyle(fontSize: 16)), SizedBox(width: 8), VerticalDivider(thickness: 1)],
                                      ),
                                    ),
                                    hintText: "Enter phone number",
                                    hintStyle: theme.textTheme.bodySmall,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    counterText: '',
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 10) {
                                      FocusScope.of(context).unfocus();
                                    }
                                  },
                                ),
                                const SizedBox(height: 8),
                                Center(child: Text("OTP will be sent to the entered phone number", style: theme.textTheme.bodySmall)),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed:
                                        authController.isLoading
                                            ? null
                                            : () {
                                              authController.sendOtp().then((value) {
                                                if (value.isSuccess) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
                                                }
                                              });
                                            },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.primaryColor,
                                      side: BorderSide(color: theme.primaryColor),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text("Generate OTP", style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text("Or", style: theme.textTheme.bodyMedium)),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed:(){
                                      Get.to(() => WelcomeScreen());
                                    },
                                        // authController.isLoading
                                        //     ? null
                                        //     : () async {
                                        //       final result = await authController.signInWithGoogle();
                                        //
                                        //       if (result?.isSuccess ?? false) {
                                        //         Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
                                        //       }
                                        //     },
                                    icon: Image.asset('assets/images/img.png', height: 24),
                                    label: Text("Continue with Google", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor)),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: theme.primaryColor),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: 321,
                              height: 24,
                              alignment: Alignment.center,
                              child: Text.rich(
                                TextSpan(
                                  text: "By providing my phone number, I hereby agree and accept the ",
                                  style: GoogleFonts.publicSans(fontSize: 10, fontWeight: FontWeight.w300),
                                  children: [
                                    TextSpan(text: "Terms & Condition", style: GoogleFonts.publicSans(fontSize: 10, fontWeight: FontWeight.w300, color: theme.primaryColor)),
                                    const TextSpan(text: " & "),
                                    TextSpan(text: "Privacy Policy", style: GoogleFonts.publicSans(fontSize: 10, fontWeight: FontWeight.w300, color: theme.primaryColor)),
                                    const TextSpan(text: " in use of this app."),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
