import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/package_page_controller.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/auth_repo.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/models/package/slots_model.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/views/screens/package/booking/booking_page.dart';
import 'package:streammly/views/screens/package/booking/thanks_for_booking.dart';

import '../models/booking/booking_info_model.dart';
import 'otp_controller.dart';

class BookingController extends GetxController {
  // Dependencies - Lazy loading to prevent circular dependency issues
  AuthController get authController => Get.find<AuthController>();
  PackagesController get packagesController => Get.find<PackagesController>();

  // bool _personalInfoLoading = false;
  // bool _otpLoading = false;
  bool _slotsLoading = false;
  // bool _bookingsLoading = false;
  // bool _submitLoading = false;

  // OTP loaders
  bool _isOtpSending = false;
  bool _isOtpVerifying = false;

  bool get isOtpSending => _isOtpSending;
  bool get isOtpVerifying => _isOtpVerifying;

  bool get isSlotsLoading => _slotsLoading;
  // bool get isBookingsLoading => _bookingsLoading;
  // bool get isSubmitLoading => _submitLoading;

  final BookingRepo bookingrepo;

  // Text controllers - properly managed lifecycle
  late final TextEditingController nameController;
  late final TextEditingController mobileController;
  late final TextEditingController emailController;
  late final TextEditingController alternateMobileController;
  List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());

  // Disposal tracking
  bool _isDisposed = false;

  BookingController({required this.bookingrepo});

  // State variables - using traditional approach with update()
  List<BookingInfo> upcomingBookings = [];
  List<BookingInfo> cancelledBookings = [];
  List<BookingInfo> completedBookings = [];
  int currentPage = 0;
  List<Map<String, dynamic>> selectedPackages = [];
  List<dynamic> thankYouData = [];
  bool isLoading = false;
  bool acceptTerms = false;

  // Form data
  final Map<String, String> personalInfo = {
    'name': '',
    'mobile': '',
    'email': '',
  };
  final List<String> alternateMobiles = [];
  final List<String> alternateEmails = [];
  final Map<int, Map<String, dynamic>> packageFormsData = {};

  late List<int> packagePrices;
  late List<bool> showPackageDetails;

  List<dynamic> companyLocations = [];

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  // Slots related variables
  List<Slot> timeSlots = [];
  List<TimeOfDay?> startTime = [];
  int bufferTime = 0;

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    autofillFromUserProfile();
    fetchBookings();
  }

  @override
  void onReady() {
    super.onReady();
    // Any additional setup after widget is ready
  }

  @override
  void onClose() {
    // Dispose focus nodes
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    _disposeControllers();
    _clearData();
    super.onClose();
  }

  // Private initialization methods
  void _initializeControllers() {
    nameController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    alternateMobileController = TextEditingController();
  }

  void _disposeControllers() {
    if (!_isDisposed) {
      nameController.dispose();
      mobileController.dispose();
      emailController.dispose();
      alternateMobileController.dispose();
      _isDisposed = true;
    }
  }

  void _clearData() {
    upcomingBookings.clear();
    cancelledBookings.clear();
    completedBookings.clear();
    selectedPackages.clear();
    thankYouData.clear();
    alternateMobiles.clear();
    alternateEmails.clear();
    packageFormsData.clear();
    companyLocations.clear();
    timeSlots.clear();
    startTime.clear();
    personalInfo.clear();
  }

  bool isEditingAlternate = false;
  String? originalSecondaryMobile;

  void autofillFromUserProfile() {
    final user = authController.userProfile;
    if (user != null) {
      nameController.text = user.name ?? '';
      mobileController.text = user.phone ?? '';
      emailController.text = user.email ?? '';
      originalSecondaryMobile = user.secondaryMobile ?? '';

      // ✅ Keep personalInfo in sync when autofilling
      personalInfo['name'] = nameController.text.trim();
      personalInfo['mobile'] = mobileController.text.trim();
      personalInfo['email'] = emailController.text.trim();

      if (originalSecondaryMobile!.isNotEmpty) {
        alternateMobileController.text = originalSecondaryMobile!;
        if (alternateMobiles.isEmpty) {
          alternateMobiles.add(originalSecondaryMobile!);
        } else {
          alternateMobiles[0] = originalSecondaryMobile!;
        }
      } else {
        alternateMobileController.clear();
        alternateMobiles.clear();
      }

      log('Fetched profile name: "${authController.userProfile?.name}"');
      log('NameController text: "${nameController.text}"');

      update();
    }
  }

  void toggleAlternateEdit() {
    isEditingAlternate = !isEditingAlternate;
    update(['verify_button', 'alternate_field']);
  }

  void onSendOTPPressed() {
    final currentInput = alternateMobileController.text.trim();
    final primaryNumber = mobileController.text.trim();
    final existingSecondary = originalSecondaryMobile?.trim();

    if (currentInput.isEmpty) return;

    // Check if same as primary
    if (currentInput == primaryNumber) {
      Fluttertoast.showToast(
        msg: "Alternate number cannot be same as primary number",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Check if same as already saved secondary
    if (existingSecondary != null &&
        existingSecondary.isNotEmpty &&
        currentInput == existingSecondary) {
      Fluttertoast.showToast(
        msg: "This alternate number is already saved in your profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    sendOTPForAlternateMobile();
  }

  bool isOTPSent = false;
  bool isAlternateMobileVerified = false;

  List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  List<String> otpDigits = ['', '', '', '', '', ''];
  int otpTimer = 30;
  Timer? _otpTimer;
  bool get isOTPComplete => otpDigits.every((digit) => digit.isNotEmpty);

  void onOTPDigitChanged(int index, String value) {
    if (value.isNotEmpty && value.length == 1) {
      otpDigits[index] = value;

      if (index < 5) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          otpFocusNodes[index + 1].requestFocus();
        });
      } else {
        // Last field, unfocus keyboard
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (var node in otpFocusNodes) {
            node.unfocus();
          }
        });
      }
    } else if (value.isEmpty) {
      otpDigits[index] = '';

      if (index > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          otpFocusNodes[index - 1].requestFocus();
        });
      }
    }

    update(['verify_button']);
  }

  void onOTPFieldTapped(int index) {
    // Find the first empty field and focus there
    for (int i = 0; i < otpDigits.length; i++) {
      if (otpDigits[i].isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          otpFocusNodes[i].requestFocus();
          // Position cursor at the end
          otpControllers[i].selection = TextSelection.fromPosition(
            TextPosition(offset: otpControllers[i].text.length),
          );
        });
        return;
      }
    }

    // If all fields are filled, focus on the tapped field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      otpFocusNodes[index].requestFocus();
      otpControllers[index].selection = TextSelection.fromPosition(
        TextPosition(offset: otpControllers[index].text.length),
      );
    });
  }

  void startOTPTimer() {
    otpTimer = 30;
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer > 0) {
        otpTimer--;
        update();
      } else {
        timer.cancel();
      }
    });
  }

  void resendOTP() {
    // Clear current OTP
    for (int i = 0; i < otpControllers.length; i++) {
      otpControllers[i].clear();
      otpDigits[i] = '';
    }

    // Send new OTP
    sendOTPForAlternateMobile();
    startOTPTimer();
    update();
  }

  /// ==========================
  /// SEND OTP FOR ALTERNATE NUMBER
  /// ==========================
  void sendOTPForAlternateMobile() async {
    if (alternateMobiles.isEmpty || alternateMobiles[0].isEmpty) {
      Get.snackbar('Error', 'Please enter alternate mobile number');
      return;
    }

    final mobileNumber = alternateMobiles[0];
    if (!RegExp(r'^\d{10}$').hasMatch(mobileNumber)) {
      Get.snackbar('Error', 'Please enter valid 10-digit mobile number');
      return;
    }

    _isOtpSending = true;
    update(['verify_button']); // ✅ only refresh the "Send OTP" button UI

    try {
      // Use AuthController's OTP sending mechanism
      final authController = Get.find<AuthController>();

      // Temporarily store & set alternate number
      final originalPhone = authController.phoneController.text;
      authController.phoneController.text = mobileNumber;

      final response = await authController.sendOtp();

      // Restore original number
      authController.phoneController.text = originalPhone;

      if (response.isSuccess) {
        isOTPSent = true;
        startOTPTimer();
        update(['otp_section']); // update OTP section visibility
        Get.snackbar(
          'OTP Sent',
          'OTP has been sent to $mobileNumber',
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send OTP. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isOtpSending = false;
      update(['verify_button']);
    }
  }

  /// ==========================
  /// VERIFY ALTERNATE MOBILE OTP
  /// ==========================
  void verifyAlternateMobileOTP() async {
    final otp = otpDigits.join('');
    if (otp.isEmpty || otp.length != 6) {
      Get.snackbar('Error', 'Please enter valid 6-digit OTP');
      return;
    }

    _isOtpVerifying = true;
    update(['otp_section']); // ✅ only update OTP section buttons

    try {
      final mobileNumber = alternateMobiles[0];

      final otpController = Get.put(
        OtpController(
          authRepo: AuthRepo(
            sharedPreferences: Get.find(),
            apiClient: ApiClient(
              appBaseUrl: AppConstants.baseUrl,
              sharedPreferences: Get.find(),
            ),
          ),
        ),
      );

      final response = await otpController.verifyAlternateMobileOtp(
        phone: mobileNumber,
        otp: otp,
      );

      if (response.isSuccess) {
        _otpTimer?.cancel();
        isAlternateMobileVerified = true;
        isOTPSent = false;

        // Clear OTP fields on success
        for (int i = 0; i < otpControllers.length; i++) {
          otpControllers[i].clear();
          otpDigits[i] = '';
        }

        // Update profile with verified alternate number
        await updateAlternateNumberInProfile();
      } else {
        // Clear OTP fields on error
        for (int i = 0; i < otpControllers.length; i++) {
          otpControllers[i].clear();
          otpDigits[i] = '';
        }
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Clear OTP fields on exception
      for (int i = 0; i < otpControllers.length; i++) {
        otpControllers[i].clear();
        otpDigits[i] = '';
      }
      Get.snackbar(
        'Error',
        'Failed to verify OTP. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isOtpVerifying = false;
      update(['otp_section']); // stop Verify button loader
    }
  }

  Future<void> updateAlternateNumberInProfile() async {
    if (!isAlternateMobileVerified ||
        alternateMobiles.isEmpty ||
        alternateMobiles[0].isEmpty) {
      Get.snackbar('Error', 'Alternate number not verified');
      return;
    }

    try {
      isLoading = true;
      update();

      final userProfile = authController.userProfile;
      if (userProfile == null) {
        Get.snackbar('Error', 'User profile not found');
        return;
      }

      // Update profile with alternate phone as separate field
      final response = await authController.updateFullUserProfile(
        name: userProfile.name ?? '',
        email: userProfile.email ?? '',
        phone: userProfile.phone ?? '', // Keep original phone
        alternatePhone: alternateMobiles[0], // Add verified alternate phone
        dob: userProfile.dob.toString(),
        gender: userProfile.gender,
      );

      if (response != null && response.isSuccess) {
        Get.snackbar(
          'Success',
          'Alternate number updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response?.message ?? 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong while updating profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  // Update your addAlternateEmail method
  void addAlternateEmail() {
    if (alternateEmails.isEmpty) {
      alternateEmails.add('');
      update();
    } else {
      Get.snackbar("Info", "Only one alternate email address is allowed.");
    }
  }

  // Update removeAlternateEmail to actually remove
  void removeAlternateEmail(int index) {
    if (index < alternateEmails.length) {
      alternateEmails.removeAt(index);
      update();
    }
  }

  // Add method to force refresh personal info
  void refreshPersonalInfo() {
    autofillFromUserProfile();
  }

  // Add this method to your BookingController
  // Add this method to BookingController
  void syncAlternateMobileData() {
    final controllerText = alternateMobileController.text.trim();
    if (alternateMobiles.isEmpty) {
      alternateMobiles.add(controllerText);
    } else {
      alternateMobiles[0] = controllerText;
    }
  }

  // Update _ensureAlternateFieldsExist
  void _ensureAlternateFieldsExist() {
    if (alternateMobiles.isEmpty) {
      alternateMobiles.add('');
    }
    if (alternateMobiles.length > 1) {
      alternateMobiles.removeRange(1, alternateMobiles.length);
    }

    if (!_isDisposed) {
      if (alternateMobiles.isNotEmpty) {
        alternateMobileController.text = alternateMobiles[0];
      }
      // Add listener to keep them in sync
      alternateMobileController.addListener(() {
        syncAlternateMobileData();
      });
    }
  }

  // Update your initSelectedPackages method to call this
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

      packageFormsData.clear();
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
        log(packages.toString(), name: "initSelectedPackages");
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
          'specialInstructions': '',
          'attachmentImage': null,
          'advanceBookingDays':
              int.tryParse(package['advanceBookingDays']?.toString() ?? '0') ??
              1,
        };
      }

      // Ensure alternate fields are initialized
      _ensureAlternateFieldsExist();
      update();
    });
  }

  void updateSpecialInstructions(int index, String value) {
    final data = packageFormsData[index] ?? {};
    data['specialInstructions'] = value;
    packageFormsData[index] = data;
    update();
  }

  void updateAttachmentImage(int index, Map<String, dynamic>? fileData) {
    final data = packageFormsData[index] ?? {};
    data['attachmentImage'] = fileData; // {name, path, size, bytes}
    packageFormsData[index] = data;
    update();
  }

  // Remove or update these methods since we only allow one alternate field each
  void addAlternateMobile() {
    // Do nothing or show a message that only one alternate is allowed
    Get.snackbar("Info", "Only one alternate mobile number is allowed.");
  }

  // void addAlternateEmail() {
  //   Get.snackbar("Info", "Only one alternate email address is allowed.");
  // }

  // Update remove methods to clear the field instead of removing
  void removeAlternateMobile(int index) {
    if (index == 0 && alternateMobiles.isNotEmpty) {
      alternateMobiles[0] = '';
      update();
    }
  }

  // void removeAlternateEmail(int index) {
  //   if (index == 0 && alternateEmails.isNotEmpty) {
  //     alternateEmails[0] = '';
  //     update();
  //   }
  // }

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
    Get.to(
      () => BookingPage(
        packages: [],
        companyLocations: [],
        companyLocation: null,
        companyId: 0,
      ),
    );
  }

  void toggleDetails(int index) {
    if (index < showPackageDetails.length) {
      showPackageDetails[index] = !showPackageDetails[index];
      update();
    }
  }

  void updatePersonalInfo(String key, String value) {
    if (personalInfo.containsKey(key)) {
      personalInfo[key] = value;
      update();
    }
  }

  // void addAlternateMobile() {
  //   alternateMobiles.add('');
  //   update();
  // }
  //
  // void removeAlternateMobile(int index) {
  //   if (index < alternateMobiles.length) {
  //     alternateMobiles.removeAt(index);
  //     update();
  //   }
  // }
  //
  // void addAlternateEmail() {
  //   alternateEmails.add('');
  //   update();
  // }
  //
  // void removeAlternateEmail(int index) {
  //   if (index < alternateEmails.length) {
  //     alternateEmails.removeAt(index);
  //     update();
  //   }
  // }

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
    // ✅ Always sync from controllers before validation
    personalInfo['name'] = nameController.text.trim();
    personalInfo['mobile'] = mobileController.text.trim();
    personalInfo['email'] = emailController.text.trim();

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

    log('Name before validation = "${nameController.text}"');
    log('Mobile before validation = "${mobileController.text}"');

    debugPrint("All validations passed");
    return true;
  }

  String extractExtraQuestionsAsString(Map<String, dynamic> form) {
    final extraAnswers = Map<String, String>.from(form['extraAnswers'] ?? {});
    if (extraAnswers.isEmpty) return '[]';
    return jsonEncode(extraAnswers);
  }

  int calculateWalletUsage(num payableAmount) {
    try {
      final walletBalance = authController.userProfile?.wallet ?? 0;
      final int payable = payableAmount.toInt();
      final int walletBal = walletBalance.toInt();
      return payable <= walletBal ? payable : walletBal;
    } catch (e) {
      return 0;
    }
  }

  // Added method that was missing in your original postBooking payload preparation
  num calculateWalletUsageForPackage(Map<String, dynamic> package) {
    try {
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
    } catch (e) {
      return 0;
    }
  }

  int getWalletBalance() {
    try {
      final walletValue = authController.userProfile?.wallet;
      if (walletValue == null) return 0;
      return walletValue.toInt();
    } catch (e) {
      return 0;
    }
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
      return; // Wallet insufficiency snackbar shown in canBookWithWallet
    }

    isLoading = true;
    update();

    try {
      final userId = authController.userProfile?.id ?? 0;
      if (userId == 0) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final List<Map<String, dynamic>> bookingsPayload = [];

      for (int i = 0; i < selectedPackages.length; i++) {
        final package = selectedPackages[i];
        final form = packageFormsData[i] ?? {};

        final startTimeStr = form['startTime'] ?? '';
        final endTimeStr = form['endTime'] ?? '';
        final dateOfShoot = form['date'] ?? '';

        final image = form['attachmentImage'];
        if (image != null && image['size'] > 500 * 1024) {
          Get.snackbar('Error', 'Image must be below 500KB');
          return;
        }

        final totalHours =
            (() {
              final startApiTime = convertToApiTimeString(startTimeStr);
              final endApiTime = convertToApiTimeString(endTimeStr);
              if (startApiTime.isEmpty || endApiTime.isEmpty) return 0;

              try {
                final startDT = DateFormat('HH:mm:ss').parse(startApiTime);
                final endDT = DateFormat('HH:mm:ss').parse(endApiTime);
                final diff = endDT.difference(startDT).inHours;
                return diff > 0 ? diff : 0;
              } catch (_) {
                return 0;
              }
            })();

        bookingsPayload.add({
          "package_id": package['id'] ?? 0,
          "package_variation_id": package['packagevariations']?[0]?['id'] ?? 0,
          "address": form['address'] ?? '',
          "free_addons":
              form['freeAddOn'] != null && (form['freeAddOn'] as Map).isNotEmpty
                  ? [form['freeAddOn']['id']]
                  : [],
          "paid_addons":
              (form['extraAddOn'] as List<dynamic>? ?? [])
                  .map((addon) => addon['id'])
                  .toList(),
          "extra_question": extractExtraQuestionsAsString(form),
          "date_of_shoot": dateOfShoot,
          "start_time": startTimeStr,
          "end_time": endTimeStr,
          "total_hours": totalHours,
          "special_instructions": form['specialInstructions'] ?? '',
          // For now, just include metadata for attachment; actual upload might be added later when backend supports
          "attachment_image":
              image != null
                  ? {"name": image['name'], "path": image['path']}
                  : null,
        });
      }

      final payload = {
        "company_id":
            selectedPackages.isNotEmpty
                ? selectedPackages[0]['company_id'] ?? 0
                : 0,
        "name": personalInfo['name'] ?? '',
        "mobile": personalInfo['mobile'] ?? '',
        "alternate_mobile":
            alternateMobiles.isNotEmpty ? alternateMobiles.join(",") : '',
        "wallet_used": 'yes', // or 'no' depending on your logic
        "studio_id":
            selectedPackages.isNotEmpty
                ? selectedPackages[0]['studio_id'] ?? 0
                : 0,
        "bookings": bookingsPayload,
      };

      log("[submitBooking] Full payload: $payload");

      final responseBody = await bookingrepo.placeBatchBooking(payload);

      if (responseBody == null || responseBody['success'] != true) {
        Get.snackbar(
          "Booking Failed",
          responseBody?['message'] ?? "Booking failed",
        );
        return;
      }

      thankYouData = responseBody['thankyouPage'] ?? [];

      await authController.fetchUserProfile();
      Get.offAll(() => ThanksForBookingPage());
    } catch (e, stack) {
      log("submitBooking error: $e\n$stack");
      Get.snackbar("Error", "Something went wrong during booking submission");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<ResponseModel?> fetchAvailableSlots({
    required String companyId,
    required String date,
    required String studioId,
    required String typeId,
  }) async {
    // Use specific loading flag instead of global isLoading
    _slotsLoading = true;
    timeSlots.clear();
    startTime.clear();
    update(['slots']); // Only update slots section

    ResponseModel? responseModel;
    try {
      Response response = await bookingrepo.fetchAvailableSlots(
        companyId: companyId,
        date: date,
        studioId: studioId,
        typeId: typeId,
      );

      log(
        "Slots response: ${response.bodyString}",
        name: "fetchAvailableSlots",
      );

      if (response.statusCode == 200) {
        final openHours = response.body["data"]["open_hours"] as List;
        log("Open hours: $openHours", name: "fetchAvailableSlots");

        bufferTime =
            int.tryParse(
              response.body["data"]["studio_location"]["buffer_time"] ?? "0",
            ) ??
            0;

        timeSlots = openHours.map((e) => Slot.fromJson(e)).toList();

        // Build startTime array
        for (var i = 0; i < timeSlots.length; i++) {
          startTime.add(timeSlots[i].startTime);
          if (i == timeSlots.length - 1 && timeSlots[i].endTime != null) {
            startTime.add(timeSlots[i].endTime);
            log(
              "Last slot endTime: ${timeSlots[i].endTime!.format(Get.context!)}",
              name: "fetchAvailableSlots",
            );
          }
        }

        // Add final slot if timeSlots is not empty
        if (timeSlots.isNotEmpty) {
          final lastSlot = timeSlots.last;
          timeSlots.add(
            Slot(
              booked: lastSlot.booked,
              breakTime: lastSlot.breakTime,
              blockHome: lastSlot.blockHome,
              blockIndoor: lastSlot.blockIndoor,
              blockOutdoor: lastSlot.blockOutdoor,
              startTime: lastSlot.endTime,
              endTime: lastSlot.endTime,
            ),
          );
        }

        responseModel = ResponseModel(true, "Slots fetched successfully");
      } else {
        timeSlots.clear();
        startTime.clear();
        responseModel = ResponseModel(
          false,
          "Failed to fetch slots: ${response.statusText}",
        );
        // Get.snackbar(
        //   "Error",
        //   "Failed to fetch slots: ${response.statusText}",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.redAccent,
        //   colorText: Colors.white,
        // );
      }
    } catch (e) {
      timeSlots.clear();
      startTime.clear();
      responseModel = ResponseModel(false, "Error fetching slots: $e");
      // Get.snackbar(
      //   "Error",
      //   "Unable to fetch slots. Please try again later.",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      // );
      log(e.toString(), name: "fetchAvailableSlots");
    } finally {
      // Always reset loading state in finally block
      _slotsLoading = false;
      update(['slots']); // Only update slots section
    }

    return responseModel;
  }

  Future<void> fetchBookings() async {
    isLoading = true;
    update();

    try {
      final response = await bookingrepo.getUserBookings();
      if (response != null && response['success'] == true) {
        final allBookings = response['data'] as List<dynamic>? ?? [];
        final now = DateTime.now();

        // Filter raw bookings by your logic
        final upcomingRaw =
            allBookings.where((booking) {
              final shootDate = DateTime.tryParse(
                booking['date_of_shoot'] ?? '',
              );
              final status = (booking['status'] ?? '').toString().toLowerCase();
              return shootDate != null &&
                  (shootDate.isAtSameMomentAs(now) || shootDate.isAfter(now)) &&
                  status == 'pending';
            }).toList();

        final cancelledRaw =
            allBookings.where((booking) {
              return (booking['status'] ?? '').toString().toLowerCase() ==
                  'cancelled';
            }).toList();

        final completedRaw =
            allBookings.where((booking) {
              return (booking['status'] ?? '').toString().toLowerCase() ==
                      'completed' ||
                  (booking['shoot_done'] == true);
            }).toList();

        // Map filtered raw data to typed BookingInfo list
        upcomingBookings =
            upcomingRaw
                .map((b) => BookingInfo.fromJson(b as Map<String, dynamic>))
                .toList();
        cancelledBookings =
            cancelledRaw
                .map((b) => BookingInfo.fromJson(b as Map<String, dynamic>))
                .toList();
        completedBookings =
            completedRaw
                .map((b) => BookingInfo.fromJson(b as Map<String, dynamic>))
                .toList();
      } else {
        upcomingBookings = [];
        cancelledBookings = [];
        completedBookings = [];
      }
    } catch (e) {
      upcomingBookings = [];
      cancelledBookings = [];
      completedBookings = [];
      log('Error fetching bookings: $e', name: 'BookingController');
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearBookings() {
    upcomingBookings.clear();
    isLoading = false;
    update();
  }

  // Lead
  bool _isStoringLead = false;
  bool get isStoringLead => _isStoringLead;
  bool leadStoredForThisSession = false;

  // In BookingController - simplified version
  Future<void> storeLead({
    required int companyId,
    required int packageId,
  }) async {
    if (_isStoringLead) return;

    _isStoringLead = true;

    try {
      log(
        'Storing lead: Company=$companyId, Package=$packageId',
        name: 'storeLead',
      );

      final response = await bookingrepo.storeLead(
        companyId: companyId,
        packageId: packageId,
      );

      if (response.statusCode == 200 && response.body['success'] == true) {
        log('Lead stored successfully', name: 'storeLead');
      } else {
        log('Lead storage failed: ${response.body}', name: 'storeLead');
      }
    } catch (e) {
      log('Error storing lead: $e', name: 'storeLead');
    } finally {
      _isStoringLead = false;
    }
  }

  // Method to call when user leaves booking page
  void storeLeadOnExit() {
    if (leadStoredForThisSession) {
      log('Lead already stored for this session', name: 'storeLeadOnExit');
      return;
    }

    log('🔄 storeLeadOnExit() called', name: 'BookingController');

    if (selectedPackages.isNotEmpty) {
      final package = selectedPackages.first;
      final companyId = package['company_id'] ?? 0;
      final packageId = package['id'] ?? 0;

      if (companyId > 0 && packageId > 0) {
        storeLead(companyId: companyId, packageId: packageId);
        leadStoredForThisSession = true; // Mark as stored
      }
    }
  }
}
