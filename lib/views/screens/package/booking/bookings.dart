import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/views/screens/package/booking/booking_summary.dart';
import 'package:streammly/views/screens/package/booking/components/package_card.dart';

class Bookings extends StatelessWidget {
  Bookings({super.key});
  final BookingFormController formController =
      Get.find<BookingFormController>();
  final BookingSummaryController summaryController =
      Get.find<BookingSummaryController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Bookings'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [Tab(text: 'Packages'), Tab(text: 'Quotations')],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Obx(
                () => Column(
                  children: List.generate(
                    formController.selectedPackages.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PackageCard(index: index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Center(child: Text('Quotations Content')),
          ],
        ),
      ),
    );
  }
}
