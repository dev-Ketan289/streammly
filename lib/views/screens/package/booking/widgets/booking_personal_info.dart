import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/booking_form_controller.dart';
import '../../../common/widgets/custom_textfield.dart' show CustomTextField;

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookingController>();
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withValues(alpha: 0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personal Info", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: textColor)),
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

        // Mobile Number Section
        Text("Mobile No *", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: textColor)),
        const SizedBox(height: 8),
        CustomTextField(
          labelText: "Number",
          hintText: '+91 8545254789',
          keyboardType: TextInputType.phone,
          onChanged: (val) => controller.updatePersonalInfo('mobile', val),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile number';
            }
            if (!RegExp(r'^\+?\d{10,12}\$').hasMatch(value)) {
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
              label: Text('Add +', style: theme.textTheme.bodyMedium?.copyWith(color: secondaryTextColor, fontWeight: FontWeight.w500)),
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
                                if (!RegExp(r'^\+?\d{10,12}\$').hasMatch(value)) {
                                  return 'Please enter a valid mobile number';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => controller.removeAlternateMobile(index),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: theme.colorScheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                            child: Icon(Icons.close, color: theme.colorScheme.error, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),

        // Email Section
        Text("Mail ID *", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, color: textColor)),
        const SizedBox(height: 8),
        CustomTextField(
          labelText: "Email",
          hintText: 'umarajput123@gmail.com',
          keyboardType: TextInputType.emailAddress,
          onChanged: (val) => controller.updatePersonalInfo('email', val),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value)) {
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
              label: Text('Add +', style: theme.textTheme.bodyMedium?.copyWith(color: secondaryTextColor, fontWeight: FontWeight.w500)),
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
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\$').hasMatch(value)) {
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
                            decoration: BoxDecoration(color: theme.colorScheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                            child: Icon(Icons.close, color: theme.colorScheme.error, size: 18),
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
