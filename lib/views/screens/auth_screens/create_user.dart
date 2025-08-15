import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/auth_controller.dart';
import '../../../navigation_flow.dart';
import '../../../services/theme.dart' as theme;
import '../../screens/common/location_screen.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();

  String? selectedGender;
  bool isLoading = false;
  late final AuthController authController;

  String formatDateForDisplay(dynamic dateValue) {
    if (dateValue == null) return '';

    if (dateValue is DateTime) {
      return "${dateValue.year.toString().padLeft(4, '0')}-${dateValue.month.toString().padLeft(2, '0')}-${dateValue.day.toString().padLeft(2, '0')}";
    } else if (dateValue is String && dateValue.isNotEmpty && dateValue != 'null') {
      return dateValue;
    }

    return '';
  }

  @override
  void initState() {
    super.initState();
    authController = Get.find<AuthController>();
    if (authController.userProfile != null) {
      nameController.text = authController.userProfile?.name ?? '';
      emailController.text = authController.userProfile?.email ?? '';
      phoneController.text = authController.userProfile?.phone ?? '';
      dobController.text = formatDateForDisplay(authController.userProfile?.dob);
      selectedGender = authController.userProfile?.gender;
    } else {
      phoneController.text = authController.phoneController.text;
      emailController.text = authController.emailController.text;
    }
  }


  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text =
      "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void saveProfile() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String dob = dobController.text.trim();
    String phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || selectedGender == null) {
      Fluttertoast.showToast(msg: "Please fill all required fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await authController.updateFullUserProfile(
        name: name,
        email: email,
        dob: dob.isEmpty ? null : dob,
        gender: selectedGender,
        phone: phone,
      );

      if (response?.isSuccess ?? false) {
        // Fetch latest profile & show toast
        await authController.fetchUserProfile();
        Fluttertoast.showToast(msg: response?.message ?? "Profile updated");

        // ✅ Navigate to next screen after success
        final args = Get.arguments ?? {};
        final redirectTo = args['redirectTo'];
        final packageData = args['packageData'];
        final formData = args['formData'];

        if (redirectTo == 'packages' && packageData != null) {
          // User came from package booking - return them there
          Get.offAll(() => NavigationFlow(initialIndex: 0));
          Future.delayed(const Duration(milliseconds: 300), () {
            final navigationState = NavigationFlow.navKey.currentState;
            if (navigationState != null) {
              navigationState.navigateToPackages(packageData);
            }
          });
        } else if (formData != null) {
          // User has other form data - go to quote
          Get.offNamed('/getQuote', arguments: formData);
        } else {
          // Default: go to location screen for normal onboarding
          Get.offAll(() => const LocationScreen());
        }
      } else {
        Fluttertoast.showToast(msg: response?.message ?? "Update failed");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating profile");
    }

    setState(() => isLoading = false);
  }

  InputDecoration fieldDecoration({
    String? hint,
    IconData? icon,
    bool isReadOnly = false
  }) {
    final themeData = Theme.of(context);
    return InputDecoration(
      hintText: hint,
      hintStyle: themeData.textTheme.bodyMedium?.copyWith(
        color: isReadOnly ? Colors.grey[400] : Colors.grey[500],
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      filled: true,
      fillColor: isReadOnly
          ? Colors.grey[100]
          : theme.backgroundLight.withValues(alpha: 0.97),
      suffixIcon: icon != null
          ? Icon(
          icon,
          color: isReadOnly ? Colors.grey[400] : Colors.grey[600],
          size: 19
      )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isReadOnly ? Colors.grey[300]! : Colors.grey[300]!
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isReadOnly ? Colors.grey[300]! : Colors.grey!
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isReadOnly ? Colors.grey[300]! : theme.primaryColor
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    IconData? suffixIcon,
    void Function()? onTap,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            color: readOnly ? Colors.grey[600] : Colors.black87,
          ),
          decoration: fieldDecoration(
              hint: hint,
              icon: suffixIcon,
              isReadOnly: readOnly
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  "STREAMMLY",
                  style: GoogleFonts.cinzelDecorative(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Image.asset(
                    'assets/images/GIF For Login 1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 7),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Complete your profile to get\nstarted with ",
                      style: GoogleFonts.poppins(
                        color: theme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.7,
                        height: 1.3,
                      ),
                      children: [
                        TextSpan(
                          text: "Streammly !",
                          style: GoogleFonts.poppins(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: Column(
                    children: [
                      buildTextField(
                        controller: nameController,
                        hint: "Enter Full Name",
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: phoneController,
                        hint: "Enter Mobile Number",
                        keyboardType: TextInputType.phone,
                        readOnly: authController.isPhoneLogin(),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: emailController,
                        hint: "Enter Email Id",
                        keyboardType: TextInputType.emailAddress,
                        readOnly: authController.isGoogleLogin(),
                      ),
                      const SizedBox(height: 10),
                      buildTextField(
                        controller: dobController,
                        hint: "Select DOB",
                        onTap: _pickDate,
                        suffixIcon: Icons.calendar_month,  // Remove the escape characters
                      ),

                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        onChanged: (value) {
                          setState(() => selectedGender = value);
                        },
                        items: const [
                          DropdownMenuItem(value: "male", child: Text("Male")),
                          DropdownMenuItem(
                            value: "female",
                            child: Text("Female"),
                          ),
                          DropdownMenuItem(
                            value: "other",
                            child: Text("Other"),
                          ),
                        ],
                        isExpanded: true,
                        decoration: InputDecoration(
                          hintText: "Select Your Gender",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[500],
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: theme.backgroundLight.withValues(alpha: 0.97),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: theme.primaryColor),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                        dropdownColor: theme.backgroundLight.withValues(alpha: 0.97),
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        menuMaxHeight: 200,
                      ),
                      const SizedBox(height: 27),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            "Save Profile",
                            style: themeData.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
