import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  // Personal Info
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();

  // Alternate contact
  var altMobiles = <TextEditingController>[].obs;
  var altEmails = <TextEditingController>[].obs;

  void addAltMobile() {
    altMobiles.add(TextEditingController());
  }

  void removeAltMobile(int index) {
    altMobiles.removeAt(index);
  }

  void addAltEmail() {
    altEmails.add(TextEditingController());
  }

  void removeAltEmail(int index) {
    altEmails.removeAt(index);
  }

  // Package Toggles
  var selectedPackageIndex = 0.obs;

  void selectPackage(int index) {
    selectedPackageIndex.value = index;
  }

  // Assume 3 packages (adjust if needed)
  final int packageCount = 3;

  // Booking Schedule Controllers
  late List<TextEditingController> dateControllers;
  late List<TextEditingController> startTimeControllers;
  late List<TextEditingController> endTimeControllers;

  // Questions for each package
  late List<TextEditingController> question1Controllers;
  late List<TextEditingController> question2Controllers;

  // Terms accepted toggle
  late List<RxBool> termsAccepted;

  @override
  void onInit() {
    super.onInit();

    dateControllers = List.generate(packageCount, (_) => TextEditingController());
    startTimeControllers = List.generate(packageCount, (_) => TextEditingController());
    endTimeControllers = List.generate(packageCount, (_) => TextEditingController());

    question1Controllers = List.generate(packageCount, (_) => TextEditingController());
    question2Controllers = List.generate(packageCount, (_) => TextEditingController());

    termsAccepted = List.generate(packageCount, (_) => false.obs);
  }

  // Pickers
  void pickDate(BuildContext context, int index) async {
    DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 365)));
    if (picked != null) {
      dateControllers[index].text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void pickStartTime(BuildContext context, int index) async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      startTimeControllers[index].text = picked.format(context);
    }
  }

  void pickEndTime(BuildContext context, int index) async {
    TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      endTimeControllers[index].text = picked.format(context);
    }
  }

  void toggleTerms(bool value, int index) {
    termsAccepted[index].value = value;
  }

  // Submission logic placeholder
  void submitForm() {
    final selected = selectedPackageIndex.value;

    // Validate main fields
    if (nameController.text.isEmpty || mobileController.text.isEmpty || emailController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required personal info fields");
      return;
    }

    // Validate schedule
    if (dateControllers[selected].text.isEmpty || startTimeControllers[selected].text.isEmpty || endTimeControllers[selected].text.isEmpty) {
      Get.snackbar("Error", "Please select booking schedule");
      return;
    }

    // Validate T&C
    if (!termsAccepted[selected].value) {
      Get.snackbar("Error", "Please accept Terms & Conditions");
      return;
    }

    // If all good
    Get.snackbar("Success", "Form submitted successfully");
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();

    for (var c in altMobiles) c.dispose();
    for (var c in altEmails) c.dispose();

    for (var c in dateControllers) c.dispose();
    for (var c in startTimeControllers) c.dispose();
    for (var c in endTimeControllers) c.dispose();
    for (var c in question1Controllers) c.dispose();
    for (var c in question2Controllers) c.dispose();

    super.onClose();
  }
}
