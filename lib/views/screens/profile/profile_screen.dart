import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/models/profile/user_profile_model.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/common/widgets/add_new_address.dart';
import '../common/widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  final AuthController authController = Get.find<AuthController>();
  final LocationController controller = Get.put(LocationController());

  // Variables to hold selected images
  File? _profileImage; // For profile picture
  File? _coverImage; // For banner image

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final value = await authController.fetchUserProfile();
      if (value?.isSuccess ?? false) {
        final profile = authController.userProfile;
        setState(() {
          _usernameController.text = profile?.name ?? "";
          _mobileController.text = profile?.phone ?? "";
          _emailController.text = profile?.email ?? "";
          _dobController.text = DateFormat(
            'yyyy-MM-dd',
          ).format(profile?.dob ?? DateTime.now());
          _selectedGender = profile?.gender ?? "";
        });
      }
    });
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _coverImage != null
                    ? Image.file(
                      _coverImage!,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : Image.asset(
                      _coverImage?.path ?? Assets.imagesDemoprofile,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                Positioned(
                  bottom: -50,
                  left: 16,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : (authController.userProfile?.profileImage !=
                                          null &&
                                      authController
                                          .userProfile!
                                          .profileImage!
                                          .isNotEmpty)
                                  ? NetworkImage(
                                    authController.userProfile!.profileImage!,
                                  )
                                  : const AssetImage(Assets.imagesEllipse)
                                      as ImageProvider,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        child: GestureDetector(
                          onTap:
                              () => _showImageSourceDialog(
                                true,
                              ), // Update profile image
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundImage: AssetImage(Assets.imagesEdit),
                            ),
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
                    onTap:
                        () => _showImageSourceDialog(
                          false,
                        ), // Update banner image
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Update cover image',
                            style: TextStyle(color: Color(0xFF2864A6)),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              Assets.imagesEdit,
                              width: 20,
                              height: 20,
                            ),
                          ),
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
                      Text(
                        'Linked Accounts',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            Assets.svgGoogle,
                            width: 40,
                            height: 40,
                          ),
                          SvgPicture.asset(
                            Assets.svgInstagram,
                            width: 40,
                            height: 40,
                          ),
                          SvgPicture.asset(
                            Assets.svgFacebook,
                            width: 40,
                            height: 40,
                          ),
                          SvgPicture.asset(
                            Assets.svgGmail,
                            width: 40,
                            height: 40,
                          ),
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
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Info",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "You can change your personal settings here.",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),

                      /// Username
                      CustomTextField(
                        controller: _usernameController,
                        labelText: 'Username',
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
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text('🇮🇳'),
                                SizedBox(width: 4),
                                Text('(+91)'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomTextField(
                              controller: _mobileController,
                              keyboardType: TextInputType.phone,
                              readOnly: true,
                              labelText: 'Enter Mobile no.',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Mobile number is required';
                                } else if (!RegExp(
                                  r'^[0-9]{10}$',
                                ).hasMatch(value)) {
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
                        readOnly: true,
                        labelText: 'Enter Email',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          } else if (!RegExp(
                            r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      /// Date of Birth
                      CustomTextField(
                        controller: _dobController,
                        labelText: 'Enter Date of Birth',
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            _dobController.text =
                                "${date.day}/${date.month}/${date.year}";
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
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFABB0B5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items:
                            ['male', 'female', 'other']
                                .map(
                                  (gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ),
                                )
                                .toList(),
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
                      const SizedBox(height: 20),
                      Text(
                        "Address Information",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GetBuilder<AuthController>(
                        builder: (authController) {
                          if (authController.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (authController.address.isEmpty) {
                            return const Center(
                              child: Text('No addresses available'),
                            );
                          }
                          return Column(
                            children:
                                authController.address.map((address) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AddressCard(
                                      address: address,
                                      onEdit: () {
                                        Navigator.push(
                                          context,
                                          getCustomRoute(
                                            child: AddressPage(
                                              address: address,
                                            ),
                                          ),
                                        ).then((result) {
                                          if (result != null) {
                                            authController.fetchUserProfile();
                                          }
                                        });
                                      },
                                      onDelete: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  'Confirm Delete',
                                                ),
                                                content: const Text(
                                                  'Are you sure you want to delete this address?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          false,
                                                        ),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                          true,
                                                        ),
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                        );
                                        if (confirm == true) {
                                          final response = await authController
                                              .deleteUserAddress(
                                                address.id.toString(),
                                              );
                                          if (response.isSuccess) {
                                            Get.snackbar(
                                              'Success',
                                              'Address deleted successfully',
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            Get.snackbar(
                                              'Error',
                                              response.message,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            getCustomRoute(child: const AddressPage()),
                          ).then((result) {
                            if (result != null) {
                              authController.fetchUserProfile();
                            }
                          });
                        },
                        child: Container(
                          height: 51,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              'Add New Address',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              authController
                                  .updateFullUserProfile(
                                    name: _usernameController.text,
                                    email: _emailController.text,
                                    phone: _mobileController.text,
                                    dob: _dobController.text,
                                    gender: _selectedGender,
                                    profileImage: _profileImage,
                                    coverImage: _coverImage,
                                    alternatePhone: '',
                                  )
                                  .then((value) {
                                    if (value?.isSuccess ?? false) {
                                      Get.back();
                                      Get.snackbar(
                                        "Success",
                                        "Profile updated successfully",
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        value?.message ??
                                            "Failed to update profile",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  });
                            }
                          },
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(color: Colors.white),
                          ),
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

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AddressCard({
    super.key,

    required this.onEdit,
    required this.onDelete,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 35,
                height: 35,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.title ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (address.isDefault == 1) ...[
                          const SizedBox(width: 10),
                          Container(
                            width: 57,
                            height: 22,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Primary',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      [
                        address.addressOne,
                        address.addressTwo,
                        address.city,
                        address.state,
                        address.pincode,
                      ].where((e) => (e?.isNotEmpty ?? false)).join(', '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// enum AddressPageMode { add, edit }

// class AddressModel {
//   final String title;
//   final String line1;
//   final String line2;
//   final String city;
//   final String state;
//   final String pincode;
//   final bool isPrimary;
//   final String id;
//   final String latitude;
//   final String longitude;

//   AddressModel({
//     required this.title,
//     required this.line1,
//     required this.line2,
//     required this.city,
//     required this.state,
//     required this.pincode,
//     required this.isPrimary,
//     required this.id,
//     required this.latitude,
//     required this.longitude,
//   });
// }
