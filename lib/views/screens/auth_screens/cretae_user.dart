import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/auth_screens/welcome.dart';

import '../../../controllers/auth_controller.dart';
import '../../../data/repository/auth_repo.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? selectedGender;
  bool isLoading = false;

  void saveProfile() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String dob = dobController.text.trim();

    if (name.isEmpty || email.isEmpty || selectedGender == null) {
      Fluttertoast.showToast(msg: "Please fill all required fields");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await Get.find<AuthRepo>().saveUserProfile(name: name, email: email, dob: dob.isEmpty ? null : dob, gender: selectedGender);

      if (response.statusCode == 200) {
        await Get.find<AuthController>().fetchUserProfile();
        Fluttertoast.showToast(msg: "Profile saved successfully");
        Get.offAll(() => const WelcomeScreen());
      } else {
        Fluttertoast.showToast(msg: "Failed to save profile");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving profile");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name *")),
              const SizedBox(height: 12),
              TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: "Email *")),
              const SizedBox(height: 12),
              TextField(controller: dobController, keyboardType: TextInputType.datetime, decoration: const InputDecoration(labelText: "Date of Birth (Optional, YYYY-MM-DD)")),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedGender,
                hint: const Text("Select Gender *"),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                  DropdownMenuItem(value: "other", child: Text("Other")),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: isLoading ? null : saveProfile, child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Save Profile")),
            ],
          ),
        ),
      ),
    );
  }
}
