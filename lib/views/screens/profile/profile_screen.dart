import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/views/screens/profile/components/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(text: "UMA RAJPUT");
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;

  // Variables to hold selected images
  File? _profileImage; // For profile picture
  File? _coverImage; // For banner image

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _usernameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Function to pick image
  Future<void> _pickImage(ImageSource source, bool isProfile) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(pickedFile.path);
        } else {
          _coverImage = File(pickedFile.path);
        }
      });
    }
  }

  // Show image source options
  void _showImageSourceDialog(bool isProfile) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Image Source'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera, isProfile);
                },
                child: const Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery, isProfile);
                },
                child: const Text('Gallery'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Get.back()),
        title: const Text('Your Profile', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _coverImage != null
                    ? Image.file(_coverImage!, height: 260, width: double.infinity, fit: BoxFit.cover)
                    : Image.asset(_coverImage?.path ?? Assets.imagesDemoprofile, height: 260, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  bottom: -50,
                  left: 16,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null ? FileImage(_profileImage!) : const AssetImage(Assets.imagesEllipse) as ImageProvider,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: GestureDetector(
                          onTap: () => _showImageSourceDialog(true), // Update profile image
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                            child: CircleAvatar(radius: 12, backgroundImage: AssetImage(Assets.imagesEdit)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: -20,
                  child: GestureDetector(
                    onTap: () => _showImageSourceDialog(false), // Update banner image
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(100)),
                      child: Row(
                        children: [
                          Text('Update cover image', style: TextStyle(color: Color(0xFF2864A6))),
                          const SizedBox(width: 4),
                          Image.asset(Assets.imagesEdit, width: 20, height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: -100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Linked Accounts', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      // Use flutter_svg to display SVG assets
                      // Make sure to import: import 'package:flutter_svg/flutter_svg.dart';
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(Assets.svgGoogle, width: 40, height: 40),
                          // SizedBox(width: 10),
                          SvgPicture.asset(Assets.svgInstagram, width: 40, height: 40),
                          // SizedBox(width: 10),
                          SvgPicture.asset(Assets.svgFacebook, width: 40, height: 40),
                          // SizedBox(width: 10),
                          SvgPicture.asset(Assets.svgGmail, width: 40, height: 40),
                          // SizedBox(width: 10),
                          Icon(Icons.add, size: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(20)),
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Personal Info", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text("You can change your personal settings here.", style: TextStyle(color: Colors.black)),
                      const SizedBox(height: 16),

                      /// Username
                      CustomTextField(
                        controller: _usernameController,
                        label: 'Username',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      /// Mobile with country code
                      Row(
                        children: [
                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
                            child: const Row(children: [Text('🇮🇳'), SizedBox(width: 4), Text('(+91)')]),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              label: 'Enter Mobile no.',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Mobile number is required';
                                } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                  return 'Enter a valid 10-digit mobile number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      /// Email
                      CustomTextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Enter Email',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      /// Date of Birth
                      CustomTextField(
                        controller: _dobController,
                        label: 'Enter Date of Birth',
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
                          if (date != null) {
                            _dobController.text = "${date.day}/${date.month}/${date.year}";
                          }
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Date of birth is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      /// Gender
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          hintText: 'Enter Gender',
                          border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFABB0B5)), borderRadius: BorderRadius.circular(10)),
                        ),
                        items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(value: gender, child: Text(gender))).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Gender is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      /// Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // All fields are valid — perform submission
                              Get.snackbar("Success", "Profile updated successfully", backgroundColor: Colors.green.shade100, colorText: Colors.black);
                            }
                          },
                          child: const Text('Update Profile', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {},
                          child: const Text('Saved Address', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
