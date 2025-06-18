import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_form_page.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_personal_info.dart';

import '../../../../controllers/booking_form_controller.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingFormController());

    // Receive selected packages from previous screen
    final packages = Get.arguments as List<Map<String, dynamic>>;
    controller.initSelectedPackages(packages);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.selectedPackages.isNotEmpty ? controller.selectedPackages[0]['title'] ?? "Booking" : "Booking",
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PersonalInfoSection(),
                    const SizedBox(height: 32),

                    // Package Toggle Buttons (only show if multiple packages)
                    if (controller.selectedPackages.length > 1) ...[
                      SizedBox(
                        height: 45,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.selectedPackages.length,
                          itemBuilder: (context, index) {
                            final isSelected = controller.currentPage.value == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: ElevatedButton(
                                onPressed: () => controller.currentPage.value = index,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade100,
                                  foregroundColor: isSelected ? Colors.white : Colors.black87,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(color: isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade300),
                                  ),
                                ),
                                child: Text(
                                  controller.selectedPackages[index]['title'] ?? 'Package ${index + 1}',
                                  style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Active Form
                    PackageFormCard(index: controller.currentPage.value, package: controller.selectedPackages[controller.currentPage.value]),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 1, offset: const Offset(0, -2))]),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.submitBooking(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6CF7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Let's Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
