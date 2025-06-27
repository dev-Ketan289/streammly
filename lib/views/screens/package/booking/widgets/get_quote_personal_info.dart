import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/booking_form_controller.dart';
import '../../../common/widgets/custom_textfield.dart' show CustomTextField;

class GetQuotePersonalInfo extends StatelessWidget {
  const GetQuotePersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingFormController>();

    return Column(
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

        // Name Field
        CustomTextField(
          labelText: 'Name *',
          hintText: 'Enter your name',
          onChanged: (val) => controller.updatePersonalInfo('name', val),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          labelText: "Number",
          hintText: '+91 8545254789',
          keyboardType: TextInputType.phone,
          onChanged: (val) => controller.updatePersonalInfo('mobile', val),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile number';
            }
            if (!RegExp(r'^\+?\d{10,12}$').hasMatch(value)) {
              return 'Please enter a valid mobile number';
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => controller.addAlternateMobile(),
              label: const Text(
                'Add +',
                style: TextStyle(
                  color: Color.fromARGB(255, 143, 149, 170),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
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
                          child: CustomTextField(
                            initialValue: rxStr.value,
                            hintText: 'Alternate Mobile No',
                            keyboardType: TextInputType.phone,
                            onChanged: (val) => rxStr.value = val,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(
                                  r'^\+?\d{10,12}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid mobile number';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.removeAlternateMobile(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.red.shade600,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),

        // Email Section
        CustomTextField(
          labelText: "Email",
          hintText: 'umarajput123@gmail.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => controller.updatePersonalInfo('email', val),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () => controller.addAlternateEmail(),
              label: const Text(
                'Add +',
                style: TextStyle(
                  color: Color.fromARGB(255, 143, 149, 170),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
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
                          child: CustomTextField(
                            initialValue: rxStr.value,
                            hintText: 'Alternate Mail ID',
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (val) => rxStr.value = val,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => controller.removeAlternateEmail(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.red.shade600,
                              size: 18,
                            ),
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
}
