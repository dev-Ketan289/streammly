import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/package/booking/widgets/time_picker.dart';
import '../../../../../controllers/booking_form_controller.dart';
import '../../../common/widgets/custom_textfield.dart' show CustomTextField;

class PackageFormCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> package;

  const PackageFormCard({
    super.key,
    required this.index,
    required this.package,
  });

  @override
  State<PackageFormCard> createState() => _PackageFormCardState();
}

class _PackageFormCardState extends State<PackageFormCard> {
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController dateTimeController;
  bool isStartTime = true;
  bool showTimePicker = false;

  @override
  void initState() {
    super.initState();
    final controller = Get.find<BookingFormController>();
    final form = controller.packageFormsData[widget.index] ?? {};

    // Initialize controllers with package-specific data
    startTimeController = TextEditingController(text: form['startTime'] ?? '');
    endTimeController = TextEditingController(text: form['endTime'] ?? '');
    dateTimeController = TextEditingController(text: form['date'] ?? '');
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController studioAddController = TextEditingController(
      text:
          widget.package['address'] ??
          '305/A, Navneet Building, Saivihar Road, Bhandup (W), Mumbai 400078.',
    );
    final controller = Get.find<BookingFormController>();
    final packageTitle = widget.package['title'] as String;

    return Obx(() {
      final form = controller.packageFormsData[widget.index] ?? {};

      // Sync controllers with form data
      if (startTimeController.text != (form['startTime'] ?? '')) {
        startTimeController.text = form['startTime'] ?? '';
      }
      if (endTimeController.text != (form['endTime'] ?? '')) {
        endTimeController.text = form['endTime'] ?? '';
      }
      if (dateTimeController.text != (form['date'] ?? '')) {
        dateTimeController.text = form['date'] ?? '';
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$packageTitle Booking Schedule",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Studio Address
            CustomTextField(
              labelText: 'Studio Address *',
              controller: studioAddController,
              readOnly: true,
            ),
            const SizedBox(height: 16),

            // Date Picker
            CustomTextField(
              labelText: 'Date of Shoot *',
              controller: dateTimeController,
              hintText: form['date']?.isEmpty ?? true ? 'Select Date' : null,
              readOnly: true,
              onTap: () async {
                final selectedDate = await controller.selectDate(
                  widget.index,
                  context,
                );
                if (selectedDate.isNotEmpty) {
                  dateTimeController.text = selectedDate;
                }
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
                    hintText:
                        form['startTime']?.isEmpty ?? true ? '00:00 AM' : null,
                    readOnly: true,
                    prefixIcon: Icons.access_time,
                    onTap: () {
                      setState(() {
                        isStartTime = true;
                        showTimePicker = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: endTimeController,
                    labelText: 'End Time *',
                    hintText:
                        form['endTime']?.isEmpty ?? true ? '00:00 PM' : null,
                    readOnly: true,
                    prefixIcon: Icons.access_time,
                    onTap: () {
                      setState(() {
                        isStartTime = false;
                        showTimePicker = true;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            // Custom Time Picker
            if (showTimePicker)
              CustomTimePicker(
                isStart: isStartTime,
                onCancel: () {
                  setState(() {
                    if (isStartTime) {
                      startTimeController.text = "";
                      controller.updatePackageForm(
                        widget.index,
                        'startTime',
                        '',
                      );
                    } else {
                      endTimeController.text = "";
                      controller.updatePackageForm(widget.index, 'endTime', '');
                    }
                    showTimePicker = false;
                  });
                },
                onTimeSelected: (time) {
                  setState(() {
                    if (isStartTime) {
                      startTimeController.text = time;
                      controller.updatePackageForm(
                        widget.index,
                        'startTime',
                        time,
                      );
                    } else {
                      endTimeController.text = time;
                      controller.updatePackageForm(
                        widget.index,
                        'endTime',
                        time,
                      );
                    }
                    showTimePicker = false;
                  });
                },
              ),

            const SizedBox(height: 16),
            const Text(
              "Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Package-Specific Fields
            ..._buildPackageSpecificFields(packageTitle, form, controller),

            const SizedBox(height: 32),

            // Add-Ons Section
            _buildExpandableSection(
              title: 'Choose Free Item',
              isSelected: form['freeAddOn'] != null,
              onTap: () => controller.toggleAddOn(widget.index, 'free'),
            ),
            const SizedBox(height: 16),

            _buildExpandableSection(
              title: 'Extra Add-Ons (Extra Charged)',
              isSelected: form['extraAddOn'] != null,
              onTap: () => controller.toggleAddOn(widget.index, 'extra'),
            ),
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
                        color:
                            controller.acceptTerms.value
                                ? const Color(0xFF4A6CF7)
                                : Colors.white,
                        border: Border.all(
                          color:
                              controller.acceptTerms.value
                                  ? const Color(0xFF4A6CF7)
                                  : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child:
                          controller.acceptTerms.value
                              ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          TextSpan(text: 'I accept the '),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: Color(0xFF4A6CF7),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: ' and agree to the '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF4A6CF7),
                              decoration: TextDecoration.underline,
                            ),
                          ),
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

  List<Widget> _buildPackageSpecificFields(
    String packageTitle,
    Map<String, dynamic> form,
    BookingFormController controller,
  ) {
    switch (packageTitle) {
      case 'Cuteness':
        return [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonFormField<String>(
              value: form['babyInfo'],
              decoration: const InputDecoration(
                labelText: "What is your baby's age and gender?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: const [
                DropdownMenuItem(
                  value: '0-3M Boy',
                  child: Text('0-3 Months Boy'),
                ),
                DropdownMenuItem(
                  value: '0-3M Girl',
                  child: Text('0-3 Months Girl'),
                ),
                DropdownMenuItem(
                  value: '3-6M Boy',
                  child: Text('3-6 Months Boy'),
                ),
                DropdownMenuItem(
                  value: '3-6M Girl',
                  child: Text('3-6 Months Girl'),
                ),
                DropdownMenuItem(value: '6-12M', child: Text('6-12 Months')),
              ],
              onChanged:
                  (val) => controller.updatePackageForm(
                    widget.index,
                    'babyInfo',
                    val,
                  ),
            ),
          ),
        ];

      case 'Moments':
        return [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonFormField<String>(
              value: form['theme'],
              decoration: const InputDecoration(
                labelText:
                    "Do you have a specific theme or color palette in mind for the shoot?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: const [
                DropdownMenuItem(
                  value: 'Pastel Colors',
                  child: Text('Pastel Colors'),
                ),
                DropdownMenuItem(
                  value: 'Vibrant Colors',
                  child: Text('Vibrant Colors'),
                ),
                DropdownMenuItem(
                  value: 'Minimal/Clean',
                  child: Text('Minimal/Clean'),
                ),
                DropdownMenuItem(
                  value: 'Natural/Earthy',
                  child: Text('Natural/Earthy'),
                ),
                DropdownMenuItem(
                  value: 'No Preference',
                  child: Text('No Preference'),
                ),
              ],
              onChanged:
                  (val) =>
                      controller.updatePackageForm(widget.index, 'theme', val),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonFormField<String>(
              value: form['outfitChanges'],
              decoration: const InputDecoration(
                labelText: "Number of Outfit Changes",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: const [
                DropdownMenuItem(value: '1', child: Text('1 Outfit')),
                DropdownMenuItem(value: '2', child: Text('2 Outfits')),
                DropdownMenuItem(value: '3', child: Text('3 Outfits')),
              ],
              onChanged:
                  (val) => controller.updatePackageForm(
                    widget.index,
                    'outfitChanges',
                    val,
                  ),
            ),
          ),
        ];

      case 'Wonders':
        return [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonFormField<String>(
              value: form['locationPreference'],
              decoration: const InputDecoration(
                labelText: "Preferred Outdoor Location",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: const [
                DropdownMenuItem(value: 'Park', child: Text('Park')),
                DropdownMenuItem(value: 'Beach', child: Text('Beach')),
                DropdownMenuItem(value: 'Garden', child: Text('Garden')),
                DropdownMenuItem(
                  value: 'No Preference',
                  child: Text('No Preference'),
                ),
              ],
              onChanged:
                  (val) => controller.updatePackageForm(
                    widget.index,
                    'locationPreference',
                    val,
                  ),
            ),
          ),
        ];

      default:
        return [];
    }
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          dashPattern: [10, 5],
          strokeWidth: 2,
          color: const Color.fromARGB(255, 157, 155, 155),
          radius: const Radius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? const Color(0xFF4A6CF7) : Colors.black87,
                ),
              ),
              Icon(
                isSelected ? Icons.remove : Icons.add,
                color:
                    isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
