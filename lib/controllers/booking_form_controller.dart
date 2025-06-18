import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingFormController extends GetxController {
  var currentPage = 0.obs;
  var selectedPackages = <Map<String, dynamic>>[].obs;

  final personalInfo = {'name': ''.obs, 'mobile': ''.obs, 'email': ''.obs};

  final alternateMobiles = <RxString>[].obs;
  final alternateEmails = <RxString>[].obs;

  final packageFormsData = <int, Map<String, dynamic>>{}.obs;

  // Add acceptance of terms
  var acceptTerms = false.obs;

  void initSelectedPackages(List<Map<String, dynamic>> packages) {
    selectedPackages.assignAll(packages);
    for (int i = 0; i < packages.length; i++) {
      packageFormsData[i] = {'date': '', 'startTime': '', 'endTime': '', 'babyInfo': null, 'theme': null, 'freeAddOn': null, 'extraAddOn': null};
    }
  }

  void updatePersonalInfo(String key, String value) {
    if (personalInfo.containsKey(key)) {
      personalInfo[key]?.value = value;
    }
  }

  void addAlternateMobile() => alternateMobiles.add(''.obs);
  void removeAlternateMobile(int index) {
    if (index < alternateMobiles.length) alternateMobiles.removeAt(index);
  }

  void addAlternateEmail() => alternateEmails.add(''.obs);
  void removeAlternateEmail(int index) {
    if (index < alternateEmails.length) alternateEmails.removeAt(index);
  }

  void updatePackageForm(int index, String field, dynamic value) {
    final data = packageFormsData[index] ?? {};
    data[field] = value;
    packageFormsData[index] = data;
  }

  void selectDate(int index, BuildContext context) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    if (picked != null) {
      final formatted = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      updatePackageForm(index, 'date', formatted);
    }
  }

  String _getMonthName(int month) {
    const months = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month];
  }

  void pickTime(int index, {required bool isStart, required BuildContext context}) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: const Color(0xFFF0F2FF),
              hourMinuteColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dialHandColor: const Color(0xFF4A6CF7),
              dialBackgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      updatePackageForm(index, isStart ? 'startTime' : 'endTime', formattedTime);
    }
  }

  void toggleAddOn(int index, String type) {
    final form = packageFormsData[index] ?? {};
    final key = type == 'free' ? 'freeAddOn' : 'extraAddOn';
    form[key] = form[key] == null ? 'Selected' : null;
    packageFormsData[index] = form;
  }

  void toggleTermsAcceptance() {
    acceptTerms.value = !acceptTerms.value;
  }

  bool canSubmit() {
    // Check if personal info is filled
    if (personalInfo['name']?.value.isEmpty ?? true) return false;
    if (personalInfo['mobile']?.value.isEmpty ?? true) return false;
    if (personalInfo['email']?.value.isEmpty ?? true) return false;

    // Check if terms are accepted
    if (!acceptTerms.value) return false;

    // Check if at least one package form has required fields
    for (int i = 0; i < selectedPackages.length; i++) {
      final form = packageFormsData[i] ?? {};
      if (form['date']?.toString().isNotEmpty == true && form['startTime']?.toString().isNotEmpty == true && form['endTime']?.toString().isNotEmpty == true) {
        return true;
      }
    }

    return false;
  }

  void submitBooking() {
    if (!canSubmit()) {
      Get.snackbar('Error', 'Please fill all required fields and accept terms');
      return;
    }

    final data = {
      'personalInfo': personalInfo.map((k, v) => MapEntry(k, v.value)),
      'altMobiles': alternateMobiles.map((e) => e.value).toList(),
      'altEmails': alternateEmails.map((e) => e.value).toList(),
      'packages': List.generate(selectedPackages.length, (i) => {'info': selectedPackages[i], 'form': packageFormsData[i]}),
      'termsAccepted': acceptTerms.value,
    };
    print('✅ Booking Data Submitted:\n$data');
  }
}
