import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/package_page_controller.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/models/package/slots_model.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/views/screens/package/booking/booking_page.dart';
import 'package:streammly/views/screens/package/booking/thanks_for_booking.dart';

class BookingController extends GetxController {
  final AuthController authController = Get.find();
  final PackagesController packagesController = Get.find();
  final BookingRepo bookingrepo;

  BookingController({required this.bookingrepo});

  int currentPage = 0;
  List<Map<String, dynamic>> selectedPackages = [];
  bool isLoading = false;

  final Map<String, String> personalInfo = {'name': '', 'mobile': '', 'email': ''};
  final List<String> alternateMobiles = [];
  final List<String> alternateEmails = [];
  final Map<int, Map<String, dynamic>> packageFormsData = {};

  bool acceptTerms = false;
  late List<int> packagePrices;
  late List<bool> showPackageDetails;

  List<dynamic> companyLocations = [];

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  void onInit() {
    super.onInit();
    autofillFromUserProfile();
  }

  /// Autofill user info from AuthController
  void autofillFromUserProfile() {
    try {
      final userProfile = authController.userProfile;
      if (userProfile != null) {
        personalInfo['name'] = userProfile.name ?? '';
        personalInfo['mobile'] = userProfile.phone ?? '';
        personalInfo['email'] = userProfile.email ?? '';
        update();
      }
    } catch (e) {
      if (kDebugMode) print("AuthController error: $e");
    }
  }

  /// Initialize packages data and forms
  void initSelectedPackages(List<Map<String, dynamic>> packages, List<dynamic> locations) {
    companyLocations = locations;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedPackages = List<Map<String, dynamic>>.from(packages);
      packagePrices = List<int>.generate(
        packages.length,
            (index) => int.tryParse(packages[index]['packagevariations']?[0]?['amount']?.toString() ?? '0') ?? 0,
      );
      showPackageDetails = List<bool>.filled(packages.length, false);

      for (int i = 0; i < packages.length; i++) {
        final package = packages[i];
        final packageTitle = package['title'] ?? '';
        final now = TimeOfDay.now();
        final formattedTime = formatTimeOfDay(now);
        Map<String, String> extraAnswers = {};
        final extraQuestions = package['extraQuestions'] ?? package['packageextra_questions'] ?? [];
        for (var question in extraQuestions) {
          extraAnswers["${i}_${question['id']}"] = '';
        }

        packageFormsData[i] = {
          'address': package['address'] ?? '',
          'date': '',
          'startTime': formattedTime,
          'endTime': formattedTime,
          'babyInfo': packageTitle == 'Cuteness' ? null : null,
          'theme': packageTitle == 'Moments' ? null : null,
          'outfitChanges': packageTitle == 'Moments' ? null : null,
          'locationPreference': packageTitle == 'Wonders' ? null : null,
          'freeAddOn': null,
          'extraAddOn': <Map<String, dynamic>>[],
          'termsAccepted': false,
          'extraAnswers': extraAnswers,
        };
      }
      update();
    });
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  String convertToBackendTimeFormat(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return "";
    try {
      final dateTime = DateFormat.jm().parse(timeStr);
      return DateFormat("HH:mm:ss").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  String calculateTotalHours(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) return "0";
    try {
      final start = DateFormat.jm().parse(startTime);
      final end = DateFormat.jm().parse(endTime);
      final duration = end.difference(start);
      final hours = duration.inMinutes / 60;
      return hours.toStringAsFixed(1);
    } catch (e) {
      return "0";
    }
  }

  void editPackage(int index) {
    currentPage = index;
    update();
    Get.to(() => BookingPage(packages: [], companyLocations: []));
  }

  void toggleDetails(int index) {
    showPackageDetails[index] = !showPackageDetails[index];
    update();
  }

  void updatePersonalInfo(String key, String value) {
    if (personalInfo.containsKey(key)) {
      personalInfo[key] = value;
      update();
    }
  }

  void addAlternateMobile() {
    alternateMobiles.add('');
    update();
  }

  void removeAlternateMobile(int index) {
    if (index < alternateMobiles.length) {
      alternateMobiles.removeAt(index);
      update();
    }
  }

  void addAlternateEmail() {
    alternateEmails.add('');
    update();
  }

  void removeAlternateEmail(int index) {
    if (index < alternateEmails.length) {
      alternateEmails.removeAt(index);
      update();
    }
  }

  void updatePackageForm(int index, String field, dynamic value) {
    final data = packageFormsData[index] ?? {};
    data[field] = value;
    packageFormsData[index] = data;
    update();
  }

  void updateExtraAnswer(int index, String questionId, String answer) {
    final data = packageFormsData[index] ?? {};
    final extraAnswers = Map<String, String>.from(data['extraAnswers'] ?? {});
    final uniqueKey = "${index}_$questionId";
    extraAnswers[uniqueKey] = answer;
    data['extraAnswers'] = extraAnswers;
    packageFormsData[index] = data;
    update();
  }

  void updateExtraAddOns(int index, List<Map<String, dynamic>> selectedAddOns) {
    final data = packageFormsData[index] ?? {};
    data['extraAddOn'] = selectedAddOns;
    packageFormsData[index] = data;
    update();
  }

  Future<String> selectDate(int index, BuildContext context) async {
    final companyLocation = companyLocations.isNotEmpty ? companyLocations[index] : null;
    final int advanceBlock = (companyLocation?.studio?.advanceDayBooking ?? 0);

    final DateTime now = DateTime.now();
    final DateTime firstAvailableDate = now.add(Duration(days: advanceBlock + 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: firstAvailableDate,
      firstDate: firstAvailableDate,
      lastDate: now.add(const Duration(days: 365)),
    );

    String formatted = "";
    if (picked != null) {
      formatted = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      updatePackageForm(index, 'date', formatted);
    }
    return formatted;
  }

  void toggleAddOn(int index, String type) {
    Get.snackbar("Info", "This feature is currently disabled.");
  }

  void toggleTermsAcceptance() {
    acceptTerms = !acceptTerms;
    update();
  }

  void togglePackageTerms(int index) {
    final form = packageFormsData[index] ?? {};
    form['termsAccepted'] = !(form['termsAccepted'] ?? false);
    packageFormsData[index] = form;
    update();
  }

// Utility to clean possible invisible spaces in the time string
  String cleanTimeString(String? time) {
    if (time == null) return '';
    // Replace non-breaking space or unusual spaces with normal space, then trim
    return time.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  bool canSubmit() {
    if (personalInfo['name']?.isEmpty ?? true) {
      debugPrint("Validation fail: Name is empty");
      return false;
    }
    if (personalInfo['mobile']?.isEmpty ?? true) {
      debugPrint("Validation fail: Mobile is empty");
      return false;
    }
    if (personalInfo['email']?.isEmpty ?? true) {
      debugPrint("Validation fail: Email is empty");
      return false;
    }
    if (!acceptTerms) {
      debugPrint("Validation fail: Global terms not accepted");
      return false;
    }

    for (int i = 0; i < selectedPackages.length; i++) {
      final form = packageFormsData[i] ?? {};
      if ((form['address'] as String?)?.trim().isEmpty ?? true) {
        debugPrint("Validation fail: Address empty for package $i");
        return false;
      }
      if ((form['date'] as String?)?.isEmpty ?? true) {
        debugPrint("Validation fail: Date empty for package $i");
        return false;
      }
      if ((form['startTime'] as String?)?.isEmpty ?? true) {
        debugPrint("Validation fail: Start time empty for package $i");
        return false;
      }
      if ((form['endTime'] as String?)?.isEmpty ?? true) {
        debugPrint("Validation fail: End time empty for package $i");
        return false;
      }

      try {
        final start = DateFormat.jm().parse(cleanTimeString(form['startTime']));
        final end = DateFormat.jm().parse(cleanTimeString(form['endTime']));
        if (end.isBefore(start)) {
          debugPrint("Validation fail: End time is before start time for package $i");
          return false;
        }
      } catch (e) {
        debugPrint("Validation fail: Time parsing error for package $i: $e");
        return false;
      }

      final packageTitle = form['package_title'] ?? selectedPackages[i]['title'] ?? '';
      if (packageTitle == 'Cuteness' && (form['babyInfo'] == null || (form['babyInfo'] as String).isEmpty)) {
        debugPrint("Validation fail: Baby info missing for package $i");
        return false;
      }
      if (packageTitle == 'Moments' && (form['theme'] == null || (form['theme'] as String).isEmpty)) {
        debugPrint("Validation fail: Theme missing for package $i");
        return false;
      }
      if (packageTitle == 'Wonders' && (form['locationPreference'] == null || (form['locationPreference'] as String).isEmpty)) {
        debugPrint("Validation fail: Location preference missing for package $i");
        return false;
      }

      if (!(form['termsAccepted'] ?? false)) {
        debugPrint("Validation fail: Terms not accepted for package $i");
        return false;
      }

      final answers = Map<String, String>.from(form['extraAnswers'] ?? {});
      if (answers.values.any((value) => value.trim().isEmpty)) {
        debugPrint("Validation fail: Some extra answers are empty for package $i");
        return false;
      }
    }
    debugPrint("All validations passed");
    return true;
  }

  /// Package extra answers serialization
  String extractExtraQuestionsAsString(Map<String, dynamic> form) {
    final extraAnswers = Map<String, String>.from(form['extraAnswers'] ?? {});
    if (extraAnswers.isEmpty) return '[]';
    return jsonEncode(extraAnswers);
  }

  /// Calculate wallet usage for payment
  int calculateWalletUsage(num payableAmount) {
    final walletBalance = authController.userProfile?.wallet ?? 0;
    final int payable = payableAmount.toInt();
    final int walletBal = walletBalance.toInt();
    return payable <= walletBal ? payable : walletBal;
  }

  /// Calculate total addon price
  int totalExtraAddOnPrice() {
    int total = 0;
    for (final form in packageFormsData.values) {
      final extras = form['extraAddOn'] as List<dynamic>? ?? [];
      for (final item in extras) {
        total += int.tryParse(item['price']?.toString() ?? '0') ?? 0;
      }
    }
    return total;
  }

  /// Calculate total payable amount (package prices + addons)
  int totalPayableAmount() {
    final packageTotal = packagePrices.fold(0, (sum, p) => sum + p);
    final addonsTotal = totalExtraAddOnPrice();
    return packageTotal + addonsTotal;
  }

  /// Submit booking to backend
  Future<void> submitBooking() async {
    if (!canSubmit()) {
      Get.snackbar("Error", "Please fill all required fields and accept terms");
      return;
    }

    isLoading = true;
    update();

    try {
      final userId = authController.userProfile?.id ?? 0;
      final package = selectedPackages.first;
      final form = packageFormsData[0] ?? {};
      final variations = package['packagevariations'] as List<dynamic>? ?? [];
      final variation = variations.isNotEmpty ? variations[0] : {};

      final payableAmount = totalPayableAmount();
      final walletUsed = calculateWalletUsage(payableAmount);

      final payload = {
        "app_user_id": userId,
        "company_id": package['company_id'] ?? 0,
        "studio_id": package['studio_id'] ?? 0,
        "package_id": package['id'] ?? 0,
        "package_variation_id": variation['id'] ?? 0,
        "total_hours": calculateTotalHours(form['startTime'], form['endTime']),
        "name": personalInfo['name'] ?? '',
        "mobile": personalInfo['mobile'] ?? '',
        "alternate_mobile": alternateMobiles.isNotEmpty ? alternateMobiles.join(",") : '',
        "email": personalInfo['email'] ?? '',
        "address": form['address'] ?? '',
        "date_of_shoot": form['date'] ?? '',
        "start_time": convertToBackendTimeFormat(form['startTime']),
        "end_time": convertToBackendTimeFormat(form['endTime']),
        "extra_questions": extractExtraQuestionsAsString(form),
        "terms_accepted": form['termsAccepted'] ?? false,
        "free_add_on": form['freeAddOn'] ?? {},
        "extra_add_on": form['extraAddOn'] ?? [],
        "wallet_used": walletUsed,
      };

      final response = await bookingrepo.placeBooking(payload);
      if (response != null && response.isSuccess) {
        await authController.fetchUserProfile(); // Refresh wallet balance after booking
        Get.offAll(() => ThanksForBookingPage());
      } else {
        Get.snackbar("Error", response?.message ?? "Booking failed");
      }
    } catch (e) {
      log("Booking submission error: $e");
      Get.snackbar("Error", "Something went wrong during booking");
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Fetch available slots API (unchanged)
  List<Slot> timeSlots = [];
  List<TimeOfDay?> startTime = [];

  Future<ResponseModel?> fetchAvailableSlots({
    required String companyId,
    required String date,
    required String studioId,
    required String typeId,
  }) async {
    isLoading = true;
    timeSlots = [];
    startTime = [];
    update();
    ResponseModel? responseModel;
    try {
      Response response = await bookingrepo.fetchAvailableSlots(
        companyId: companyId,
        date: date,
        studioId: studioId,
        typeId: typeId,
      );
      log("Slots response: ${response.bodyString}");
      if (response.statusCode == 200) {
        timeSlots = (response.body["data"]["open_hours"] as List).map((e) => Slot.fromJson(e)).toList();
        for (var i = 0; i < timeSlots.length; i++) {
          startTime.add(timeSlots[i].startTime);
          if (i == timeSlots.length -1) {
            startTime.add(timeSlots[i].endTime);
          }
        }
        responseModel = ResponseModel(true, "Slots fetched successfully");
      } else {
        timeSlots.clear();
        responseModel = ResponseModel(false, "Failed to fetch slots");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error fetching slots");
      log(e.toString(), name: "fetchAvailableSlots");
    }
    isLoading = false;
    update();
    return responseModel;
  }
}
