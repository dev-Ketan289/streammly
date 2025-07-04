import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/views/screens/package/booking/booking_page.dart';

class BookingController extends GetxController {
  var currentPage = 0.obs;
  var selectedPackages = <Map<String, dynamic>>[].obs;
  final personalInfo = {'name': ''.obs, 'mobile': ''.obs, 'email': ''.obs};
  final alternateMobiles = <RxString>[].obs;
  final alternateEmails = <RxString>[].obs;
  final packageFormsData = <int, Map<String, dynamic>>{}.obs;
  var acceptTerms = false.obs;

  /// Summary-specific data
  late RxList<int> packagePrices;
  late RxList<bool> showPackageDetails;

  void initSelectedPackages(List<Map<String, dynamic>> packages) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedPackages.assignAll(packages);

      // Initialize prices & detail toggles
      packagePrices = List<int>.generate(packages.length, (index) => int.tryParse(packages[index]['packagevariations']?[0]?['amount']?.toString() ?? '0') ?? 0).obs;

      showPackageDetails = List<bool>.filled(packages.length, false).obs;

      for (int i = 0; i < packages.length; i++) {
        final package = packages[i];
        final packageTitle = package['title'];

        Map<String, String> extraAnswers = {};
        final extraQuestions = package['extraQuestions'] ?? package['packageextra_questions'] ?? [];
        for (var question in extraQuestions) {
          final uniqueKey = "${i}_${question['id']}";
          extraAnswers[uniqueKey] = '';
        }

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
          'termsAccepted': false,
          'extraAnswers': extraAnswers,
        };
      }
      packageFormsData.refresh();
    });
  }

  /// Summary Logic Methods
  int get totalPayment => packagePrices.fold(0, (sum, price) => sum + price);

  void editPackage(int index) {
    currentPage.value = index;
    Get.to(() => BookingPage());
  }

  void toggleDetails(int index) {
    showPackageDetails[index] = !showPackageDetails[index];
  }

  /// Form Methods (your existing ones)
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

  void updateExtraAnswer(int index, String questionId, String answer) {
    final data = packageFormsData[index] ?? {};
    final extraAnswers = Map<String, String>.from(data['extraAnswers'] ?? {});
    final uniqueKey = "${index}_$questionId";
    extraAnswers[uniqueKey] = answer;
    data['extraAnswers'] = extraAnswers;
    packageFormsData[index] = data;
  }

  Future<String> selectDate(int index, BuildContext context) async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
    String formatted = "";
    if (picked != null) {
      formatted = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
      updatePackageForm(index, 'date', formatted);
    }
    return formatted;
  }

  String _getMonthName(int month) {
    const months = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
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

  void togglePackageTerms(int index) {
    final form = packageFormsData[index] ?? {};
    form['termsAccepted'] = !(form['termsAccepted'] ?? false);
    packageFormsData[index] = form;
    packageFormsData.refresh();
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
      if (packageTitle == 'Wonders' && form['locationPreference'] == null) return false;
      if (!(form['termsAccepted'] ?? false)) return false;

      final extraAnswers = Map<String, String>.from(form['extraAnswers'] ?? {});
      for (var answer in extraAnswers.values) {
        if (answer.trim().isEmpty) return false;
      }
    }
    return true;
  }

  void submitBooking() {
    if (!canSubmit()) {
      Get.snackbar('Error', 'Please fill all required fields and accept terms for each package');
      return;
    }

    final data = {
      'personalInfo': personalInfo.map((k, v) => MapEntry(k, v.value)),
      'altMobiles': alternateMobiles.map((e) => e.value).toList(),
      'altEmails': alternateEmails.map((e) => e.value).toList(),
      'packages': List.generate(selectedPackages.length, (i) {
        final form = packageFormsData[i];
        return {'info': selectedPackages[i], 'form': form};
      }),
      'termsAccepted': acceptTerms.value,
    };
    print('Booking Data Submitted:\n$data');
  }
}
