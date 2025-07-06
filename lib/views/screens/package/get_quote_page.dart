import 'package:flutter/material.dart';

import '../package/booking/widgets/time_picker.dart'; // Adjust if needed

class GetQuoteScreen extends StatefulWidget {
  const GetQuoteScreen({super.key});

  @override
  State<GetQuoteScreen> createState() => _GetQuoteScreenState();
}

class _GetQuoteScreenState extends State<GetQuoteScreen> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedEventType;
  bool isEventDropdownOpen = false;

  DateTime selectedDate = DateTime.now();
  String? startTime = "08:00 AM";
  String? endTime = "00:00 PM";
  String? favStartTime = "08:00 AM";
  String? favEndTime = "00:00 PM";
  bool showTimePicker = false;
  bool showFavTimePicker = false;
  bool isStartTime = true;
  bool isFavTime = false;

  List<String> allCategories = [
    'Photographer',
    'Makeup Artist',
    'Event Organiser',
  ];
  List<String> selectedCategories = [];
  bool isCategoryDropdownOpen = false;

  double radius = 0.0;

  @override
  void initState() {
    super.initState();
    dateController.text = _formatDate(selectedDate);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = _formatDate(picked);
      });
    }
  }

  void _showTimePicker(bool isStart) {
    setState(() {
      isStartTime = isStart;
      showTimePicker = true;
    });
  }

  void _showFavTimePicker(bool isStart) {
    setState(() {
      isFavTime = isStart;
      showFavTimePicker = true;
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

  void _onFavTimeSelected(String value) {
    setState(() {
      if (isFavTime) {
        favStartTime = value;
      } else {
        favEndTime = value;
      }
      showFavTimePicker = false;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_monthName(date.month)} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          'Get Quote',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF2864A6),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Baby Shoot / Baby Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2864A6),
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Name *',
                hintText: 'Enter name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Mobile No. *',
                hintText: 'Enter mobile number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: eventNameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Email *',
                hintText: 'Enter email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Date of Shoot *',
              dateController,
              readOnly: true,
              onTap: _pickDate,
              suffixIcon: Icons.calendar_today,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Start Time *',
                    TextEditingController(text: startTime),
                    readOnly: true,
                    onTap: () => _showTimePicker(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'End Time *',
                    TextEditingController(text: endTime),
                    readOnly: true,
                    onTap: () => _showTimePicker(false),
                  ),
                ),
              ],
            ),
            if (showTimePicker)
              CustomTimePicker(
                isStart: isStartTime,
                onCancel: () => setState(() => showTimePicker = false),
                onTimeSelected: _onTimeSelected,
              ),
            const SizedBox(height: 16),
            TextField(
              controller: requirementsController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.white,
                filled: true,
                labelText: 'Describe your Requirements *',
                hintText: 'Enter requirements',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Fav Time *',
                    TextEditingController(text: favStartTime),
                    readOnly: true,
                    onTap: () => _showFavTimePicker(true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    'Fav Time *',
                    TextEditingController(text: favEndTime),
                    readOnly: true,
                    onTap: () => _showFavTimePicker(false),
                  ),
                ),
              ],
            ),
            if (showFavTimePicker)
              CustomTimePicker(
                isStart: isFavTime,
                onCancel: () => setState(() => showFavTimePicker = false),
                onTimeSelected: _onFavTimeSelected,
              ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Note: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text:
                    'Vendor team will contact you within the favorable Date & Favorable time only',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E5CDA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        bool readOnly = false,
        VoidCallback? onTap,
        IconData? suffixIcon,
        String? hint,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.white,
          filled: true,
          labelText: label,
          hintText: hint,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 18) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
