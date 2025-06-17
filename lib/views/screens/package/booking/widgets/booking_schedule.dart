import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/package_page_controller.dart';

class BookingPackageFormList extends StatelessWidget {
  final PackagesController controller = Get.find();

  BookingPackageFormList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Package", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(controller.packages.length, (index) {
              final pkg = controller.packages[index];
              final isSelected = controller.isPackageSelected(index);

              return ChoiceChip(
                label: Text(pkg['title']),
                selected: isSelected,
                onSelected: (_) => controller.togglePackageSelection(index),
                selectedColor: Colors.blue.shade100,
                backgroundColor: Colors.grey.shade200,
                labelStyle: TextStyle(color: isSelected ? Colors.blue : Colors.black87, fontWeight: FontWeight.w500),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Show forms for selected packages
          ...controller.selectedPackageIndices.map((index) {
            final pkg = controller.getPackageByIndex(index);
            final selectedHours = controller.getSelectedHoursForPackage(index);

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pkg?['title'] ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),

                      /// Booking Schedule
                      Text("Select Hours", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            (pkg?['hours'] as List<String>).map((hour) {
                              final isSelected = selectedHours.contains(hour);
                              return FilterChip(
                                label: Text(hour),
                                selected: isSelected,
                                onSelected: (_) => controller.toggleHour(index, hour),
                                selectedColor: Colors.blue.shade100,
                                labelStyle: TextStyle(color: isSelected ? Colors.blue : Colors.black),
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 20),

                      /// Questions Section (placeholder)
                      Text("Any Notes?", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade400)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
