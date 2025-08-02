import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/views/screens/package/booking/thanks_for_booking.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../../controllers/package_page_controller.dart';

class BookingSummaryPage extends StatelessWidget {
  final BookingController controller = Get.find<BookingController>();
  final PackagesController packagesController = Get.find<PackagesController>();

  BookingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: CustomBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text('Booking Summary', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w600)),
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
                      child: GetBuilder<BookingController>(
                        builder: (_) {
                          final packages = controller.selectedPackages;
                          return Column(
                            children: [
                              for (int i = 0; i < packages.length; i++)
                                Column(
                                  children: [
                                    _buildPackageCard(
                                      context: context,
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
                              // <<< Add-Ons Section Here >>>
                              _buildSelectedAddOnsSection(context),
                              const SizedBox(height: 24),
                              _buildTotalPaymentSection(context),
                              const SizedBox(height: 24),
                              _buildPaymentMethodSection(context),
                              const SizedBox(height: 24),
                              _buildContinueButton(context),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
    required BuildContext context,
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
                          Text(title, style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500)),
                          Text(subtitle, style: GoogleFonts.roboto(fontSize: 8, color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Text('₹$price/-', style: GoogleFonts.publicSans(fontSize: 16, fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onToggleDetails,
                          child: Icon(
                            showLocationDetails ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,

                            color: Theme.of(context).iconTheme.color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(onTap: onEdit, child: Icon(Icons.edit, color: Theme.of(context).iconTheme.color, size: 20)),
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
                  Text('Shoot Location', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    controller.selectedPackages[index]['address'] ?? '1st Floor, Hiren Industrial Estate...',
                    style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  if (packageTitle == 'Cuteness') Text('Baby Info: ${form['babyInfo'] ?? 'Not set'}', style: Theme.of(context).textTheme.bodySmall),
                  if (packageTitle == 'Moments') ...[
                    Text('Theme: ${form['theme'] ?? 'Not set'}', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text('Outfit Changes: ${form['outfitChanges'] ?? 'Not set'}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                  if (packageTitle == 'Wonders') Text('Location Preference: ${form['locationPreference'] ?? 'Not set'}', style: Theme.of(context).textTheme.bodySmall),
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
                              Text('Date of Shoot', style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(form['date']?.toString() ?? 'Not set', style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        ),
                        Container(height: 40, width: 1, color: Colors.grey.shade300, padding: const EdgeInsets.symmetric(horizontal: 14)),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Timing', style: GoogleFonts.roboto(fontWeight: FontWeight.w400, fontSize: 11, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text(
                                '${form['startTime']?.toString() ?? 'Not set'} - ${form['endTime']?.toString() ?? 'Not set'}',
                                style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 10, color: Colors.grey),
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

  Widget _buildTotalPaymentSection(BuildContext context) {
    final packageTotal = packagesController.packageTotal;
    final addonsTotal = packagesController.totalExtraAddOnPrice;
    final subtotal = packagesController.subtotal;
    final gstAmount = packagesController.gstAmount;
    final finalAmount = packagesController.finalAmount;

    String formatPrice(double price) {
      return '₹${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Bill Summary', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE9ECEF))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceRow(context, 'Package Total', formatPrice(packageTotal)),
              const SizedBox(height: 8),
              _buildPriceRow(context, 'Add-ons', formatPrice(addonsTotal)),
              const SizedBox(height: 8),
              _buildPriceRow(context, 'Subtotal', formatPrice(subtotal)),
              const SizedBox(height: 8),
              _buildPriceRow(context, 'GST (18%)', formatPrice(gstAmount)),

              const Divider(height: 32, color: Color(0xFFE9ECEF)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Payment', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(formatPrice(finalAmount), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F73F0))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE9ECEF))),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Get.snackbar('Payment Method', 'Select your payment method', backgroundColor: Colors.blue, colorText: Colors.white);
            },
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Color(0xFFF8F9FF), shape: BoxShape.circle),
                  child: const Icon(Icons.account_balance_wallet, color: Color(0xFF1F73F0), size: 22),
                ),
                const SizedBox(width: 12),
                Text('Payment', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.black)),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddOnsSection(BuildContext context) {
    final List<Map<String, dynamic>> extraAddons = packagesController.selectedExtraAddons;
    if (extraAddons.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Add-ons', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // Navigate to add-ons selection
              },
              child: Text('+ Add', style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...extraAddons.map(
              (addon) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF1F7FF), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addon['name'] ?? addon['title'] ?? 'Add-on', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(addon['description'] ?? '', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]))),
                    const SizedBox(width: 8),
                    Text('₹${addon['price']}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor)),
                    const SizedBox(width: 8),
                    GestureDetector(onTap: () => packagesController.removeExtraAddon(addon), child: const Icon(Icons.remove, size: 20, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () async {
          await controller.submitBooking();  // Call submitBooking to post to backend and handle wallet payment
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0),
        child: Text('Pay Now',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
      ),
    );
  }
}

