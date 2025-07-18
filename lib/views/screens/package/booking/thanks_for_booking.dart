import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/views/screens/package/booking/components/package_card.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

class ThanksForBookingPage extends StatelessWidget {
  final BookingController formController = Get.find<BookingController>();

  ThanksForBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(45.0),
          child: Column(
            children: [
              Center(child: Text('Thanks for Booking', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.primaryColor))),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: theme.shadowColor.withValues(alpha: 0.1), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 132,
                                    width: 327,
                                    decoration: BoxDecoration(color: theme.primaryColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                                    child: Image.asset('assets/images/Thumb.gif', height: 300),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text('Shoot Details', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),

                            // Dynamic package prices
                            Obx(
                              () => Column(
                                children: List.generate(formController.selectedPackages.length, (index) {
                                  final package = formController.selectedPackages[index];
                                  final price = package['price']?.toString() ?? '0';
                                  return _buildShootDetailRow(context, package['title'], 'Rs. $price');
                                }),
                              ),
                            ),

                            _buildShootDetailRow(context, 'Addon Price', 'Rs. 0'),
                            _buildShootDetailRow(context, 'Promo Discount', 'Rs. 0'),
                            const Divider(),

                            Obx(() {
                              double total = 0;
                              for (var pkg in formController.selectedPackages) {
                                total += double.tryParse(pkg['price']?.toString() ?? '0') ?? 0;
                              }
                              return _buildShootDetailRow(context, 'Total Payment', 'Rs. ${total.toStringAsFixed(0)}', isBold: true);
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
      ),
    );
  }

  Widget _buildShootDetailRow(BuildContext context, String label, String value, {bool isBold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isBold ? theme.primaryColor : theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
