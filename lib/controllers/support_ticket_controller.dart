import 'dart:developer';

import 'package:get/get.dart';

import '../data/repository/support_ticket_repo.dart';
import '../models/profile/support ticket/support_ticket_model.dart';
import 'auth_controller.dart';

class SupportTicketController extends GetxController {
  final SupportTicketRepo supportTicketRepo;

  SupportTicketController({required this.supportTicketRepo});

  // Support tickets lists
  List<SupportTicket> allSupportTickets = [];
  List<SupportTicket> pendingSupportTickets = [];
  List<SupportTicket> resolvedSupportTickets = [];
  List<SupportTicket> rejectedSupportTickets = [];

  bool isLoadingSupportTickets = false;
  @override
  void onInit() {
    super.onInit();
    final authController = Get.find<AuthController>();
    if (authController.isLoggedIn()) {
      fetchSupportTickets();
    } else {
      print("User not logged in, skipping fetch");
    }
  }

  Future<void> fetchSupportTickets() async {
    isLoadingSupportTickets = true;
    update(); // Trigger UI update for loading state

    try {
      final response = await supportTicketRepo.getSupportTickets();

      // Debug response structure
      print("Response: ${response?.body}");

      if (response != null && response.body != null) {
        final responseBody = response.body;

        // Handle different response structures
        if (responseBody is Map<String, dynamic> &&
            responseBody['success'] == true) {
          final ticketsData = responseBody['data'] as List<dynamic>? ?? [];

          allSupportTickets =
              ticketsData
                  .map(
                    (ticket) =>
                        SupportTicket.fromJson(ticket as Map<String, dynamic>),
                  )
                  .toList();

          // Filter by status
          pendingSupportTickets =
              allSupportTickets.where((ticket) => ticket.isPending).toList();
          resolvedSupportTickets =
              allSupportTickets.where((ticket) => ticket.isResolved).toList();
          rejectedSupportTickets =
              allSupportTickets.where((ticket) => ticket.isRejected).toList();

          print("Fetched ${allSupportTickets.length} tickets");
        } else {
          print("API returned success: false or invalid format");
          _clearAllTickets();
        }
      } else {
        print("Response is null");
        _clearAllTickets();
      }
    } catch (e) {
      print("Exception during fetch: $e");
      _clearAllTickets();
      log(
        'Error fetching support tickets: $e',
        name: 'SupportTicketController',
      );
    } finally {
      isLoadingSupportTickets = false;
      update(); // Critical: Update UI after data changes
    }
  }

  void _clearAllTickets() {
    allSupportTickets = [];
    pendingSupportTickets = [];
    resolvedSupportTickets = [];
    rejectedSupportTickets = [];
  }

  Future<bool> createSupportTicket({
    required String title,
    required String description,
    int? bookingId,
    String? referenceImage,
  }) async {
    try {
      final response = await supportTicketRepo.createSupportTicket(
        title: title,
        description: description,
        bookingId: bookingId,
        referenceImage: referenceImage,
      );

      if (response != null && response.body['success'] == true) {
        // Refresh the list after successful creation
        await fetchSupportTickets();
        return true;
      }
      return false;
    } catch (e) {
      log('Error creating support ticket: $e', name: 'SupportTicketController');
      return false;
    }
  }

  // Getter methods for different ticket counts
  int get totalTicketsCount => allSupportTickets.length;
  int get pendingTicketsCount => pendingSupportTickets.length;
  int get resolvedTicketsCount => resolvedSupportTickets.length;
  int get rejectedTicketsCount => rejectedSupportTickets.length;
}
