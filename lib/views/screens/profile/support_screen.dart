import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/views/screens/profile/support_ticket_form.dart';

class SupportTicketPage extends StatelessWidget {
  const SupportTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.put(
      BookingController(
        bookingrepo: BookingRepo(
          apiClient: ApiClient(
            appBaseUrl: AppConstants.baseUrl,
            sharedPreferences: Get.find(),
          ),
        ),
      ),
    );
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        centerTitle: true,
        title: Text(
          "Support Ticket",
          style: textTheme.titleMedium?.copyWith(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          height: screenHeight * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/images/support.png', height: 150),
              const SizedBox(height: 16),
              Text(
                '"Need help? Connect with our support team – we\'re here to assist you every step of the way."',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Ensure bookings are fetched
                        if (bookingController.upcomingBookings.isEmpty) {
                          await bookingController.fetchBookings();
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SupportTicketFormPage(
                                  bookings: bookingController.upcomingBookings,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "+ Create Support Ticket",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.call, color: Colors.blue.shade800),
                      onPressed: () {
                        // Handle call
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
