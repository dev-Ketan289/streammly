import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/views/screens/package/booking/components/package_card.dart';

class ThanksForBookingPage extends StatelessWidget {
  final BookingController formController = Get.find<BookingController>();

  ThanksForBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(child: Text('Thanks for Booking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A90E2)))),
                          Center(
                            child: Column(
                              children: [
                                Image.asset('assets/images/Thumb.gif', height: 200),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Do you want to cancel your Shoot?', style: TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
                                    GestureDetector(
                                      onTap: () {
                                        Get.snackbar('Cancel Booking', 'Cancellation process initiated...', backgroundColor: Colors.red, colorText: Colors.white);
                                      },
                                      child: Text(' Cancel', style: TextStyle(color: Colors.red.shade600, fontSize: 14), textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text('Shoot Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),

                          // Dynamic package prices
                          Obx(
                            () => Column(
                              children: List.generate(formController.selectedPackages.length, (index) {
                                final package = formController.selectedPackages[index];
                                final price = package['price']?.toString() ?? '0';
                                return _buildShootDetailRow(package['title'], 'Rs. $price');
                              }),
                            ),
                          ),

                          _buildShootDetailRow('Addon Price', 'Rs. 0'),
                          _buildShootDetailRow('Promo Discount', 'Rs. 0'),
                          const Divider(),

                          // Total Payment dynamically calculated
                          Obx(() {
                            double total = 0;
                            for (var pkg in formController.selectedPackages) {
                              total += double.tryParse(pkg['price']?.toString() ?? '0') ?? 0;
                            }
                            return _buildShootDetailRow('Total Payment', 'Rs. ${total.toStringAsFixed(0)}', isBold: true);
                          }),
                        ],
                      ),
                    ),

                    // Dynamic Package Cards
                    Obx(
                      () => Column(
                        children: List.generate(
                          formController.selectedPackages.length,
                          (index) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: PackageCard(index: index)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShootDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(color: isBold ? const Color(0xFF2864A6) : Colors.grey, fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
