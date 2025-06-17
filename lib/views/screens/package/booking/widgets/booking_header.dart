import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/booking_form_controller.dart';

class BookingHeader extends StatelessWidget {
  final BookingController controller = Get.find();

  BookingHeader({super.key});

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personal Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(controller: controller.nameController, decoration: _inputDecoration("Name *")),
        const SizedBox(height: 16),
        TextField(controller: controller.mobileController, keyboardType: TextInputType.phone, decoration: _inputDecoration("Mobile No *")),
        const SizedBox(height: 12),
        Obx(
          () => Column(
            children: List.generate(
              controller.altMobiles.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: controller.altMobiles[index], keyboardType: TextInputType.phone, decoration: _inputDecoration("Alternate Mobile"))),
                    const SizedBox(width: 8),
                    IconButton(icon: Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => controller.removeAltMobile(index)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: controller.addAltMobile,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add", style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500)),
                const SizedBox(width: 2),
                Icon(Icons.add, size: 16, color: Colors.blue),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        TextField(controller: controller.emailController, keyboardType: TextInputType.emailAddress, decoration: _inputDecoration("Mail id *")),
        const SizedBox(height: 6),
        Obx(
          () => Column(
            children: List.generate(
              controller.altEmails.length,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: controller.altEmails[index], keyboardType: TextInputType.emailAddress, decoration: _inputDecoration("Alternate Email"))),
                    const SizedBox(width: 8),
                    IconButton(icon: Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => controller.removeAltEmail(index)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: controller.addAltEmail,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Add", style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.w500)),
                const SizedBox(width: 2),
                Icon(Icons.add, size: 16, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
