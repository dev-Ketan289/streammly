import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';

class PackageCard extends StatelessWidget {
  final int index;
  final BookingFormController formController = Get.find<BookingFormController>();

  PackageCard({super.key, required this.index});

  // Placeholder for Booking Id and OTP (to be replaced with actual data source if available)
  String getBookingId() {
    // Assuming a unique ID generation or fetch from formController if implemented
    return 'BKEIAP${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
  }

  String getOtp() {
    // Placeholder OTP generation
    return '39068'; // Replace with dynamic OTP if available from backend
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final package = formController.selectedPackages[index];
      final form = formController.packageFormsData[index] ?? {};
      final packageTitle = package['title'];

      return Container(
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Id and OTP Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Booking Id: ', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                        Text(getBookingId(), style: const TextStyle(fontSize: 14, color: Colors.black)),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFE3E7FF).withAlpha(102), borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Text('OTP: ', style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
                          Text(getOtp(), style: const TextStyle(fontSize: 14, color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Package Title and Shoot Type
            Text(packageTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(
              'HomeShoot', // Assuming 'HomeShoot' as shoot type; replace with dynamic data if available
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            // Shoot Location
            const Text('Shoot Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
            Text(
              package['address'] ?? '1st Floor, Hiren Industrial Estate, 104 & 105 - B, Mogul Ln, Mahim West, Maharashtra 400016.',
              style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 16),
            // Date and Timing Row
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Date of Shoot', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(form['date']?.toString() ?? 'Not set', style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey.shade300, padding: const EdgeInsets.symmetric(horizontal: 14)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Timing', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text(
                          '${form['startTime']?.toString() ?? 'Not set'} - ${form['endTime']?.toString() ?? 'Not set'}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
