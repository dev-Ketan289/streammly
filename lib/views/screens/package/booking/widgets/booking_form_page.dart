import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:streammly/models/package/slots_model.dart';
import 'package:streammly/services/input_decoration.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/booking/widgets/custom_time_picker.dart';
import '../../../../../controllers/booking_form_controller.dart';
import '../../../../../services/route_helper.dart';
import '../../../common/widgets/custom_textfield.dart' show CustomTextField;
import 'extra_add_on.dart';
import 'free_add_on.dart';

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
  late TextEditingController selectedTimingController;
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
    selectedTimingController = TextEditingController(
      text:
          form['startTime'] != null && form['endTime'] != null
              ? "${form['startTime']} - ${form['endTime']}"
              : '',
    );

    final extraQuestions =
        widget.package['extraQuestions'] ??
        widget.package['packageextra_questions'] ??
        [];
    for (var question in extraQuestions) {
      final qid = question['id'].toString();
      final uniqueKey = "${widget.index}_$qid";
      final answer = form['extraAnswers']?[uniqueKey] ?? '';
      _extraQuestionControllers[uniqueKey] = TextEditingController(
        text: answer,
      );
    }
  }

  @override
  void dispose() {
    startTimeController.dispose();
    endTimeController.dispose();
    dateTimeController.dispose();
    selectedTimingController.dispose();
    for (final controller in _extraQuestionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextEditingController studioAddController = TextEditingController(
      text:
          widget.package['address'] ??
          '305/A, Navneet Building, Saivihar Road, Bhandup (W), Mumbai 400078.',
    );
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
      if (selectedTimingController.text !=
          (form['startTime'] != null && form['endTime'] != null
              ? "${form['startTime']} - ${form['endTime']}"
              : '')) {
        selectedTimingController.text =
            form['startTime'] != null && form['endTime'] != null
                ? "${form['startTime']} - ${form['endTime']}"
                : '';
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
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Studio Address *',
              controller: studioAddController,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Date of Shoot *',
              controller: dateTimeController,
              hintText: form['date']?.isEmpty ?? true ? 'Select Date' : null,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 2)),
                  firstDate: DateTime.now().add(const Duration(days: 2)),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final formatted =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                  log(formatted);
                  controller.updatePackageForm(widget.index, 'date', formatted);
                  controller.updatePackageForm(widget.index, 'startTime', '');
                  controller.updatePackageForm(widget.index, 'endTime', '');
                  selectedTimingController.text = '';
                  try {
                    await controller.fetchAvailableSlots(
                      companyId: widget.package["company_id"].toString(),
                      date: formatted,
                      studioId: widget.package["studio_id"].toString(),
                      typeId: widget.package["typeId"].toString(),
                    );
                  } catch (e) {
                    Get.snackbar(
                      'Error',
                      'Failed to fetch available slots: $e',
                    );
                  }
                }
              },
              prefixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: selectedTimingController,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Select Time Slot';
                }
                return null;
              },
              onTap: () {
                print('TextFormField tapped');
                final slots = Get.find<BookingController>().startTime;
                log('Slots: $slots');
                TimeOfDay? startTime;
                TimeOfDay? endTime;
                try {
                  log("$startTime", name: "fgngjn");
                  startTime =
                      form['startTime'] != null
                          ? parseTimeOfDay(form['startTime'])
                          : null;

                  endTime =
                      form['endTime'] != null
                          ? parseTimeOfDay(form['endTime'])
                          : null;
                } catch (e) {
                  Fluttertoast.showToast(
                    msg:
                        "Invalid time format in previous selection. Please select a new time slot.",
                    toastLength: Toast.LENGTH_LONG,
                  );
                  controller.updatePackageForm(widget.index, 'startTime', '');
                  controller.updatePackageForm(widget.index, 'endTime', '');
                  selectedTimingController.text = '';
                }
                showTimeSlotSelector(
                  context: context,
                  slots: slots,
                  packageHours: widget.package["hours"]?.toString() ?? "1",
                  index: widget.index,
                  startTime: startTime,
                  endTime: endTime,
                  onSlotSelected: (TimeOfDay? startTime, TimeOfDay? endTime) {
                    log(
                      'Selected: ${startTime?.format(context)} - ${endTime?.format(context)}',
                    );
                    if (startTime != null && endTime != null) {
                      final formattedTime =
                          "${startTime.format(context)} - ${endTime.format(context)}";
                      selectedTimingController.text = formattedTime;
                      controller.updatePackageForm(
                        widget.index,
                        'startTime',
                        startTime.format(context),
                      );
                      controller.updatePackageForm(
                        widget.index,
                        'endTime',
                        endTime.format(context),
                      );
                    }
                  },
                );
                log(widget.package["hours"]?.toString() ?? "1");
              },
              decoration: CustomDecoration.inputDecoration(
                label: "Select Time Slot",
                floating: true,
                suffix: const Icon(Icons.arrow_drop_down),
                borderRadius: 6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Questions",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildExtraQuestions(controller),
            const SizedBox(height: 32),
            _buildExpandableSection(
              title: 'Choose Free Item',
              isSelected: form['freeAddOn'] != null,
              onTap: () async {
                final packageId =
                    widget.package['packageId'] ?? widget.package['id'];
                final result = await Navigator.push(
                  context,
                  getCustomRoute(child: FreeItemsPage(packageId: packageId)),
                );
                if (result != null) {
                  controller.updatePackageForm(
                    widget.index,
                    'freeAddOn',
                    result,
                  );
                }
              },
            ),
            if (form['freeAddOn'] != null) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Add-Ons',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xff2864A6),
                            ),
                            onPressed: () async {
                              final packageId =
                                  widget.package['packageId'] ??
                                  widget.package['id'];
                              final result = await Navigator.push(
                                context,
                                getCustomRoute(
                                  child: FreeItemsPage(packageId: packageId),
                                ),
                              );
                              if (result != null) {
                                controller.updatePackageForm(
                                  widget.index,
                                  'freeAddOn',
                                  result,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              controller.updatePackageForm(
                                widget.index,
                                'freeAddOn',
                                null,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    form['freeAddOn']['mainTitle'] ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Builder(
                            builder: (_) {
                              final img = form['freeAddOn']['cover_image'];
                              if (img != null && img.isNotEmpty) {
                                final url = img;
                                return Image.network(
                                  url,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (c, o, e) => Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.broken_image),
                                      ),
                                );
                              }
                              return Container(
                                height: 50,
                                width: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.image),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                form['freeAddOn']['title'] ?? '',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                form['freeAddOn']['description'] ?? '',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Shoot Duration : 1',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            _buildExpandableSection(
              title: 'Extra Add-Ons (Extra Charged)',
              isSelected:
                  (form['extraAddOn'] is List &&
                      (form['extraAddOn'] as List).isNotEmpty),
              onTap: () async {
                final packageId =
                    widget.package['packageId'] ?? widget.package['id'];
                final studioId =
                    widget.package['studioId'] ?? widget.package['studio_id'];
                final result = await Navigator.push(
                  context,
                  getCustomRoute(
                    child: ExtraAddOnsPage(
                      packageId: packageId,
                      studioId: studioId,
                    ),
                  ),
                );
                if (result != null && result is List) {
                  controller.updatePackageForm(
                    widget.index,
                    'extraAddOn',
                    result,
                  );
                }
              },
            ),
            if (form['extraAddOn'] is List &&
                (form['extraAddOn'] as List).isNotEmpty) ...[
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selected Add-Ons',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xff2864A6),
                            ),
                            onPressed: () async {
                              final packageId =
                                  widget.package['packageId'] ??
                                  widget.package['id'];
                              final studioId = widget.package['studioId'];
                              final result = await Navigator.push(
                                context,
                                getCustomRoute(
                                  child: ExtraAddOnsPage(
                                    packageId: packageId,
                                    studioId: studioId,
                                  ),
                                ),
                              );
                              if (result != null && result is List) {
                                controller.updatePackageForm(
                                  widget.index,
                                  'extraAddOn',
                                  result,
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: theme.colorScheme.error,
                            ),
                            onPressed: () {
                              controller.updatePackageForm(
                                widget.index,
                                'extraAddOn',
                                [],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    form['extraAddOnMainTitle'] ?? 'Extra Add-Ons',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...form['extraAddOn'].map<Widget>((item) {
                    final String? imageUrl = item['image'];

                    Widget imageWidget;
                    if (imageUrl != null && imageUrl.isNotEmpty) {
                      final uri = Uri.tryParse(imageUrl);
                      if (uri != null && uri.isAbsolute) {
                        imageWidget = Image.network(
                          imageUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 50,
                                width: 50,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image),
                              ),
                        );
                      } else {
                        final fullUrl = imageUrl;
                        imageWidget = Image.network(
                          fullUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                height: 50,
                                width: 50,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.broken_image),
                              ),
                        );
                      }
                    } else {
                      imageWidget = Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: imageWidget,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title'] ?? '',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['description'] ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Shoot Duration : ${item['duration'] ?? 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (item['price'] != null)
                                  Text(
                                    'Price: Rs ${item['price']}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
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
                      color:
                          form['termsAccepted'] == true
                              ? theme.colorScheme.primary
                              : Colors.white,
                      border: Border.all(
                        color:
                            form['termsAccepted'] == true
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child:
                        form['termsAccepted'] == true
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
                    text: TextSpan(
                      style: theme.textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: 'I accept the '),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Get.defaultDialog(
                                    title: 'Terms and Conditions',
                                    content: SingleChildScrollView(
                                      child: Text(
                                        widget.package['termsAndCondition'] ??
                                            'No terms found.',
                                      ),
                                    ),
                                  );
                                },
                        ),
                        const TextSpan(text: ' and agree to the '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
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
    final extraQuestions =
        widget.package['extraQuestions'] ??
        widget.package['packageextra_questions'] ??
        [];
    final form = controller.packageFormsData[widget.index] ?? {};
    List<Widget> fields = [];

    for (var question in extraQuestions) {
      final qid = question['id'].toString();
      final uniqueKey = "${widget.index}_$qid";
      final label = question['question'] ?? 'Question';
      final type = question['question_type'] ?? 'Text';
      final answer = form['extraAnswers']?[uniqueKey] ?? '';

      final ctrl = _extraQuestionControllers.putIfAbsent(
        uniqueKey,
        () => TextEditingController(),
      );

      if (ctrl.text != answer) {
        ctrl.text = answer;
      }

      fields.add(const SizedBox(height: 16));
      if (type == 'Date Picker') {
        fields.add(
          CustomTextField(
            labelText: label,
            controller: ctrl,
            readOnly: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date';
              }
              return null;
            },
            prefixIcon: Icons.calendar_today,
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                final formatted =
                    "${picked.day}-${picked.month}-${picked.year}";
                ctrl.text = formatted;
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
                    controller: ctrl,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                    prefixIcon: Icons.access_time,
                    onTap: () => setState(() => showTime = true),
                  ),
                  if (showTime)
                    CustomTimePicker(
                      isStart: true,
                      onCancel: () => setState(() => showTime = false),
                      onTimeSelected: (time) {
                        ctrl.text = time;
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
        fields.add(
          CustomTextField(
            labelText: label,
            controller: ctrl,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            onChanged:
                (val) => controller.updateExtraAnswer(widget.index, qid, val),
          ),
        );
      }
    }
    return fields;
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: const RoundedRectDottedBorderOptions(
          dashPattern: [10, 5],
          strokeWidth: 2,
          color: Color.fromARGB(255, 157, 155, 155),
          radius: Radius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color:
                      isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                ),
              ),
              Icon(
                isSelected ? Icons.remove : Icons.add,
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.iconTheme.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSelectedSlotSheet(BuildContext context, Slot selectedSlot) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selected Slot',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    '${selectedSlot.startTime} - ${selectedSlot.endTime}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('OK'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
  );
}

TimeOfDay? parseTimeOfDay(String? timeString) {
  if (timeString == null || timeString.isEmpty) return null;
  try {
    // Split the time string into time and period (e.g., "10:00 AM" -> ["10:00", "AM"])
    final parts = timeString.trim().split(' ');
    if (parts.length != 2) throw const FormatException('Invalid time format');

    final timeParts = parts[0].split(':');
    if (timeParts.length < 2)
      throw const FormatException('Invalid time format');

    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final period = parts[1].toUpperCase();

    // Convert to 24-hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  } catch (e) {
    log('Error parsing time: $timeString, $e');
    throw const FormatException('Invalid time format');
  }
}

void showTimeSlotSelector({
  required BuildContext context,
  required List<TimeOfDay?> slots,
  required String packageHours,
  required int index,
  required TimeOfDay? startTime,
  required TimeOfDay? endTime,
  required Function(TimeOfDay? startTime, TimeOfDay? endTime) onSlotSelected,
}) {
  showModalBottomSheet(
    
    context: context,
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return TimeSlotSelecter(
        context: context,
        slots: slots,
        packageHours: packageHours,
        index: index,
        onSlotSelected: onSlotSelected,
      );
    },
  );
}

class TimeSlotSelecter extends StatefulWidget {
  final BuildContext context;
  final List<TimeOfDay?> slots;
  final String packageHours;
  final int index;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Function(TimeOfDay? startTime, TimeOfDay? endTime) onSlotSelected;
  const TimeSlotSelecter({
    super.key,
    required this.context,
    required this.slots,
    required this.packageHours,
    required this.index,
    this.startTime,
    this.endTime,
    required this.onSlotSelected,
  });

  @override
  State<TimeSlotSelecter> createState() => _TimeSlotSelecterState();
}

class _TimeSlotSelecterState extends State<TimeSlotSelecter> {
  TimeOfDay? tempStartTime;
  TimeOfDay? tempEndTime;
  int maxHours = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tempStartTime = widget.startTime;
      tempEndTime = widget.endTime;
      maxHours = int.tryParse(widget.packageHours) ?? 1;
    });
  }

  void onTimeSlotTap(TimeOfDay timeSlot) {
    log(
      'Tapped slot: ${timeSlot.format(context)} , $tempStartTime , $tempStartTime, ${widget.startTime}, ${widget.endTime}',
    );

    if (tempStartTime == timeSlot || tempEndTime == timeSlot) {
      log("one");
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: "Start time and end time cannot be the same.",
        toastLength: Toast.LENGTH_LONG,
      );
      setState(() {
        log('Updating state: start=$tempStartTime, end=$tempEndTime');
        tempStartTime = null;
        tempEndTime = null;
      });
    } else if (tempStartTime == null) {
      log("two");

      setState(() {
        tempStartTime = timeSlot;
      });
    } else if (tempEndTime == null) {
      log("three");

      if (TimeCalculations.isTimeBeforeOrEqual(timeSlot, tempStartTime!)) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "End time must be after start time.",
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          tempEndTime = null;
          tempStartTime = null;
        });
      } else {
        setState(() {
          tempEndTime = timeSlot;
        });
      }
    } else {
      log("five ${timeSlot.toString()}");
      setState(() {
        tempStartTime = timeSlot;
        tempEndTime = null;
      });
    }

    if (tempStartTime != null && tempEndTime != null) {
      final duration = int.parse(
        TimeCalculations.calculateDuration(tempStartTime!, tempEndTime!),
      );
      final durationHours = (duration / 60).ceil();
      if (durationHours > maxHours) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg:
              "Selected duration ($durationHours hours) exceeds package limit ($maxHours hours). Extra charges will apply.",
          toastLength: Toast.LENGTH_LONG,
        );
      } else if (durationHours < maxHours) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
          msg: "Please select minimum $maxHours hours",
          toastLength: Toast.LENGTH_LONG,
        );
        setState(() {
          tempStartTime = null;
          tempEndTime = null;
        });
      } else {
        log("$tempStartTime , $tempEndTime");
        widget.onSlotSelected(tempStartTime, tempEndTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: GetBuilder<BookingController>(
        builder: (bookingController) {
          if (bookingController.startTime.isEmpty) {
            return const Center(
              child: Text(
                'No time slots available for the selected date.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'Select Time Slot',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (bookingController.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(80),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    Expanded(
                      
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: widget.slots.length,
                          itemBuilder: (context, slotIndex) {
                            final timeSlot = widget.slots[slotIndex];
                            if (timeSlot == null) {
                              return const SizedBox.shrink();
                            }

                            final isSelected =
                                timeSlot == tempStartTime ||
                                timeSlot == tempEndTime;
                            final isInRange =
                                tempStartTime != null &&
                                tempEndTime != null &&
                                TimeCalculations.isTimeBeforeOrEqual(
                                  timeSlot,
                                  tempEndTime!,
                                ) &&
                                TimeCalculations.isTimeAfterOrEqual(
                                  timeSlot,
                                  tempStartTime!,
                                );

                            return GestureDetector(
                              onTap: () {
                                log("tapped${timeSlot.toString()}");
                                onTimeSlotTap(timeSlot);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  
                                  color:
                                      isSelected
                                          ? primaryColor
                                          : isInRange
                                          ? Colors.blue[100]
                                          : Colors.grey.shade300,
                                          
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Colors.blue.shade100
                                            : Colors.grey.shade300,
                                    width: isSelected ? 4.0 : 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.10),
                                      offset: const Offset(0, 1),
                                      blurRadius: 1,
                                    ),
                                    
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    timeSlot.format(context),
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (!bookingController.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    tempStartTime != null
                                        ? Colors.blue[50]
                                        : Colors.white,
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "START TIME",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          tempStartTime != null
                                              ? Colors.blue[700]
                                              : Colors.grey,
                                              fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const Divider(),
                                  Text(
                                    tempStartTime?.format(context) ??
                                        'Select start time',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          tempStartTime != null
                                              ? Colors.black87
                                              : Colors.grey,
                                              fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    tempEndTime != null
                                        ? Colors.blue[50]
                                        : Colors.white,
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "END TIME",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          tempEndTime != null
                                              ? Colors.blue[700]
                                              : Colors.grey,
                                              fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  const Divider(),
                                  Text(
                                    tempEndTime?.format(context) ??
                                        'Select end time',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelLarge?.copyWith(
                                      color:
                                          tempEndTime != null
                                              ? Colors.black87
                                              : Colors.grey,
                                              fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (tempStartTime != null && tempEndTime != null)
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${(int.parse(TimeCalculations.calculateDuration(tempStartTime!, tempEndTime!)) / 60).ceil()} Hours',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    
                    onPressed:
                        tempStartTime != null && tempEndTime != null
                            ? () {
                              widget.onSlotSelected(tempStartTime, tempEndTime);
                              Navigator.pop(context);
                            }
                            : null,
                            
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 50),
                      
                      backgroundColor:
                          tempStartTime != null && tempEndTime != null
                              ? primaryColor
                              : Colors.grey.shade400,
                      foregroundColor: Colors.white,
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      padding: const EdgeInsets.symmetric(
                        
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),

                    child: const Text('Confirm'),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class TimeCalculations {
  static String calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final durationMinutes = endMinutes - startMinutes;
    return durationMinutes.toString();
  }

  static bool isTimeAfterOrEqual(TimeOfDay time, TimeOfDay reference) {
    return time.hour > reference.hour ||
        (time.hour == reference.hour && time.minute >= reference.minute);
  }

  static bool isTimeBeforeOrEqual(TimeOfDay time, TimeOfDay reference) {
    return time.hour < reference.hour ||
        (time.hour == reference.hour && time.minute <= reference.minute);
  }

  static bool isTimeInBetween(
    TimeOfDay time,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) {
    return time.hour >= startTime.hour &&
        time.hour <= endTime.hour &&
        ((time.hour == startTime.hour && time.minute >= startTime.minute) ||
            (time.hour == endTime.hour && time.minute <= endTime.minute) ||
            (time.hour > startTime.hour && time.hour < endTime.hour));
  }
}

List<TimeOfDay?> convertSlots(List<dynamic> apiSlots) {
  return apiSlots.map((slot) {
    if (slot['startTime'] != null) {
      final parts = slot['startTime'].split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    }
    return null;
  }).toList();
}
