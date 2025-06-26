import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThanksForBookingController extends GetxController {
  var cutenessPrice = 5999.0.obs;
  var momentsPrice = 1599.0.obs;
  var totalPayment = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    totalPayment.value = cutenessPrice.value + momentsPrice.value;
  }
}

class ThanksForBookingPage extends StatelessWidget {
  final ThanksForBookingController controller = Get.put(
    ThanksForBookingController(),
  );

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
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Thanks for Booking',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ),

                      Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/Thumb.gif', height: 200),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Do you want to cancel your Shoot?',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  ' Cancel',
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Shoot Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildShootDetailRow('Cuteness', 'Rs. 5999'),
                      _buildShootDetailRow('Moments', 'Rs. 1599'),
                      _buildShootDetailRow('Addon Price', 'Rs. 0'),
                      _buildShootDetailRow('Promo Discount', 'Rs. 0'),
                      const Divider(),
                      Obx(
                        () => _buildShootDetailRow(
                          'Total Payment',
                          'Rs. ${controller.totalPayment.value.toStringAsFixed(0)}',
                          isBold: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShootDetailRow(
    String label,
    String value, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
