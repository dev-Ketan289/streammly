import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/quote_repo.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/quote_controller.dart';
import '../../../services/custom_error_pop_widget.dart';
import '../auth_screens/login_screen.dart';
import '../package/booking/widgets/custom_time_picker.dart';

class GetQuoteScreen extends StatefulWidget {
  final int? companyId;
  final int? subCategoryId;
  final int? subVerticalId;
  final String? subCategoryTitle;
  final String? subVerticalTitle;
  const GetQuoteScreen({
    super.key,
    this.companyId,
    this.subCategoryId,
    this.subVerticalId,
    this.subCategoryTitle,
    this.subVerticalTitle,
  });

  @override
  State<GetQuoteScreen> createState() => _GetQuoteScreenState();
}

class _GetQuoteScreenState extends State<GetQuoteScreen> {
  final QuoteController quoteController = Get.put(
    QuoteController(
      quoteRepo: QuoteRepo(
        apiClient: ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: Get.find(),
        ),
      ),
    ),
  );
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      quoteController.companyId = widget.companyId.toString();
      quoteController.subCategoryId = widget.subCategoryId.toString();
      quoteController.subVerticalId = widget.subVerticalId.toString();
      quoteController.subCategoryTitle = widget.subCategoryTitle.toString();
      quoteController.subVerticalTitle = widget.subVerticalTitle.toString();

      quoteController.update();
    });
    final nowFormatted = DateFormat('hh:mm a').format(DateTime.now());
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: quoteController.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      quoteController.selectedDate = picked;
      quoteController.dateController.text = _formatDate(picked);
      quoteController.update();
    }
  }

  void _onTimeSelected(String value) {
    if (quoteController.startTime != null) {
      quoteController.startTime = value;
    } else {
      quoteController.endTime = value;
    }
    quoteController.showTimePicker = false;
    quoteController.update();
  }

  void _onFavTimeSelected(String value) {
    if (quoteController.isFavTime) {
      quoteController.favStartTime = value;
    } else {
      quoteController.favEndTime = value;
    }
    quoteController.showFavTimePicker = false;
    quoteController.update();
  }

  void _submitQuote() async {
    if (quoteController.nameController.text.isEmpty ||
        quoteController.mobileController.text.isEmpty ||
        quoteController.emailController.text.isEmpty ||
        quoteController.requirementsController.text.isEmpty) {
      Get.snackbar("Validation", "Please fill all required fields");
      return;
    }

    if (!authController.isLoggedIn()) {
      await CommonPopupDialog.show(
        context,
        imagePath: 'assets/images/access_denied.png',
        title: 'Login Required',
        message: 'You need to login to submit this quote.',
        primaryBtnText: 'Cancel',
        onPrimaryPressed: () {},
        secondaryBtnText: 'Login',
        onSecondaryPressed: () {
          Navigator.of(context).pop(); // Close dialog first
          Get.off(
            () => const LoginScreen(),
            arguments: {
              'redirectTo': '/getQuote',
              'formData': {
                'companyId': quoteController.companyId,
                'subCategoryId': quoteController.subCategoryId,
                'subVerticalId': quoteController.subVerticalId,
                'subCategoryTitle': quoteController.subCategoryTitle,
                'subVerticalTitle': quoteController.subVerticalTitle,
                'name': quoteController.nameController.text,
                'mobile': quoteController.mobileController.text,
                'email': quoteController.emailController.text,
                'requirements': quoteController.requirementsController.text,
                'date': quoteController.dateController.text,
                'startTime': quoteController.startTime,
                'endTime': quoteController.endTime,
                'favStartTime': quoteController.favStartTime,
                'favEndTime': quoteController.favEndTime,
              },
            },
          );
        },
      );
      return;
    }

    // If logged in, proceed to submit
    quoteController.submitQuote(
      companyId:
          (quoteController.companyId is int)
              ? quoteController.companyId as int
              : 0,
      subCategoryId:
          (quoteController.subCategoryId is int)
              ? quoteController.subCategoryId as int
              : 0,
      subVerticalId:
          (quoteController.subVerticalId is int)
              ? quoteController.subVerticalId as int
              : 0,
      userName: quoteController.nameController.text,
      phone: quoteController.mobileController.text,
      email: quoteController.emailController.text,
      dateOfShoot: quoteController.dateController.text,
      startTime: quoteController.startTime!,
      endTime: quoteController.endTime!,
      favorableDate: quoteController.dateController.text,
      favorableStartTime: quoteController.favStartTime!,
      favorableEndTime: quoteController.favEndTime!,
      requirement: quoteController.requirementsController.text,
      shootType:
          "${quoteController.subCategoryTitle} / ${quoteController.subVerticalTitle}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Get Quote',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF2864A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<QuoteController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${controller.subCategoryTitle} / ${controller.subVerticalTitle}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF2864A6),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: controller.nameController,
                    decoration: _buildDecoration('Name *', 'Enter name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.mobileController,
                    decoration: _buildDecoration(
                      'Mobile No. *',
                      'Enter mobile number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.emailController,
                    decoration: _buildDecoration('Email *', 'Enter email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Date of Shoot *',
                    controller.dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    suffixIcon: Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'Start Time *',
                          TextEditingController(text: controller.startTime),
                          readOnly: true,
                          onTap: () {
                            controller.isStartTime = true;
                            controller.showTimePicker = true;
                            controller.update();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'End Time *',
                          TextEditingController(text: controller.endTime),
                          readOnly: true,
                          onTap: () {
                            controller.isStartTime = false;
                            controller.showTimePicker = true;
                            controller.update();
                          },
                        ),
                      ),
                    ],
                  ),
                  if (controller.showTimePicker)
                    CustomTimePicker(
                      isStart: controller.isStartTime,
                      onCancel:
                          () =>
                              setState(() => controller.showTimePicker = false),
                      onTimeSelected: _onTimeSelected,
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.requirementsController,
                    decoration: _buildDecoration(
                      'Describe your Requirements *',
                      'Enter requirements',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'Fav Time *',
                          TextEditingController(text: controller.favStartTime),
                          readOnly: true,
                          onTap: () {
                            controller.isFavTime = true;
                            controller.showFavTimePicker = true;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'Fav Time *',
                          TextEditingController(text: controller.favEndTime),
                          readOnly: true,
                          onTap: () {
                            controller.isFavTime = false;
                            controller.showFavTimePicker = true;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  if (controller.showFavTimePicker)
                    CustomTimePicker(
                      isStart: controller.isFavTime,
                      onCancel:
                          () => setState(
                            () => controller.showFavTimePicker = false,
                          ),
                      onTimeSelected: _onFavTimeSelected,
                    ),
                  const SizedBox(height: 16),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Note: ',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Vendor team will contact you within the favorable Date & Favorable time only',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isSubmitting ? null : _submitQuote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E5CDA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          controller.isSubmitting
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }

  InputDecoration _buildDecoration(String label, String hint) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE6DFDF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE6DFDF)),
      ),
      fillColor: Colors.white,
      filled: true,
      labelText: label,
      labelStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 15),
      hintText: hint,
      hintStyle: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE6DFDF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE6DFDF)),
          ),
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          labelStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 15),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
