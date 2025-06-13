import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  child: Column(
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
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              style: theme.textTheme.bodyMedium,
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
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text("OTP will be sent to the entered phone number", style: theme.textTheme.bodySmall),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: controller.generateOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.primaryColor,
                                  side: BorderSide(color: theme.primaryColor),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text("Generate OTP", style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text("Or", style: theme.textTheme.bodySmall)),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: controller.signInWithGoogle,
                                icon: Image.asset('assets/images/img.png', height: 24),
                                label: Text("Continue with Google", style: theme.textTheme.bodySmall),
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
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
                        child: Text.rich(
                          TextSpan(
                            text: "By providing my phone number, I hereby agree and accept the ",
                            style: theme.textTheme.bodySmall?.copyWith(fontSize: 12),
                            children: [
                              TextSpan(text: "Terms & Condition", style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w500)),
                              const TextSpan(text: " & "),
                              TextSpan(text: "Privacy Policy", style: theme.textTheme.bodySmall?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.w500)),
                              const TextSpan(text: " in use of this app."),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
