import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/auth_controller.dart';
import '../../../controllers/quote_controller.dart';
import '../auth_screens/login_screen.dart';
import '../package/booking/widgets/time_picker.dart';

class GetQuoteScreen extends StatefulWidget {
  const GetQuoteScreen({super.key});

  @override
  State<GetQuoteScreen> createState() => _GetQuoteScreenState();
}

class _GetQuoteScreenState extends State<GetQuoteScreen> {
  final QuoteController quoteController = Get.put(QuoteController());
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late int companyId;
  late int subCategoryId;
  late int subVerticalId;
  late String subCategoryTitle;
  late String subVerticalTitle;

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

    companyId = args['companyId'] ?? 0;
    subCategoryId = args['subCategoryId'] ?? 0;
    subVerticalId = args['subVerticalId'] ?? 0;
    subCategoryTitle = args['subCategoryTitle'] ?? '';
    subVerticalTitle = args['subVerticalTitle'] ?? '';

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
    final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100));
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
    if (nameController.text.isEmpty || mobileController.text.isEmpty || emailController.text.isEmpty || requirementsController.text.isEmpty) {
      Get.snackbar("Validation", "Please fill all required fields");
      return;
    }

    if (!authController.isLoggedIn()) {
      final shouldLogin = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Login Required"),
          content: const Text("You are not logged in. Do you want to login to submit this quote?"),
          actions: [
            TextButton(onPressed: () => Get.back(result: false), child: const Text("Continue as Guest")),
            ElevatedButton(onPressed: () => Get.back(result: true), child: const Text("Login")),
          ],
        ),
      );

      if (shouldLogin == true) {
        Get.to(
          () => const LoginScreen(),
          arguments: {
            'redirectTo': 'GetQuoteScreen',
            'formData': {
              'companyId': companyId,
              'subCategoryId': subCategoryId,
              'subVerticalId': subVerticalId,
              'subCategoryTitle': subCategoryTitle,
              'subVerticalTitle': subVerticalTitle,
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
      companyId: companyId,
      subCategoryId: subCategoryId,
      subVerticalId: subVerticalId,
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
      shootType: "$subCategoryTitle / $subVerticalTitle",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Get Quote', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF2864A6), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$subCategoryTitle / $subVerticalTitle", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2864A6))),
            const SizedBox(height: 5),
            TextField(controller: nameController, decoration: _buildDecoration('Name *', 'Enter name')),
            const SizedBox(height: 16),
            TextField(controller: mobileController, decoration: _buildDecoration('Mobile No. *', 'Enter mobile number'), keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            TextField(controller: emailController, decoration: _buildDecoration('Email *', 'Enter email'), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildTextField('Date of Shoot *', dateController, readOnly: true, onTap: _pickDate, suffixIcon: Icons.calendar_today),
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
            if (showTimePicker) CustomTimePicker(isStart: isStartTime, onCancel: () => setState(() => showTimePicker = false), onTimeSelected: _onTimeSelected),
            const SizedBox(height: 16),
            TextField(controller: requirementsController, decoration: _buildDecoration('Describe your Requirements *', 'Enter requirements'), maxLines: 3),
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
            if (showFavTimePicker) CustomTimePicker(isStart: isFavTime, onCancel: () => setState(() => showFavTimePicker = false), onTimeSelected: _onFavTimeSelected),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Note: ', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w500)),
                  TextSpan(
                    text: 'Vendor team will contact you within the favorable Date & Favorable time only',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: quoteController.isSubmitting.value ? null : _submitQuote,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E5CDA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child:
                      quoteController.isSubmitting.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildDecoration(String label, String hint) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
      fillColor: Colors.white,
      filled: true,
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap, IconData? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
          fillColor: Colors.white,
          filled: true,
          labelText: label,
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
