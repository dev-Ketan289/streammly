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

  final Map<String, String> personalInfo = {
    'name': '',
    'mobile': '',
    'email': '',
  };
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

  void initSelectedPackages(
    List<Map<String, dynamic>> packages,
    List<dynamic> locations,
  ) {
    companyLocations = locations;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      selectedPackages = List<Map<String, dynamic>>.from(packages);
      packagePrices = List<int>.generate(
        packages.length,
        (index) =>
            int.tryParse(
              packages[index]['packagevariations']?[0]?['amount']?.toString() ??
                  '0',
            ) ??
            0,
      );
      showPackageDetails = List<bool>.filled(packages.length, false);

      for (int i = 0; i < packages.length; i++) {
        final package = packages[i];
        final packageTitle = package['title'] ?? '';
        final now = TimeOfDay.now();
        final formattedTime = cleanTimeString(formatTimeOfDay(now));
        Map<String, String> extraAnswers = {};
        final extraQuestions =
            package['extraQuestions'] ??
            package['packageextra_questions'] ??
            [];
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
      final cleanedTime = cleanTimeString(timeStr);
      final dateTime = DateFormat.jm().parse(cleanedTime);
      return DateFormat("HH:mm:ss").format(dateTime);
    } catch (e) {
      return "";
    }
  }

  String calculateTotalHours(String? startTime, String? endTime) {
    if (startTime == null || endTime == null) return "0";
    try {
      final start = DateFormat.jm().parse(cleanTimeString(startTime));
      final end = DateFormat.jm().parse(cleanTimeString(endTime));
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

    // Always clean time strings before storing in forms
    if (field == 'startTime' || field == 'endTime') {
      value = cleanTimeString(value?.toString() ?? '');
    }

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
    final companyLocation =
        companyLocations.isNotEmpty ? companyLocations[index] : null;
    final int advanceBlock = (companyLocation?.studio?.advanceDayBooking ?? 0);

    final DateTime now = DateTime.now();
    final DateTime firstAvailableDate = now.add(
      Duration(days: advanceBlock + 1),
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: firstAvailableDate,
      firstDate: firstAvailableDate,
      lastDate: now.add(const Duration(days: 365)),
    );

    String formatted = "";
    if (picked != null) {
      formatted =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
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

  String cleanTimeString(String? time) {
    if (time == null) return '';

    // Remove invisible unicode spaces
    String cleaned = time.replaceAll(
      RegExp(r'[\u00A0\u202F\u2007\u2060]'),
      ' ',
    );

    // Collapse multiple spaces into one
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Manual Split to enforce valid format
    List<String> parts = cleaned.split(' ');
    if (parts.length >= 2) {
      final timePart = parts[0].trim(); // hh:mm
      final periodPart = parts[1].toUpperCase(); // AM/PM

      // Validate Time Format (basic check)
      if (RegExp(r'^\d{1,2}:\d{2}$').hasMatch(timePart) &&
          (periodPart == 'AM' || periodPart == 'PM')) {
        return '$timePart $periodPart';
      }
    }

    return cleaned; // fallback return
  }

  String convertToApiTimeString(String timeStr) {
    if (timeStr.isEmpty) return '';

    try {
      // Clean invisible spaces and weird unicode
      String cleaned = timeStr.replaceAll(
        RegExp(r'[\u00A0\u202F\u2007\u2060]'),
        ' ',
      );
      cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

      log("Cleaned Time String: '$cleaned'");

      // Manual Split
      final parts = cleaned.split(' ');
      if (parts.length != 2) {
        log("Invalid time format after split: '$cleaned'");
        return '';
      }

      final timePart = parts[0]; // '10:00'
      final periodPart = parts[1].toUpperCase(); // 'AM' or 'PM'

      // Validate timePart
      if (!RegExp(r'^\d{1,2}:\d{2}$').hasMatch(timePart)) {
        log("Invalid timePart format: '$timePart'");
        return '';
      }

      if (periodPart != 'AM' && periodPart != 'PM') {
        log("Invalid periodPart: '$periodPart'");
        return '';
      }

      final reconstructed = '$timePart $periodPart';

      log("Reconstructed Time: '$reconstructed'");

      final dateTime = DateFormat(
        'h:mm a',
      ).parse(reconstructed); // Strict 12-hour parsing
      final apiTime = DateFormat('HH:mm:ss').format(dateTime);

      log("Final API Time: $apiTime");
      return apiTime;
    } catch (e, stack) {
      log("Error parsing time '$timeStr' -> $e\n$stack");
      return '';
    }
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
        final rawStart = form['startTime'];
        final rawEnd = form['endTime'];
        final cleanedStart = cleanTimeString(rawStart);
        final cleanedEnd = cleanTimeString(rawEnd);

        debugPrint("---- PACKAGE $i ----");
        debugPrint(
          "Raw Start Time: '$rawStart'  -> Runes: ${rawStart.runes.toList()}",
        );
        debugPrint(
          "Cleaned Start Time: '$cleanedStart'  -> Runes: ${cleanedStart.runes.toList()}",
        );

        debugPrint(
          "Raw End Time: '$rawEnd'  -> Runes: ${rawEnd.runes.toList()}",
        );
        debugPrint(
          "Cleaned End Time: '$cleanedEnd'  -> Runes: ${cleanedEnd.runes.toList()}",
        );

        DateTime? safeParseTime(String? time) {
          if (time == null || time.isEmpty) return null;
          try {
            String normalized = cleanTimeString(time);
            return DateFormat('h:mm a').parse(normalized);
          } catch (e, stack) {
            log("Failed to parse time: $time | Error: $e\nStackTrace: $stack");
            return null;
          }
        }

        final start = safeParseTime(rawStart);
        final end = safeParseTime(rawEnd);

        if (start == null || end == null) {
          debugPrint("Validation fail: Time parsing error for package $i");
          return false;
        }

        if (end.isBefore(start)) {
          debugPrint(
            "Validation fail: End time is before start time for package $i",
          );
          return false;
        }
      } catch (e) {
        debugPrint("Validation fail: Time parsing error for package $i: $e");
        return false;
      }

      final packageTitle =
          form['package_title'] ?? selectedPackages[i]['title'] ?? '';
      if (packageTitle == 'Cuteness' &&
          (form['babyInfo'] == null || (form['babyInfo'] as String).isEmpty)) {
        debugPrint("Validation fail: Baby info missing for package $i");
        return false;
      }

      final answers = Map<String, String>.from(form['extraAnswers'] ?? {});
      if (answers.values.any((value) => value.trim().isEmpty)) {
        debugPrint(
          "Validation fail: Some extra answers are empty for package $i",
        );
        return false;
      }
    }

    debugPrint("All validations passed");
    return true;
  }

  String extractExtraQuestionsAsString(Map<String, dynamic> form) {
    final extraAnswers = Map<String, String>.from(form['extraAnswers'] ?? {});
    if (extraAnswers.isEmpty) return '[]';
    return jsonEncode(extraAnswers);
  }

  int calculateWalletUsage(num payableAmount) {
    final walletBalance = authController.userProfile?.wallet ?? 0;
    final int payable = payableAmount.toInt();
    final int walletBal = walletBalance.toInt();
    return payable <= walletBal ? payable : walletBal;
  }

  // Added method that was missing in your original postBooking payload preparation
  num calculateWalletUsageForPackage(Map<String, dynamic> package) {
    final walletBalanceNum = authController.userProfile?.wallet ?? 0;
    final walletBalance =
        walletBalanceNum is int ? walletBalanceNum : walletBalanceNum.toInt();
    final packagePayableAmount =
        int.tryParse(
          package['packagevariations']?[0]?['amount']?.toString() ?? '0',
        ) ??
        0;
    return walletBalance >= packagePayableAmount
        ? packagePayableAmount
        : walletBalance;
  }

  int getWalletBalance() {
    final walletValue = authController.userProfile?.wallet;
    if (walletValue == null) return 0;
    return walletValue.toInt();
  }

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

  int totalPayableAmount() {
    final packageTotal = packagePrices.fold(0, (sum, p) => sum + p);
    final addonsTotal = totalExtraAddOnPrice();
    return packageTotal + addonsTotal;
  }

  // New method: check wallet sufficiency before booking
  bool canBookWithWallet() {
    final walletBalance = getWalletBalance();
    final payable = totalPayableAmount();
    if (walletBalance < payable) {
      Get.snackbar(
        'Insufficient Wallet Balance',
        'Your wallet balance ($walletBalance₹) is insufficient. Total amount required: $payable₹.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  Future<void> submitBooking() async {
    if (!canSubmit()) {
      Get.snackbar("Error", "Please fill all required fields and accept terms");
      return;
    }

    if (!canBookWithWallet()) {
      // Wallet insufficient snackbar shown in canBookWithWallet
      return;
    }

    isLoading = true;
    update();

    try {
      final userId = authController.userProfile?.id ?? 0;
      if (userId == 0) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      // Calculate total_hours = sum of all packages' hours
      double totalHours = 0;
      for (int i = 0; i < selectedPackages.length; i++) {
        final form = packageFormsData[i] ?? {};
        final startTime = convertToApiTimeString(form['startTime'] ?? '');
        final endTime = convertToApiTimeString(form['endTime'] ?? '');
        if (startTime.isNotEmpty && endTime.isNotEmpty) {
          final startDT = DateFormat('HH:mm').parse(startTime);
          final endDT = DateFormat('HH:mm').parse(endTime);
          final durationMinutes = endDT.difference(startDT).inMinutes;
          if (durationMinutes > 0) {
            totalHours += durationMinutes / 60;
          }
        }
      }

      for (int i = 0; i < selectedPackages.length; i++) {
        final package = selectedPackages[i];
        final form = packageFormsData[i] ?? {};

        final startTimeStr = convertToApiTimeString(form['startTime'] ?? '');
        final endTimeStr = convertToApiTimeString(form['endTime'] ?? '');

        String dateOfShoot = form['date'] ?? '';
        try {
          final dateParsed = DateFormat('yyyy-MM-dd').parse(dateOfShoot);
          dateOfShoot = DateFormat('dd-MM-yyyy').format(dateParsed);
        } catch (_) {
          // Use as-is if format unknown
        }

        final int packageHours =
            (() {
              if (startTimeStr.isEmpty || endTimeStr.isEmpty) return 0;
              try {
                final startDT = DateFormat('HH:mm').parse(startTimeStr);
                final endDT = DateFormat('HH:mm').parse(endTimeStr);
                final diff = endDT.difference(startDT).inMinutes;
                return diff > 0 ? (diff / 60).ceil() : 0;
              } catch (_) {
                return 0;
              }
            })();

        final walletUsed =
            (calculateWalletUsageForPackage(package) > 0) ? 'yes' : 'no';

        final payload = {
          "app_user_id": userId,
          "company_id": package['company_id'] ?? 1,
          "studio_id": package['studio_id'] ?? 1,
          "package_id": package['id'] ?? 0, // IMPORTANT: Set valid package_id
          "package_variation_id":
              package['packagevariations']?[0]?['id'] ??
              0, // IMPORTANT: Set valid variation_id
          "total_hours":
              packageHours, // Send per package hours here (or totalHours if backend expects that)
          "name": personalInfo['name'] ?? '',
          "mobile": personalInfo['mobile'] ?? '',
          "alternate_mobile":
              alternateMobiles.isNotEmpty ? alternateMobiles.join(",") : '',
          "email": personalInfo['email'] ?? '',
          "address": form['address'] ?? '',
          "date_of_shoot": dateOfShoot,
          "start_time": startTimeStr,
          "end_time": endTimeStr,
          "extra_questions": extractExtraQuestionsAsString(form),
          "terms_accepted": form['termsAccepted'] ?? false,
          "free_add_on": form['freeAddOn'] ?? {},
          "extra_add_on": form['extraAddOn'] ?? [],
          "wallet_used": walletUsed,
        };

        log("[submitBooking] Payload for packageId=${package['id']}: $payload");
        log('Form Data for package $i: ${jsonEncode(form)}');
        log('Extracted startTimeStr: $startTimeStr');
        log('Extracted endTimeStr: $endTimeStr');
        log(
          "Final Start Time (API format): $startTimeStr",
        ); // Should print like '10:00:00'
        log("Final End Time (API format): $endTimeStr");
        log("Form startTime Raw: '${form['startTime']}'");
        log("Form endTime Raw: '${form['endTime']}'");
        log("Extracted startTimeStr: $startTimeStr");
        log("Extracted endTimeStr: $endTimeStr");
        // Should print like '13:00:00'

        final ResponseModel? response = await bookingrepo.placeBooking(payload);

        if (response == null || !response.isSuccess) {
          Get.snackbar(
            "Booking Failed",
            response?.message ??
                "Booking failed for package ${package['title']}",
          );
          isLoading = false;
          update();
          return; // Stop further submission on failure
        }
      }

      // Refresh profile and wallet after all bookings
      await authController.fetchUserProfile();

      // Navigate to thank you page after successful booking
      Get.offAll(() => ThanksForBookingPage());
    } catch (e, stack) {
      log("submitBooking error: $e\n$stack");
      Get.snackbar("Error", "Something went wrong during booking submission");
    } finally {
      isLoading = false;
      update();
    }
  }

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
        timeSlots =
            (response.body["data"]["open_hours"] as List)
                .map((e) => Slot.fromJson(e))
                .toList();
        for (var i = 0; i < timeSlots.length; i++) {
          startTime.add(timeSlots[i].startTime);
          if (i == timeSlots.length - 1) {
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
