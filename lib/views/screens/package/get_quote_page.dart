import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/quote_repo.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/quote_controller.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String? startTime;
  String? endTime;
  String? favStartTime;
  String? favEndTime;

  bool showTimePicker = false;
  bool showFavTimePicker = false;
  bool isStartTime = true;
  bool isFavTime = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};

    final nowFormatted = DateFormat('hh:mm a').format(DateTime.now());

    nameController.text = args['name'] ?? '';
    mobileController.text = args['mobile'] ?? '';
    emailController.text = args['email'] ?? '';
    requirementsController.text = args['requirements'] ?? '';
    dateController.text = args['date'] ?? _formatDate(selectedDate);

    startTime = args['startTime'] ?? nowFormatted;
    endTime = args['endTime'] ?? nowFormatted;
    favStartTime = args['favStartTime'] ?? nowFormatted;
    favEndTime = args['favEndTime'] ?? nowFormatted;
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = _formatDate(picked);
      });
    }
  }

  void _onTimeSelected(String value) {
    setState(() {
      if (isStartTime) {
        startTime = value;
      } else {
        endTime = value;
      }
      showTimePicker = false;
    });
  }

  void _onFavTimeSelected(String value) {
    setState(() {
      if (isFavTime) {
        favStartTime = value;
      } else {
        favEndTime = value;
      }
      showFavTimePicker = false;
    });
  }

  void _submitQuote() async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        emailController.text.isEmpty ||
        requirementsController.text.isEmpty) {
      Get.snackbar("Validation", "Please fill all required fields");
      return;
    }

    if (!authController.isLoggedIn()) {
      final shouldLogin = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Login Required"),
          content: const Text(
            "You are not logged in. Do you want to login to submit this quote?",
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Continue as Guest"),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Login"),
            ),
          ],
        ),
      );

      if (shouldLogin == true) {
        Get.to(
          () => const LoginScreen(),
          arguments: {
            'redirectTo': '/getQuote',
            'formData': {
              'companyId': widget.companyId,
              'subCategoryId': widget.subCategoryId,
              'subVerticalId': widget.subVerticalId,
              'subCategoryTitle': widget.subCategoryTitle,
              'subVerticalTitle': widget.subVerticalTitle,
              'name': nameController.text,
              'mobile': mobileController.text,
              'email': emailController.text,
              'requirements': requirementsController.text,
              'date': dateController.text,
              'startTime': startTime,
              'endTime': endTime,
              'favStartTime': favStartTime,
              'favEndTime': favEndTime,
            },
          },
        );
        return;
      }
    }

    quoteController.submitQuote(
      companyId: widget.companyId ?? 0,
      subCategoryId: widget.subCategoryId ?? 0,
      subVerticalId: widget.subVerticalId ?? 0,
      userName: nameController.text,
      phone: mobileController.text,
      email: emailController.text,
      dateOfShoot: dateController.text,
      startTime: startTime!,
      endTime: endTime!,
      favorableDate: dateController.text,
      favorableStartTime: favStartTime!,
      favorableEndTime: favEndTime!,
      requirement: requirementsController.text,
      shootType: "${widget.subCategoryTitle} / ${widget.subVerticalTitle}",
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
                    "${widget.subCategoryTitle} / ${widget.subVerticalTitle}",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: const Color(0xFF2864A6),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: nameController,
                    decoration: _buildDecoration('Name *', 'Enter name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: mobileController,
                    decoration: _buildDecoration(
                      'Mobile No. *',
                      'Enter mobile number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: _buildDecoration('Email *', 'Enter email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Date of Shoot *',
                    dateController,
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
                          TextEditingController(text: startTime),
                          readOnly: true,
                          onTap: () {
                            isStartTime = true;
                            showTimePicker = true;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'End Time *',
                          TextEditingController(text: endTime),
                          readOnly: true,
                          onTap: () {
                            isStartTime = false;
                            showTimePicker = true;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  if (showTimePicker)
                    CustomTimePicker(
                      isStart: isStartTime,
                      onCancel: () => setState(() => showTimePicker = false),
                      onTimeSelected: _onTimeSelected,
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: requirementsController,
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
                          TextEditingController(text: favStartTime),
                          readOnly: true,
                          onTap: () {
                            isFavTime = true;
                            showFavTimePicker = true;
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'Fav Time *',
                          TextEditingController(text: favEndTime),
                          readOnly: true,
                          onTap: () {
                            isFavTime = false;
                            showFavTimePicker = true;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                  if (showFavTimePicker)
                    CustomTimePicker(
                      isStart: isFavTime,
                      onCancel: () => setState(() => showFavTimePicker = false),
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
