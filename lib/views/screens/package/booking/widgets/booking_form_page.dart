import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/booking_form_controller.dart';

class PackageFormCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> package;
  const PackageFormCard({super.key, required this.index, required this.package});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingFormController>();

    return Obx(() {
      final form = controller.packageFormsData[index] ?? {};

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Booking Schedule", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 20),

          // Studio Address
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
            child: TextFormField(
              readOnly: true,
              initialValue: package['address'] ?? '305/A, Navneet Building, Saivihar Road, Bhandup (W), Mumbai 400078.',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: const InputDecoration(
                labelText: 'Studio Address *',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Date Picker
          GestureDetector(
            onTap: () => controller.selectDate(index, context),
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
              child: AbsorbPointer(
                child: TextFormField(
                  readOnly: true,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Date of Shoot *',
                    hintText: form['date']?.isEmpty ?? true ? 'Select Date' : null,
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  controller: TextEditingController(text: form['date'] ?? ''),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Time Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.pickTime(index, isStart: true, context: context),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Start Time *',
                          hintText: form['startTime']?.isEmpty ?? true ? '00:00 AM' : null,
                          suffixIcon: const Icon(Icons.access_time, color: Colors.grey, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        controller: TextEditingController(text: form['startTime'] ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.pickTime(index, isStart: false, context: context),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
                    child: AbsorbPointer(
                      child: TextFormField(
                        readOnly: true,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'End Time *',
                          hintText: form['endTime']?.isEmpty ?? true ? '00:00 PM' : null,
                          suffixIcon: const Icon(Icons.access_time, color: Colors.grey, size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        controller: TextEditingController(text: form['endTime'] ?? ''),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

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
              onChanged: (val) => controller.updatePackageForm(index, 'babyInfo', val),
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
              onChanged: (val) => controller.updatePackageForm(index, 'theme', val),
            ),
          ),
          const SizedBox(height: 32),

          // Add-Ons Section
          _buildExpandableSection(title: 'Choose Free Item', isSelected: form['freeAddOn'] != null, onTap: () => controller.toggleAddOn(index, 'free')),
          const SizedBox(height: 16),

          _buildExpandableSection(title: 'Extra Add-Ons (Extra Charged)', isSelected: form['extraAddOn'] != null, onTap: () => controller.toggleAddOn(index, 'extra')),
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
      );
    });
  }

  Widget _buildExpandableSection({required String title, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid), borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isSelected ? const Color(0xFF4A6CF7) : Colors.black87)),
            Icon(isSelected ? Icons.remove : Icons.add, color: isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
