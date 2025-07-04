import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
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
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController dateTimeController;
  bool isStartTime = true;
  bool showTimePicker = false;

  final Map<String, TextEditingController> _extraQuestionControllers = {};

  @override
  void initState() {
    super.initState();
    final controller = Get.find<BookingController>();
    final form = controller.packageFormsData[widget.index] ?? {};

    startTimeController = TextEditingController(text: form['startTime'] ?? '');
    endTimeController = TextEditingController(text: form['endTime'] ?? '');
    dateTimeController = TextEditingController(text: form['date'] ?? '');

    final extraQuestions = widget.package['extraQuestions'] ?? widget.package['packageextra_questions'] ?? [];
    for (var question in extraQuestions) {
      final id = "${widget.index}_${question['id']}";
      final answer = form['extraAnswers']?[question['id'].toString()] ?? '';
      _extraQuestionControllers[id] = TextEditingController(text: answer);
    }
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    dateTimeController.dispose();
    for (final controller in _extraQuestionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController studioAddController = TextEditingController(text: widget.package['address'] ?? '305/A, Navneet Building, Saivihar Road, Bhandup (W), Mumbai 400078.');
    final controller = Get.find<BookingController>();
    final packageTitle = widget.package['title'] as String;

    return Obx(() {
      final form = controller.packageFormsData[widget.index] ?? {};

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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$packageTitle Booking Schedule", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 20),
            CustomTextField(labelText: 'Studio Address *', controller: studioAddController, readOnly: true),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Date of Shoot *',
              controller: dateTimeController,
              hintText: form['date']?.isEmpty ?? true ? 'Select Date' : null,
              readOnly: true,
              onTap: () async {
                final selectedDate = await controller.selectDate(widget.index, context);
                if (selectedDate.isNotEmpty) {
                  dateTimeController.text = selectedDate;
                }
              },
              prefixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: startTimeController,
                    labelText: 'Start Time *',
                    hintText: form['startTime']?.isEmpty ?? true ? '00:00 AM' : null,
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
                    hintText: form['endTime']?.isEmpty ?? true ? '00:00 PM' : null,
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
            if (showTimePicker)
              CustomTimePicker(
                isStart: isStartTime,
                onCancel: () {
                  setState(() {
                    if (isStartTime) {
                      startTimeController.text = "";
                      controller.updatePackageForm(widget.index, 'startTime', '');
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
                      controller.updatePackageForm(widget.index, 'startTime', time);
                    } else {
                      endTimeController.text = time;
                      controller.updatePackageForm(widget.index, 'endTime', time);
                    }
                    showTimePicker = false;
                  });
                },
              ),
            const SizedBox(height: 16),
            const Text("Questions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 16),
            ..._buildExtraQuestions(controller),
            const SizedBox(height: 32),
            _buildExpandableSection(title: 'Choose Free Item', isSelected: form['freeAddOn'] != null, onTap: () => controller.toggleAddOn(widget.index, 'free')),
            const SizedBox(height: 16),
            _buildExpandableSection(title: 'Extra Add-Ons (Extra Charged)', isSelected: form['extraAddOn'] != null, onTap: () => controller.toggleAddOn(widget.index, 'extra')),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => controller.togglePackageTerms(widget.index),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: form['termsAccepted'] == true ? const Color(0xFF4A6CF7) : Colors.white,
                      border: Border.all(color: form['termsAccepted'] == true ? const Color(0xFF4A6CF7) : Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: form['termsAccepted'] == true ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                      children: [
                        const TextSpan(text: 'I accept the '),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: const TextStyle(color: Color(0xFF4A6CF7), decoration: TextDecoration.underline),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.defaultDialog(
                                    title: 'Terms and Conditions',
                                    content: SingleChildScrollView(child: Text(widget.package['termsAndCondition'] ?? 'No terms found.')),
                                  );
                                },
                        ),
                        const TextSpan(text: ' and agree to the '),
                        const TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFF4A6CF7), decoration: TextDecoration.underline)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildExtraQuestions(BookingController controller) {
    final extraQuestions = widget.package['extraQuestions'] ?? widget.package['packageextra_questions'] ?? [];
    List<Widget> fields = [];

    for (var question in extraQuestions) {
      final id = "${widget.index}_${question['id']}";
      final qid = question['id'].toString();
      final label = question['question'] ?? 'Question';
      final type = question['question_type'] ?? 'Text';

      fields.add(const SizedBox(height: 16));

      if (type == 'Date Picker') {
        fields.add(
          CustomTextField(
            labelText: label,
            controller: _extraQuestionControllers[id],
            readOnly: true,
            prefixIcon: Icons.calendar_today,
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (picked != null) {
                final formatted = "${picked.day}-${picked.month}-${picked.year}";
                _extraQuestionControllers[id]?.text = formatted;
                controller.updateExtraAnswer(widget.index, qid, formatted);
              }
            },
          ),
        );
      } else if (type == 'Time Picker') {
        fields.add(
          StatefulBuilder(
            builder: (context, setState) {
              bool showTime = false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: label,
                    controller: _extraQuestionControllers[id],
                    readOnly: true,
                    prefixIcon: Icons.access_time,
                    onTap: () => setState(() => showTime = true),
                  ),
                  if (showTime)
                    CustomTimePicker(
                      isStart: true,
                      onCancel: () => setState(() => showTime = false),
                      onTimeSelected: (time) {
                        _extraQuestionControllers[id]?.text = time;
                        controller.updateExtraAnswer(widget.index, qid, time);
                        setState(() => showTime = false);
                      },
                    ),
                ],
              );
            },
          ),
        );
      } else {
        fields.add(CustomTextField(labelText: label, controller: _extraQuestionControllers[id], onChanged: (val) => controller.updateExtraAnswer(widget.index, qid, val)));
      }
    }

    return fields;
  }

  Widget _buildExpandableSection({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: const RoundedRectDottedBorderOptions(dashPattern: [10, 5], strokeWidth: 2, color: Color.fromARGB(255, 157, 155, 155), radius: Radius.circular(10)),
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
