import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/package/booking/booking_summary.dart';

class BookingController extends GetxController {
  var selectedDate = DateTime(2025, 6, 12).obs;
  var startTime = TimeOfDay(hour: 8, minute: 0).obs;
  var endTime = TimeOfDay(hour: 12, minute: 0).obs;
  var isTimePickerVisible = false.obs;
  var isStartTimePicker = true.obs;
  var termsAccepted = false.obs;

  final nameController = TextEditingController(text: 'Uma Rajput');
  final phoneController = TextEditingController(text: '+91 8545254789');
  final emailController = TextEditingController(text: 'umarajput123@gmail.com');

  void showTimePicker(bool isStart) {
    isStartTimePicker.value = isStart;
    isTimePickerVisible.value = true;
  }

  void hideTimePicker() {
    isTimePickerVisible.value = false;
  }

  void setTime(int hour, int minute) {
    if (isStartTimePicker.value) {
      startTime.value = TimeOfDay(hour: hour, minute: minute);
    } else {
      endTime.value = TimeOfDay(hour: hour, minute: minute);
    }
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}

class BookingPage extends StatelessWidget {
  final BookingController controller = Get.put(BookingController());

  BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F7),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20), onPressed: () => Get.back()),
        title: const Text('Babyshoot/Newborn', style: TextStyle(color: Color(0xFF4A90E2), fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personal Info Section
            _buildPersonalInfoSection(),
            const SizedBox(height: 20),

            // Booking Schedule Section
            _buildBookingScheduleSection(),
            const SizedBox(height: 20),

            // Questions Section
            _buildQuestionsSection(),
            const SizedBox(height: 20),

            // Terms and Continue Button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(height: 16),

          // Name Field
          _buildInputField(label: 'Name *', controller: controller.nameController),
          const SizedBox(height: 16),

          // Mobile Number Field
          _buildInputField(label: 'Mobile No *', controller: controller.phoneController),
          const SizedBox(height: 16),

          // Email Field
          _buildInputField(label: 'Mail Id *', controller: controller.emailController, showAddButton: true),
        ],
      ),
    );
  }

  Widget _buildBookingScheduleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(height: 16),

          // Studio Address
          const Text('Studio Address *', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
            child: const Text('305/A, Navneet Building, Savihar Road, Bhandup (W), Mumbai 400078.', style: TextStyle(fontSize: 14, color: Colors.black87)),
          ),
          const SizedBox(height: 16),

          // Date of Shoot
          const Text('Date of Shoot *', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _showDatePicker(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text('${controller.selectedDate.value.day} June ${controller.selectedDate.value.year}', style: const TextStyle(fontSize: 14, color: Colors.black87))),
                  const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Start Time *', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => controller.showTimePicker(true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
                        child: Obx(() => Text(controller.formatTime(controller.startTime.value), style: const TextStyle(fontSize: 14, color: Colors.black87))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('End Time *', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => controller.showTimePicker(false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
                        child: Obx(() => Text(controller.formatTime(controller.endTime.value), style: const TextStyle(fontSize: 14, color: Colors.black87))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Custom Time Picker
          Obx(() => controller.isTimePickerVisible.value ? _buildCustomTimePicker() : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(height: 16),

          // Question 1
          _buildQuestionField('What is your baby\'s age and gender?'),
          const SizedBox(height: 12),

          // Question 2
          _buildQuestionField('Do you have a specific theme or color palette in mind for the shoot?'),
          const SizedBox(height: 12),

          // Choose Free Item
          _buildExpandableField('Choose Free Item', Icons.add),
          const SizedBox(height: 12),

          // Extra Add-Ons
          _buildExpandableField('Extra Add-Ons (Extra Charged)', Icons.add),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Terms and Conditions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Checkbox(
                value: controller.termsAccepted.value,
                onChanged: (value) => controller.termsAccepted.value = value ?? false,
                activeColor: const Color(0xFF4A90E2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    TextSpan(text: 'I accept the '),
                    TextSpan(text: 'Terms and Conditions', style: TextStyle(color: Color(0xFF4A90E2), decoration: TextDecoration.underline)),
                    TextSpan(text: ' and agree to the '),
                    TextSpan(text: 'Privacy Policy', style: TextStyle(color: Color(0xFF4A90E2), decoration: TextDecoration.underline)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Continue Button
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => BookingSummaryPage());
              // Handle continue action
              Get.snackbar('Success', 'Booking submitted successfully!', backgroundColor: Colors.green, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90E2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
            child: const Text('Let\'s Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({required String label, required TextEditingController controller, bool showAddButton = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE9ECEF))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE9ECEF))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF4A90E2))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(width: 12),
              TextButton(onPressed: () {}, child: const Text('Add +', style: TextStyle(color: Color(0xFF4A90E2), fontSize: 14, fontWeight: FontWeight.w500))),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildQuestionField(String question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(question, style: const TextStyle(fontSize: 14, color: Color(0xFF4A90E2), fontWeight: FontWeight.w500))),
          const Icon(Icons.keyboard_arrow_down, color: Color(0xFF4A90E2), size: 20),
        ],
      ),
    );
  }

  Widget _buildExpandableField(String title, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.5), style: BorderStyle.solid)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)), Icon(icon, color: Colors.black54, size: 20)],
      ),
    );
  }

  Widget _buildCustomTimePicker() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F4FF), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Obx(() => Text(controller.isStartTimePicker.value ? 'Start' : 'End', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87))),
                    Obx(
                      () => Text(
                        controller.isStartTimePicker.value ? controller.formatTime(controller.startTime.value) : controller.formatTime(controller.endTime.value),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Obx(
                      () => Text(!controller.isStartTimePicker.value ? 'Start' : 'End', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    ),
                    Obx(
                      () => Text(
                        !controller.isStartTimePicker.value ? controller.formatTime(controller.startTime.value) : controller.formatTime(controller.endTime.value),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Time Grid
          Row(
            children: [
              // Hours Column
              Expanded(
                child: Column(
                  children: [
                    for (int i = 5; i <= 10; i++)
                      _buildTimeButton(i.toString().padLeft(2, '0'), () {
                        controller.setTime(i, controller.isStartTimePicker.value ? controller.startTime.value.minute : controller.endTime.value.minute);
                      }),
                  ],
                ),
              ),
              // Minutes Column
              Expanded(
                child: Column(
                  children: [
                    for (int i = 27; i <= 32; i++)
                      _buildTimeButton(i.toString(), () {
                        controller.setTime(controller.isStartTimePicker.value ? controller.startTime.value.hour : controller.endTime.value.hour, i);
                      }),
                  ],
                ),
              ),
              // AM/PM Column
              Expanded(child: Column(children: [_buildTimeButton('AM', () {}), _buildTimeButton('PM', () {})])),
            ],
          ),
          const SizedBox(height: 16),

          // Set and Cancel Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => controller.hideTimePicker(),
                  child: const Text('Set', style: TextStyle(color: Color(0xFF4A90E2), fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => controller.hideTimePicker(),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(color: text == '08' || text == '30' ? const Color(0xFF4A90E2) : Colors.transparent, borderRadius: BorderRadius.circular(4)),
        child: Text(
          text,
          style: TextStyle(fontSize: 14, color: text == '08' || text == '30' ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(context: Get.context!, initialDate: controller.selectedDate.value, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365))).then((
      date,
    ) {
      if (date != null) {
        controller.selectedDate.value = date;
      }
    });
  }
}
