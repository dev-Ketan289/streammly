import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/category_controller.dart';
import 'package:streammly/views/screens/bundle/bundle_categories_page.dart';

import '../package/booking/widgets/custom_time_picker.dart';

class BundleInformation extends StatefulWidget {
  const BundleInformation({super.key});

  @override
  State<BundleInformation> createState() => _BundleInformationState();
}

class _BundleInformationState extends State<BundleInformation> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? selectedEventType;
  bool isEventDropdownOpen = false;

  DateTime selectedDate = DateTime.now();
  String? startTime = "08:00 AM";
  String? endTime = "00:00 PM";
  bool showTimePicker = false;
  bool isStartTime = true;

  final CategoryController _categoryController = Get.find<CategoryController>();
  List<String> selectedCategories = [];
  bool isCategoryDropdownOpen = false;

  double radius = 0.0;

  void _pickDate() async {
    final picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _showTimePicker(bool isStart) {
    setState(() {
      isStartTime = isStart;
      showTimePicker = true;
    });
  }

  void _onTimeSelected(String value) {
    setState(() {
      if (isStartTime) {
        startTime = value;
      } else {
        endTime = value;
      }
      showTimePicker = false;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  void _toggleSelectAll(bool value) {
    setState(() {
      selectedCategories = value ? List.from(_categoryController.categories.map((e) => e.title)) : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FF), // light background
      appBar: AppBar(
        title: Text('Bundle Information', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: const Color(0xFF2E5CDA), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text('Please Fill this following Details', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),

              /// EVENT TYPE
              GestureDetector(
                onTap: () => setState(() => isEventDropdownOpen = !isEventDropdownOpen),
                child: _styledDropdownContainer(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedEventType ?? "Event Type *",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: selectedEventType == null ? Colors.grey : Colors.black),
                        ),
                      ),
                      Icon(isEventDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),
              if (isEventDropdownOpen)
                _dropdownBox(
                  children:
                      ['Birthday', 'Wedding', 'Engagement']
                          .map(
                            (event) => ListTile(
                              title: Text(event, style: Theme.of(context).textTheme.bodyMedium),
                              onTap: () {
                                setState(() {
                                  selectedEventType = event;
                                  isEventDropdownOpen = false;
                                });
                              },
                            ),
                          )
                          .toList(),
                ),

              _buildTextField('Event Name *', eventNameController),

              _buildTextField(
                'Event Date *',
                TextEditingController(text: "${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}"),
                readOnly: true,
                onTap: _pickDate,
                suffixIcon: Icons.calendar_today,
              ),

              _buildTextField('Location *', locationController, hint: 'Room No, Building Name, Area, City, Pincode', suffixIcon: Icons.location_on),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(child: _buildTextField('Start Time *', TextEditingController(text: startTime), readOnly: true, onTap: () => _showTimePicker(true))),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('End Time *', TextEditingController(text: endTime), readOnly: true, onTap: () => _showTimePicker(false))),
                ],
              ),
              if (showTimePicker) CustomTimePicker(isStart: isStartTime, onCancel: () => setState(() => showTimePicker = false), onTimeSelected: _onTimeSelected),

              const SizedBox(height: 20),

              /// CATEGORY
              GetBuilder<CategoryController>(
                builder: (controller) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => isCategoryDropdownOpen = !isCategoryDropdownOpen),
                        child: _styledDropdownContainer(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedCategories.isEmpty ? "Category *" : selectedCategories.join(', '),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: selectedCategories.isEmpty ? Colors.grey : Colors.black),
                                ),
                              ),
                              Icon(isCategoryDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      if (isCategoryDropdownOpen)
                        _dropdownBox(
                          children: [
                            CheckboxListTile(
                              title: Text("All", style: Theme.of(context).textTheme.bodyMedium),
                              value: selectedCategories.length == controller.categories.length,
                              onChanged: (val) => _toggleSelectAll(val ?? false),
                              controlAffinity: ListTileControlAffinity.trailing,
                              contentPadding: EdgeInsets.zero,
                            ),
                            const Divider(),
                            ...controller.categories.map((cat) {
                              return CheckboxListTile(
                                title: Text(cat.title, style: Theme.of(context).textTheme.bodyMedium),
                                value: selectedCategories.contains(cat.title),
                                onChanged: (_) => _toggleCategory(cat.title),
                                controlAffinity: ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                              );
                            }).toList(),
                          ],
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              /// RADIUS
              Text('Radius', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              Slider(
                value: radius,
                onChanged: (val) => setState(() => radius = val),
                min: 0,
                max: 30,
                divisions: 6,
                label: "${radius.round()} KM",
                activeColor: Colors.blue,
                inactiveColor: Colors.grey.shade300,
              ),
              Align(alignment: Alignment.centerRight, child: Text("${radius.round()} KM", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey))),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => BundleCategories(selectedCategories: selectedCategories));
                    debugPrint("Selected Event: $selectedEventType");
                    debugPrint("Selected Categories: $selectedCategories");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E5CDA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Text("Next Step", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false, VoidCallback? onTap, IconData? suffixIcon, String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _dropdownBox({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black12)],
      ),
      child: Column(children: children),
    );
  }

  Widget _styledDropdownContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }

  String _monthName(int month) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }
}
