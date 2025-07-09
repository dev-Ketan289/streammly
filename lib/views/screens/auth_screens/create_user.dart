import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/common/location_screen.dart';

import '../../../controllers/auth_controller.dart';

class ProfileFormScreen extends StatefulWidget {
  ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedGender;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.text = Get.find<AuthController>().phoneController.text;
    emailController.text = Get.find<AuthController>().emailController.text;
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

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Get.find<AuthController>().updateUserProfile(
        name: name,
        email: email,
        dob: dob.isEmpty ? null : dob,
        gender: selectedGender,
        phone: phone,
      );
      log("${response?.message}", name: "saveProfile");

      if (response?.isSuccess ?? false) {
        await Get.find<AuthController>().fetchUserProfile();
        Fluttertoast.showToast(msg: response?.message ?? "");
        Get.offAll(() => const LocationScreen());
      } else {
        Fluttertoast.showToast(msg: response?.message ?? "");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating profile");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          title: const Text("Complete Your Profile"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Center(
                    //   child: Stack(
                    //     children: [
                    //       CircleAvatar(
                    //         radius: 40,
                    //         backgroundColor: Colors.grey[300],
                    //         child: const Icon(
                    //           Icons.person,
                    //           size: 50,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //       // Optionally add an edit icon overlay here
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name *",
                        prefixIcon: const Icon(Icons.person_outline),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email *",
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone *",
                        prefixIcon: const Icon(Icons.phone_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dobController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: "Date of Birth (Optional, YYYY-MM-DD)",
                            prefixIcon: const Icon(Icons.cake_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      hint: const Text("Select Gender *"),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.wc_outlined),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "male", child: Text("Male")),
                        DropdownMenuItem(
                          value: "female",
                          child: Text("Female"),
                        ),
                        DropdownMenuItem(value: "other", child: Text("Other")),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: isLoading ? null : saveProfile,
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Text(
                                  "Save Profile",
                                  style: TextStyle(color: Colors.white),
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
    );
  }
}
