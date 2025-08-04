import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/controllers/package_page_controller.dart';
import 'package:streammly/views/screens/package/booking/components/package_card.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

class ThanksForBookingPage extends StatelessWidget {
  final BookingController formController = Get.find<BookingController>();
  final PackagesController packagesController = Get.find<PackagesController>();

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
              Center(
                child: Text(
                  'Thanks for Booking',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
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
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withAlpha(25),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                height: 132,
                                width: 327,
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withAlpha(13),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/images/Thumb.gif',
                                  height: 300,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Shoot Details',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            GetBuilder<BookingController>(
                              builder: (controller) {
                                final billingPackages =
                                    packagesController
                                        .getSelectedPackagesForBilling();
                                return Column(
                                  children: List.generate(
                                    billingPackages.length,
                                    (index) {
                                      final package = billingPackages[index];
                                      final priceStr =
                                          (package['finalPrice'] ?? 0)
                                              .toString();
                                      return _buildShootDetailRow(
                                        context,
                                        package['title'] ?? 'Package',
                                        'Rs. $priceStr',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),

                            _buildShootDetailRow(
                              context,
                              'Addon Price',
                              'Rs. 0',
                            ),
                            _buildShootDetailRow(
                              context,
                              'Promo Discount',
                              'Rs. 0',
                            ),
                            const Divider(),

                            GetBuilder<BookingController>(
                              builder: (controller) {
                                double total = 0;
                                final billingPackages =
                                    packagesController
                                        .getSelectedPackagesForBilling();
                                for (var pkg in billingPackages) {
                                  total +=
                                      (pkg['finalPrice'] as num?)?.toDouble() ??
                                      0;
                                }
                                return _buildShootDetailRow(
                                  context,
                                  'Total Payment',
                                  'Rs. ${total.toStringAsFixed(0)}',
                                  isBold: true,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      GetBuilder<BookingController>(
                        builder: (controller) {
                          return Column(
                            children: List.generate(
                              controller.selectedPackages.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: PackageCard(index: index),
                              ),
                            ),
                          );
                        },
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

  Widget _buildShootDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color:
                  isBold
                      ? theme.primaryColor
                      : theme.textTheme.bodyLarge?.color?.withAlpha(
                        (0.6 * 255).toInt(),
                      ),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
