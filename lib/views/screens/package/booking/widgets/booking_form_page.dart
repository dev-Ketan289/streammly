import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/package/booking/widgets/time_picker.dart';

import '../../../../../controllers/booking_form_controller.dart';
import '../../../common/widgets/custom_textfield.dart' show CustomTextField;

class PackageFormCard extends StatefulWidget {
  final int index;

  final Map<String, dynamic> package;
  const PackageFormCard({super.key, required this.index, required this.package});

  @override
  State<PackageFormCard> createState() => _PackageFormCardState();
}

class _PackageFormCardState extends State<PackageFormCard> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();

  bool isStartTime = true;
  bool showTimePicker = false; // New state variable for time picker visibility

  @override
  void dispose() {
    super.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    dateTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController studioAddController = TextEditingController(text: widget.package['address'] ?? '305/A, Navneet Building, Saivihar Road, Bhandup (W), Mumbai 400078.');
    final controller = Get.find<BookingFormController>();

    return Obx(() {
      final form = controller.packageFormsData[widget.index] ?? {};

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Booking Schedule", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 20),

            // Studio Address
            CustomTextField(labelText: 'Studio Address *', controller: studioAddController, readOnly: true),
            const SizedBox(height: 16),

            // Date Picker
            CustomTextField(
              labelText: 'Date of Shoot *',
              controller: dateTimeController,
              initialValue: form['date'] ?? '',
              hintText: form['date']?.isEmpty ?? true ? 'Select Date' : null,
              readOnly: true,
              onTap: () async {
                dateTimeController.text = await controller.selectDate(widget.index, context);
              },
              prefixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),

            // Time Row
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: startTimeController,
                    labelText: 'Start Time *',
                    initialValue: form['startTime'] ?? '',
                    hintText: form['startTime']?.isEmpty ?? true ? '00:00 AM' : null,
                    readOnly: true,
                    prefixIcon: Icons.access_time,
                    onTap: () {
                      setState(() {
                        isStartTime = true;
                        showTimePicker = true; // Show time picker
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: endTimeController,
                    labelText: 'End Time *',
                    initialValue: form['endTime'] ?? '',
                    hintText: form['endTime']?.isEmpty ?? true ? '00:00 PM' : null,
                    readOnly: true,
                    prefixIcon: Icons.access_time,
                    onTap: () {
                      setState(() {
                        isStartTime = false;
                        showTimePicker = true; // Show time picker
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Conditionally show CustomTimePicker
            if (showTimePicker)
              CustomTimePicker(
                isStart: isStartTime,
                onCancel: () {
                  setState(() {
                    if (isStartTime) {
                      startTimeController.text = "";
                    } else {
                      endTimeController.text = "";
                    }
                    showTimePicker = false; // Hide time picker
                  });
                },
                onTimeSelected: (time) {
                  setState(() {
                    if (isStartTime) {
                      startTimeController.text = time;
                      controller.updatePackageForm(widget.index, 'startTime', time);
                    } else {
                      endTimeController.text = time;
                      controller.updatePackageForm(widget.index, 'endTime', time);
                    }
                    showTimePicker = false; // Hide time picker
                  });
                },
              ),

            const SizedBox(height: 16),
            const Text("Questions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 16),

            // Baby Age & Gender Dropdown
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
              child: DropdownButtonFormField<String>(
                value: form['babyInfo'],
                decoration: const InputDecoration(
                  labelText: "What is your baby's age and gender?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: const [
                  DropdownMenuItem(value: '0-3M Boy', child: Text('0-3 Months Boy')),
                  DropdownMenuItem(value: '0-3M Girl', child: Text('0-3 Months Girl')),
                  DropdownMenuItem(value: '3-6M Boy', child: Text('3-6 Months Boy')),
                  DropdownMenuItem(value: '3-6M Girl', child: Text('3-6 Months Girl')),
                  DropdownMenuItem(value: '6-12M', child: Text('6-12 Months')),
                ],
                onChanged: (val) => controller.updatePackageForm(widget.index, 'babyInfo', val),
              ),
            ),
            const SizedBox(height: 16),

            // Theme/Color Preference Dropdown
            Container(
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
              child: DropdownButtonFormField<String>(
                value: form['theme'],
                decoration: const InputDecoration(
                  labelText: "Do you have a specific theme or color palette in mind for the shoot?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                items: const [
                  DropdownMenuItem(value: 'Pastel Colors', child: Text('Pastel Colors')),
                  DropdownMenuItem(value: 'Vibrant Colors', child: Text('Vibrant Colors')),
                  DropdownMenuItem(value: 'Minimal/Clean', child: Text('Minimal/Clean')),
                  DropdownMenuItem(value: 'Natural/Earthy', child: Text('Natural/Earthy')),
                  DropdownMenuItem(value: 'No Preference', child: Text('No Preference')),
                ],
                onChanged: (val) => controller.updatePackageForm(widget.index, 'theme', val),
              ),
            ),
            const SizedBox(height: 32),

            // Add-Ons Section
            _buildExpandableSection(title: 'Choose Free Item', isSelected: form['freeAddOn'] != null, onTap: () => controller.toggleAddOn(widget.index, 'free')),
            const SizedBox(height: 16),

            _buildExpandableSection(title: 'Extra Add-Ons (Extra Charged)', isSelected: form['extraAddOn'] != null, onTap: () => controller.toggleAddOn(widget.index, 'extra')),
            const SizedBox(height: 32),

            // Terms and Conditions
            Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.toggleTermsAcceptance(),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: controller.acceptTerms.value ? const Color(0xFF4A6CF7) : Colors.white,
                        border: Border.all(color: controller.acceptTerms.value ? const Color(0xFF4A6CF7) : Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: controller.acceptTerms.value ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          const TextSpan(text: 'I accept the '),
                          TextSpan(text: 'Terms and Conditions', style: TextStyle(color: const Color(0xFF4A6CF7), decoration: TextDecoration.underline)),
                          const TextSpan(text: ' and agree to the '),
                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: const Color(0xFF4A6CF7), decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildExpandableSection({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(dashPattern: [10, 5], strokeWidth: 2, color: const Color.fromARGB(255, 157, 155, 155), radius: Radius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isSelected ? const Color(0xFF4A6CF7) : Colors.black87)),
              Icon(isSelected ? Icons.remove : Icons.add, color: isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade600),
            ],
          ),
        ),
      ),
    );
  }
}
