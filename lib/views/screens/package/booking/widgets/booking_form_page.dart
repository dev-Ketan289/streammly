import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/models/package/slots_model.dart';
import 'package:streammly/services/extensions.dart';
import 'package:streammly/services/input_decoration.dart';
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
  final TextEditingController selectedTimingController = TextEditingController();
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
    startTimeController.dispose();
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
              onTap: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(
                    Duration(days: 2),
                  ), // Set to tomorrow
                  firstDate: DateTime.now().add(
                    Duration(days: 2),
                  ), // Prevent selecting today
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  final formatted =
                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.date}";

                  log(formatted);
                  controller.updatePackageForm(widget.index, 'date', formatted);
                  dateTimeController.text = formatted;
                  Get.find<BookingController>().fetchAvailableSlots(
                    companyId: widget.package["company_id"].toString(),
                    date: formatted,
                    studioId: widget.package["studio_id"].toString(),
                    typeId: widget.package["typeId"].toString(),
                  );
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
    final slots = Get.find<BookingController>().timeSlots;
    showTimeSlotSelector(
      context: context,
      slots: slots,
      onSlotSelected: (selectedSlot) {
        final formatted = "${selectedSlot.startTime} - ${selectedSlot.endTime}";
        selectedTimingController.text = formatted;

        controller.updatePackageForm(
          widget.index,
          'startTime',
          selectedSlot.startTime,
        );
        controller.updatePackageForm(
          widget.index,
          'endTime',
          selectedSlot.endTime,
        );
      },
    );
  },
  decoration: CustomDecoration.inputDecoration(
    label: "Select Time Slot",
    floating: true,
    suffix: const Icon(Icons.arrow_drop_down),
    borderRadius: 6,
  ),
),

            // Row(
            //   children: [
            //     Expanded(
            //       child: CustomTextField(
            //         controller: startTimeController,
            //         labelText: 'Start Time *',
            //         hintText:
            //             form['startTime']?.isEmpty ?? true ? '09:00 AM' : null,
            //         readOnly: true,  
            //         prefixIcon: Icons.access_time,
            //         onTap: () {
            //           setState(() {
            //             isStartTime = true;
            //             showTimePicker = true;
            //           });
            //         },
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: CustomTextField(
            //         controller: endTimeController,
            //         labelText: 'End Time *',
            //         hintText:
            //             form['endTime']?.isEmpty ?? true ? '07:00 PM' : null,
            //         readOnly: true,
            //         prefixIcon: Icons.access_time,
            //         onTap: () {
            //           setState(() {
            //             isStartTime = false;
            //             showTimePicker = true;
            //           });
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // if (showTimePicker)
            //   CustomTimePicker(
            //     isStart: isStartTime,
                
            //     onCancel: () {
            //       setState(() {
            //         if (isStartTime) {
            //           startTimeController.text = "";
            //           controller.updatePackageForm(
            //             widget.index,
            //             'startTime',
            //             '',
            //           );
            //         } else {
            //           endTimeController.text = "";
            //           controller.updatePackageForm(widget.index, 'endTime', '');
            //         }
            //         showTimePicker = false;
            //       });
            //     },
            //     onTimeSelected: (time) {
            //       log("$time");
            //       setState(() {
            //         if (isStartTime) {
            //           startTimeController.text = time;
            //           controller.updatePackageForm(
            //             widget.index,
            //             'startTime',
            //             time,
            //           );
            //         } else {
            //           endTimeController.text = time;
            //           controller.updatePackageForm(
            //             widget.index,
            //             'endTime',
            //             time,
            //           );
            //         }
            //         showTimePicker = false;
            //       });
            //     },
            //   ),
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
                    widget.package['packageId'] ??
                    widget.package['id']; // adjust according to your data
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
                            icon: Icon(
                              Icons.edit,
                              color: const Color(0xff2864A6),
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
                    form['freeAddOn']['mainTitle'] ?? '', // Dynamic main title
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
                            icon: Icon(
                              Icons.edit,
                              color: const Color(0xff2864A6),
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
                      // If no image, show placeholder container
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
                            ? Icon(Icons.check, color: Colors.white, size: 14)
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

      // >>> SAFELY GET (or create) THE CONTROLLER <<<
      final ctrl = _extraQuestionControllers.putIfAbsent(
        uniqueKey,
        () => TextEditingController(),
      );

      // keep in sync
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
    builder: (_) => Padding(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    ),
  );
}

void showTimeSlotSelector({
  required BuildContext context,
  required List<Slot> slots,
  required Function(Slot) onSlotSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      final availableSlots = slots.where((s) => s.isAvailable).toList();

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select a Time Slot',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (availableSlots.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "No available slots",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
            else
              SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: availableSlots.map((slot) {
                    final time = "${slot.startTime} - ${slot.endTime}";
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        shadowColor: Colors.black26,
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        onSlotSelected(slot);
                        Navigator.pop(context);
                      },
                      child: Text(time),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}