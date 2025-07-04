import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/views/screens/package/booking/thanks_for_booking.dart';

import '../../../../controllers/package_page_controller.dart';

class BookingSummaryPage extends StatelessWidget {
  final BookingController controller = Get.find<BookingController>();
  final PackagesController packagesController = Get.find<PackagesController>();

  BookingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F5F7),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('Booking Summary', style: TextStyle(color: Color(0xFF4A90E2), fontSize: 18, fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Obx(() {
                      final packages = controller.selectedPackages;
                      return Column(
                        children: [
                          for (int i = 0; i < packages.length; i++)
                            Column(
                              children: [
                                _buildPackageCard(
                                  index: i,
                                  title: packages[i]['title'],
                                  subtitle: _getSubtitle(i),
                                  price: packagesController.getSelectedPackagesForBilling()[i]['finalPrice'] ?? 0,
                                  showLocationDetails: controller.showPackageDetails[i],
                                  onEdit: () => controller.editPackage(i),
                                  onToggleDetails: () => controller.toggleDetails(i),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          const SizedBox(height: 24),
                          _buildTotalPaymentSection(),
                          const SizedBox(height: 24),
                          _buildPaymentMethodSection(),
                          const SizedBox(height: 24),
                          _buildContinueButton(),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSubtitle(int index) {
    final form = controller.packageFormsData[index] ?? {};
    final date = form['date']?.toString() ?? 'Not set';
    final startTime = form['startTime']?.toString() ?? 'Not set';
    final endTime = form['endTime']?.toString() ?? 'Not set';
    return '$date, $startTime to $endTime';
  }

  Widget _buildPackageCard({
    required int index,
    required String title,
    required String subtitle,
    required int price,
    required bool showLocationDetails,
    required VoidCallback onEdit,
    required VoidCallback onToggleDetails,
  }) {
    final form = controller.packageFormsData[index] ?? {};
    final packageTitle = controller.selectedPackages[index]['title'];

    return Container(
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFB5B6B7)), color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
                          Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF2864A6))),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Text('₹$price/-', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF2864A6))),
                        const SizedBox(width: 12),
                        GestureDetector(onTap: onToggleDetails, child: Icon(showLocationDetails ? Icons.visibility : Icons.visibility_off, color: Colors.black, size: 20)),
                        const SizedBox(width: 12),
                        GestureDetector(onTap: onEdit, child: const Icon(Icons.edit, color: Colors.black, size: 20)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          if (showLocationDetails) ...[
            Container(height: 1, color: const Color(0xFFB5B6B7)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Shoot Location', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text(
                    controller.selectedPackages[index]['address'] ?? '1st Floor, Hiren Industrial Estate, 104 & 105 - B, Mogul Ln, Mahim West, Maharashtra 400016.',
                    style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  if (packageTitle == 'Cuteness') Text('Baby Info: ${form['babyInfo'] ?? 'Not set'}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  if (packageTitle == 'Moments') ...[
                    Text('Theme: ${form['theme'] ?? 'Not set'}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text('Outfit Changes: ${form['outfitChanges'] ?? 'Not set'}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  ],
                  if (packageTitle == 'Wonders')
                    Text('Location Preference: ${form['locationPreference'] ?? 'Not set'}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
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
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalPaymentSection() {
    final totalPrice = packagesController.getSelectedPackagesForBilling().fold<int>(0, (sum, pkg) => sum + (pkg['finalPrice'] as int));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
          Text(
            'Rs. ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Get.snackbar('Payment Method', 'Select your payment method', backgroundColor: Colors.blue, colorText: Colors.white);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE9ECEF))),
                child: Row(
                  children: const [
                    Icon(Icons.account_balance_wallet, size: 24, color: Colors.black54),
                    SizedBox(width: 12),
                    Expanded(child: Text('Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87))),
                    Icon(Icons.chevron_right, color: Colors.grey, size: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () => Get.to(() => ThanksForBookingPage()),
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A90E2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
        child: const Text('Let\'s Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}
