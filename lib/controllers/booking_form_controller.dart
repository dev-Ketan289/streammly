import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingFormController extends GetxController {
  var currentPage = 0.obs;
  var selectedPackages = <Map<String, dynamic>>[].obs;
  final personalInfo = {'name': ''.obs, 'mobile': ''.obs, 'email': ''.obs};
  final alternateMobiles = <RxString>[].obs;
  final alternateEmails = <RxString>[].obs;
  final packageFormsData = <int, Map<String, dynamic>>{}.obs;
  var acceptTerms = false.obs;

  void initSelectedPackages(List<Map<String, dynamic>> packages) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedPackages.assignAll(packages);
      for (int i = 0; i < packages.length; i++) {
        final packageTitle = packages[i]['title'];
        packageFormsData[i] = {
          'date': '',
          'startTime': '',
          'endTime': '',
          'babyInfo': packageTitle == 'Cuteness' ? null : null,
          'theme': packageTitle == 'Moments' ? null : null,
          'outfitChanges': packageTitle == 'Moments' ? null : null,
          'locationPreference': packageTitle == 'Wonders' ? null : null,
          'freeAddOn': null,
          'extraAddOn': null,
        };
      }
      packageFormsData.refresh();
    });
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
    if (field == 'date' || field == 'startTime' || field == 'endTime') {
      packageFormsData.refresh();
    }
  }

  Future<String> selectDate(int index, BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    String formatted = "";
    if (picked != null) {
      formatted = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      updatePackageForm(index, 'date', formatted);
    }
    return formatted;
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  void toggleAddOn(int index, String type) {
    final form = packageFormsData[index] ?? {};
    final key = type == 'free' ? 'freeAddOn' : 'extraAddOn';
    form[key] = form[key] == null ? 'Selected' : null;
    packageFormsData[index] = form;
    packageFormsData.refresh();
  }

  void toggleTermsAcceptance() {
    acceptTerms.value = !acceptTerms.value;
  }

  bool canSubmit() {
    if (personalInfo['name']?.value.isEmpty ?? true) return false;
    if (personalInfo['mobile']?.value.isEmpty ?? true) return false;
    if (personalInfo['email']?.value.isEmpty ?? true) return false;
    if (!acceptTerms.value) return false;

    for (int i = 0; i < selectedPackages.length; i++) {
      final form = packageFormsData[i] ?? {};
      if (form['date']?.toString().isEmpty ?? true) return false;
      if (form['startTime']?.toString().isEmpty ?? true) return false;
      if (form['endTime']?.toString().isEmpty ?? true) return false;

      try {
        final start = DateFormat('h:mm a').parse(form['startTime']);
        final end = DateFormat('h:mm a').parse(form['endTime']);
        if (end.isBefore(start)) return false;
      } catch (e) {
        return false;
      }

      final packageTitle = selectedPackages[i]['title'];
      if (packageTitle == 'Cuteness' && form['babyInfo'] == null) return false;
      if (packageTitle == 'Moments' && form['theme'] == null) return false;
      if (packageTitle == 'Wonders' && form['locationPreference'] == null) {
        return false;
      }
    }
    return true;
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
      'packages': List.generate(
        selectedPackages.length,
        (i) => {'info': selectedPackages[i], 'form': packageFormsData[i]},
      ),
      'termsAccepted': acceptTerms.value,
    };
    print('✅ Booking Data Submitted:\n$data');
  }
}
