import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/auth_controller.dart';
import 'package:streammly/controllers/booking_form_controller.dart';
import 'package:streammly/controllers/support_ticket_controller.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/data/repository/support_ticket_repo.dart';
import 'package:streammly/services/constants.dart';
import 'package:streammly/views/screens/profile/support_ticket_form.dart';

class SupportTicketPage extends StatelessWidget {
  const SupportTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

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
                      onPressed: () => _handleCreateTicket(
                        context,
                        authController,
                        bookingController,
                      ),
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

              // Only show "Your Support Tickets" section if user is logged in
              if (authController.isLoggedIn()) ...[
                const SizedBox(height: 32),

                // Support Tickets List Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Your Support Tickets",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Tickets List with properly initialized controller
                Expanded(
                  child: _buildSupportTicketsList(),
                ),
              ] else ...[
                // If not logged in, just add spacer to center the content
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportTicketsList() {
    // Initialize controller only when building this widget
    final supportTicketController = Get.put(
      SupportTicketController(
        supportTicketRepo: SupportTicketRepo(
          apiClient: ApiClient(
            appBaseUrl: AppConstants.baseUrl,
            sharedPreferences: Get.find(),
          ),
        ),
      ),
    );

    return GetBuilder<SupportTicketController>(
      init: supportTicketController,
      builder: (controller) {
        if (controller.isLoadingSupportTickets) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.allSupportTickets.isEmpty) {
          return Center(
            child: Text(
              'No support tickets found',
              style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.allSupportTickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.allSupportTickets[index];
            return Column(
              children: [
                _buildSupportTicketItem(
                  bookingId: ticket.displayBookingId,
                  title: ticket.title,
                  description: ticket.description,
                  status: ticket.displayStatus,
                  isPending: ticket.isPending,
                  imageUrl: ticket.referenceImage,
                ),
                if (index < controller.allSupportTickets.length - 1)
                  const SizedBox(height: 12),
              ],
            );
          },
        );
      },
    );
  }

  void _handleCreateTicket(
      BuildContext context,
      AuthController authController,
      BookingController bookingController,
      ) async {
    // Check if user is logged in
    if (!authController.isLoggedIn()) {
      _showLoginRequiredDialog(context);
      return;
    }

    // User is logged in, proceed with creating ticket
    try {
      if (bookingController.upcomingBookings.isEmpty) {
        await bookingController.fetchBookings();
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SupportTicketFormPage(
            bookings: bookingController.upcomingBookings,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load bookings. Please try again.'),
        ),
      );
    }
  }

  void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Required"),
        content: const Text("Please login to create a support ticket"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.toNamed('/login'); // Update with your login route
            },
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTicketItem({
    required String bookingId,
    required String title,
    required String description,
    required String status,
    required bool isPending,
    String? imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking ID : $bookingId",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPending
                        ? Colors.orange
                        : status == 'Resolved'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 95,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 95,
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
