import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/models/package/slots_model.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/views/screens/package/booking/booking_page.dart';

class BookingController extends GetxController {
  int currentPage = 0;
  List<Map<String, dynamic>> selectedPackages = [];
  final BookingRepo bookingrepo;
  bool isLoading = false;

  // Changed from Map<String, RxString> to simple Map<String, String>
  final personalInfo = {'name': '', 'mobile': '', 'email': ''};

  // Changed lists of RxString to normal List<String>
  final List<String> alternateMobiles = [];
  final List<String> alternateEmails = [];

  // packageFormsData as map int-> Map<String,dynamic> remains but non-Rx
  final Map<int, Map<String, dynamic>> packageFormsData = {};

  bool acceptTerms = false;

  late List<int> packagePrices;
  late List<bool> showPackageDetails;

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  List<dynamic> companyLocations = [];

  BookingController({required this.bookingrepo});

  /// --- AUTO-FILL PERSONAL INFO BASED ON LOGGED-IN USER PROFILE ---
  void autofillFromUserProfile() {
    try {
      final authController = Get.find<AuthController>();
      final userProfile = authController.userProfile;
      if (userProfile != null) {
        personalInfo['name'] = userProfile.name ?? '';
        personalInfo['mobile'] = userProfile.phone ?? '';
        personalInfo['email'] = userProfile.email ?? '';
        update();
      }
    } catch (e) {
      if (kDebugMode) print("AuthController not found or error: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    autofillFromUserProfile();
  }

  /// --- INITIALIZE SELECTED PACKAGES AND PREP FORM DATA ---
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
        final packageTitle = package['title'];
        final now = TimeOfDay.now();
        final formattedTime = formatTimeOfDay(now);

        final companyLocation = companyLocations.isNotEmpty ? companyLocations[i] : null;
        final int advanceBlock = (companyLocation?.studio?.advanceDayBooking ?? 0);
        final DateTime firstAvailableDate = DateTime.now().add(Duration(days: advanceBlock));
        final String formattedDate = "${firstAvailableDate.day} ${(firstAvailableDate.month)} ${firstAvailableDate.year}";

        Map<String, String> extraAnswers = {};
        final extraQuestions = package['extraQuestions'] ?? package['packageextra_questions'] ?? [];
        for (var question in extraQuestions) {
          final uniqueKey = "${i}_${question['id']}";
          extraAnswers[uniqueKey] = '';
        }

        packageFormsData[i] = {
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

  // --- Time formatting helper ---
  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "$hour:$minute $period";
  }

  int get totalPayment => packagePrices.fold(0, (sum, price) => sum + price);

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

  /// --- DATE PICKER with COMPANY BLOCK LOGIC ---
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
      formatted = "${picked.year} ${(picked.month)} ${picked.day}";
      updatePackageForm(index, 'date', formatted);
    }
    return formatted;
  }

  // String _getMonthName(int month) {
  //   const months = [
  //     '',
  //     'January',
  //     'February',
  //     'March',
  //     'April',
  //     'May',
  //     'June',
  //     'July',
  //     'August',
  //     'September',
  //     'October',
  //     'November',
  //     'December',
  //   ];
  //   return months[month];
  // }

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

  bool canSubmit() {
    if (personalInfo['name']?.isEmpty ?? true) return false;
    if (personalInfo['mobile']?.isEmpty ?? true) return false;
    if (personalInfo['email']?.isEmpty ?? true) return false;
    if (!acceptTerms) return false;

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
      'personalInfo': personalInfo,
      'altMobiles': alternateMobiles,
      'altEmails': alternateEmails,
      'packages': List.generate(selectedPackages.length, (i) {
        final form = packageFormsData[i];
        return {'info': selectedPackages[i], 'form': form};
      }),
      'termsAccepted': acceptTerms,
    };

    if (kDebugMode) {
      print('Booking Data Submitted:\n$data');
    }
  }

  int get totalExtraAddOnPrice {
    int total = 0;
    for (final form in packageFormsData.values) {
      final extras = form['extraAddOn'] as List<Map<String, dynamic>>? ?? [];
      for (final item in extras) {
        total += int.tryParse(item['price'].toString()) ?? 0;
      }
    }
    return total;
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
      Response response = await bookingrepo.fetchAvailableSlots(companyId: companyId, date: date, studioId: studioId, typeId: typeId);
      log("***** Response in updateUserProfile () ******: ${response.bodyString}");
      if (response.statusCode == 200) {
        timeSlots = (response.body["data"]["open_hours"] as List).map((e) => Slot.fromJson(e)).toList();
        for (var i = 0; i < timeSlots.length; i++) {
          startTime.add(timeSlots[i].startTime);
          if (timeSlots.length - 1 == i) {
            startTime.add(timeSlots[i].endTime);
          }
        }
        responseModel = ResponseModel(true, "User profile updated successfully");
      } else {
        timeSlots.clear();
        responseModel = ResponseModel(false, "Failed to update user profile");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error in update user profile");
      log(e.toString(), name: "***** Error in updateUserProfile () ******");
    }
    isLoading = false;
    update();
    return responseModel;
  }

/// === SLOT FETCH API ===
// Future<void> fetchAvailableSlots({
//   required int studioId,
//   required int typeId,
//   required String type,
//   required String date,
//   required String startTime,
//   required String endTime,
//   required int companyId,
// }) async {
//   final url = Uri.parse("http://192.168.1.113:8000/api/v1/workingtime/get-avilable-slots");
//   final headers = {
//     "Accept": "application/json",
//     "Authorization": "Bearer YOUR_TOKEN", // if needed
//   };
//
//   final request =
//       http.MultipartRequest("POST", url)
//         ..headers.addAll(headers)
//         ..fields['studio_id'] = studioId.toString()
//         ..fields['type_id'] = typeId.toString()
//         ..fields['type'] = type
//         ..fields['date'] = date
//         ..fields['start_time'] = startTime
//         ..fields['end_time'] = endTime
//         ..fields['company_id'] = companyId.toString();
//
//   debugPrint("Sending slot availability request...");
//   debugPrint("Payload: ${request.fields}");
//
//   try {
//     final response = await request.send();
//     final resStr = await response.stream.bytesToString();
//
//     debugPrint("Status Code: ${response.statusCode}");
//     debugPrint("Response Body: $resStr");
//
//     if (response.statusCode == 200) {
//       final data = json.decode(resStr);
//       // Handle data here
//     } else {
//       debugPrint("Failed to fetch slots. Status: ${response.statusCode}");
//     }
//   } catch (e) {
//     debugPrint("Error while fetching slots: $e");
//   }
// }
// }
}
