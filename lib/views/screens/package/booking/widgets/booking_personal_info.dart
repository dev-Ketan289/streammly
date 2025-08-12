import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../controllers/booking_form_controller.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = const Color(0xFF111827);
    final secondaryTextColor = const Color(0xFF6B7280);

    return GetBuilder<BookingController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleText("Personal Info", theme, textColor, 16, FontWeight.w600),
            const SizedBox(height: 12),

            _customReadOnlyField(
              controller.nameController,
              "Name *",
              'Uma Rajput',
            ),
            const SizedBox(height: 16),

            _titleText("Mobile No *", theme, textColor, 14, FontWeight.w500),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _customReadOnlyField(
                    controller.mobileController,
                    "Number",
                    '+91 8545254789',
                  ),
                ),
                const SizedBox(width: 8),
                _verifiedTag(),
              ],
            ),

            const SizedBox(height: 16),

            _titleText(
              "Alternate Mobile No",
              theme,
              textColor,
              14,
              FontWeight.w500,
            ),

            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GetBuilder<BookingController>(
                        id: 'alternate_field',
                        builder: (_) {
                          return TextField(
                            controller: controller.alternateMobileController,
                            readOnly: !controller.isEditingAlternate,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF111827),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '8545254789',
                              hintStyle: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(
                                  left: 44, right: 12, top: 14, bottom: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (controller.alternateMobiles.isEmpty) {
                                controller.alternateMobiles.add(value);
                              } else {
                                controller.alternateMobiles[0] = value;
                              }
                              controller.update(['verify_button']);
                            },
                          );
                        },
                      ),
                      Positioned(
                        left: 14,
                        top: 0,
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '+91 ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: secondaryTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GetBuilder<BookingController>(
                  id: 'verify_button',
                  builder: (controller) => _buildVerifyOrEditButton(controller),
                ),
              ],
            ),

            if (controller.isOTPSent && !controller.isAlternateMobileVerified)
              GetBuilder<BookingController>(
                id: 'otp_section',
                builder: (controller) => _buildOTPVerificationSection(controller),
              ),

            const SizedBox(height: 16),

            _titleText("Mail id *", theme, textColor, 14, FontWeight.w500),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _customReadOnlyField(
                    controller.emailController,
                    "Email",
                    'umarajput123@gmail.com',
                  ),
                ),
                const SizedBox(width: 8),
                _verifiedTag(),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _titleText(String text, ThemeData theme, Color color, double size, FontWeight weight) {
    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontWeight: weight,
        fontSize: size,
        color: color,
      ),
    );
  }

  Widget _customReadOnlyField(TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      readOnly: true,
      enabled: false,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF111827),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF111827),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
        ),
      ),
    );
  }

  Widget _verifiedTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF22C55E).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF22C55E), width: 1),
      ),
      child: const Text(
        'Verified',
        style: TextStyle(
          color: Color(0xFF22C55E),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildVerifyOrEditButton(BookingController controller) {
    final enteredNumber = controller.alternateMobileController.text.trim();
    final isValidNumber = RegExp(r'^\d{10}$').hasMatch(enteredNumber);

    // When not in edit mode, show EDIT button
    if (!controller.isEditingAlternate) {
      return ElevatedButton(
        onPressed: controller.toggleAlternateEdit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A6CF7),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size.zero,
        ),
        child: const Text(
          'Edit',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    } else {
      if (controller.isAlternateMobileVerified) {
        return _verifiedTag();
      }
      return ElevatedButton(
        onPressed: isValidNumber ? controller.onSendOTPPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isValidNumber ? const Color(0xFF4A6CF7) : const Color(0xFFD1D5DB),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: Size.zero,
        ),
        child: const Text(
          'Send OTP',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      );
    }
  }

  Widget _buildOTPVerificationSection(BookingController controller) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(6, (index) {
            return Padding(
              padding: EdgeInsets.only(right: index != 5 ? 8 : 0),
              child: Container(
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.otpDigits.length > index &&
                        controller.otpDigits[index].isNotEmpty
                        ? const Color(0xFF4A6CF7)
                        : const Color(0xFFD1D5DB),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: controller.otpControllers[index],
                  focusNode: controller.otpFocusNodes[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (value) =>
                      controller.onOTPDigitChanged(index, value),
                  onTap: () => controller.onOTPFieldTapped(index),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (controller.otpTimer > 0)
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 16, color: Color(0xFF6B7280)),
                  const SizedBox(width: 4),
                  Text(
                    'Resend code in 00:${controller.otpTimer.toString().padLeft(2, '0')}',
                    style:
                    const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                  ),
                ],
              )
            else
              TextButton(
                onPressed: controller.isOtpVerifying
                    ? null
                    : () => controller.resendOTP(),
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, minimumSize: Size.zero),
                child: const Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Color(0xFF4A6CF7),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: (controller.isOTPComplete && !controller.isOtpVerifying)
                  ? () => controller.verifyAlternateMobileOTP()
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (controller.isOTPComplete &&
                    !controller.isOtpVerifying)
                    ? const Color(0xFF4A6CF7)
                    : const Color(0xFFD1D5DB),
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: controller.isOtpVerifying
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Text('Verify',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
