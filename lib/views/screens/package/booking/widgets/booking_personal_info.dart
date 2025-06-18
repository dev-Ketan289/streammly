import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/booking_form_controller.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingFormController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Personal Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 20),

        // Name Field
        _buildInputField(label: 'Name *', onChanged: (val) => controller.updatePersonalInfo('name', val)),
        const SizedBox(height: 16),

        // Mobile Number Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Mobile No *", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87)),
            TextButton.icon(
              onPressed: () => controller.addAlternateMobile(),
              icon: const Icon(Icons.add, color: Color(0xFF4A6CF7), size: 18),
              label: const Text('Add +', style: TextStyle(color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        _buildInputField(placeholder: '+91 8545254789', keyboardType: TextInputType.phone, onChanged: (val) => controller.updatePersonalInfo('mobile', val)),
        const SizedBox(height: 12),

        // Alternate Mobile Numbers
        Obx(
          () => Column(
            children:
                controller.alternateMobiles.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rxStr = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            initialValue: rxStr.value,
                            placeholder: 'Alternate Mobile No',
                            keyboardType: TextInputType.phone,
                            onChanged: (val) => rxStr.value = val,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => controller.removeAlternateMobile(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                            child: Icon(Icons.close, color: Colors.red.shade600, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        // Email Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Mail ID *", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87)),
            TextButton.icon(
              onPressed: () => controller.addAlternateEmail(),
              icon: const Icon(Icons.add, color: Color(0xFF4A6CF7), size: 18),
              label: const Text('Add +', style: TextStyle(color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        _buildInputField(placeholder: 'umarajput123@gmail.com', keyboardType: TextInputType.emailAddress, onChanged: (val) => controller.updatePersonalInfo('email', val)),
        const SizedBox(height: 12),

        // Alternate Email Addresses
        Obx(
          () => Column(
            children:
                controller.alternateEmails.asMap().entries.map((entry) {
                  final index = entry.key;
                  final rxStr = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInputField(
                            initialValue: rxStr.value,
                            placeholder: 'Alternate Mail ID',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val) => rxStr.value = val,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => controller.removeAlternateEmail(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                            child: Icon(Icons.close, color: Colors.red.shade600, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({String? label, String? placeholder, String? initialValue, TextInputType keyboardType = TextInputType.text, required Function(String) onChanged}) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
        ),
      ),
    );
  }
}
