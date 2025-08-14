import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/services/custom_error_inline_widget.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_details.dart';
import 'package:streammly/views/screens/package/booking/widgets/custom_bookingcard.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/booking_form_controller.dart';
import '../../../../models/booking/booking_info_model.dart';
import '../../../../navigation_flow.dart';

class MyBookings extends StatelessWidget {
  MyBookings({super.key});

  final BookingController controller = Get.put(
    BookingController(bookingrepo: BookingRepo(apiClient: Get.find())),
  );

  final AuthController authController = Get.find();

  // Removed _mapToBookingInfo() method here

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        // Dynamically check on every rebuild
        if (!authController.isLoggedIn()) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to Streammly',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Please login or sign up to view your bookings.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login or Signup',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Logged in → show bookings tab
        return GetBuilder<BookingController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final upcoming = controller.upcomingBookings;
            final cancelled = controller.cancelledBookings;
            final completed = controller.completedBookings;

            return DefaultTabController(
              length: 3,
              child: CustomBackground(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: Text(
                      'My Bookings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    bottom: TabBar(
                      labelColor: primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: primaryColor,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Cancelled'),
                        Tab(text: 'Completed'),
                      ],
                      dividerColor: Colors.transparent,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      _buildBookingList(
                        context,
                        upcoming,
                        topActionLabel: 'Reschedule',
                        leftActionLabel: 'View Details',
                        onTopAction: (b) => _onRescheduleTap(context, b),
                        onLeftAction: (b) => _onViewDetailsTap(context, b),
                        onViewReceipt: (b) => _onViewReceiptTap(context, b),
                      ),
                      _buildBookingList(
                        context,
                        cancelled,
                        status: 'Cancelled',
                        statusColor: Colors.red,
                        showReschedule: false,
                        showActionButtons: false,
                        leftActionLabel: '',
                      ),
                      _buildBookingList(
                        context,
                        completed,
                        topActionLabel: 'Reorder',
                        leftActionLabel: 'Reorder',
                        onTopAction: (b) => _onReorderTap(context, b),
                        onLeftAction: (b) => _onReorderTap(context, b),
                        onViewReceipt: (b) => _onViewReceiptTap(context, b),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookingList(
    BuildContext context,
    List<BookingInfo> bookings, {
    String? status,
    Color? statusColor,
    bool showReschedule = true,
    bool showActionButtons = true,
    String? topActionLabel,
    required String leftActionLabel,
    void Function(BookingInfo)? onTopAction,
    void Function(BookingInfo)? onLeftAction,
    void Function(BookingInfo)? onViewReceipt,
  }) {
    if (bookings.isEmpty) {
      return CommonInlineMessage(
        imagePath: 'assets/images/no_booking.png',
        title: 'No Bookings Yet',
        btnText: 'Browse Services',
        onPressed: () {
          final navigationFlow =
              context.findAncestorStateOfType<NavigationFlowState>();
          navigationFlow?.switchToTab(0);
        },
        message: 'You haven’t booked any services yet',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return CustomBookingcard(
          bookingId: booking.bookingId,
          otp: booking.otp,
          title: booking.title,
          type: booking.type,
          location: booking.location,
          date: booking.date,
          time: booking.time,
          status: status,
          statusColor: statusColor,
          showReschedule: showReschedule,
          showActionButtons: showActionButtons,
          topActionLabel: topActionLabel,
          onTopAction: onTopAction != null ? () => onTopAction(booking) : null,
          leftActionLabel: leftActionLabel,
          onLeftAction:
              onLeftAction != null ? () => onLeftAction(booking) : null,
          onViewReceipt:
              onViewReceipt != null ? () => onViewReceipt(booking) : null,
        );
      },
    );
  }

  void _onRescheduleTap(BuildContext context, BookingInfo booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rescheduling booking: ${booking.title}')),
    );
  }

  void _onViewDetailsTap(BuildContext context, BookingInfo booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BookingDetailsPage(
              booking: booking,
              status: 'Upcoming',
              statusColor: Colors.green,
            ),
      ),
    );
  }

  void _onReorderTap(BuildContext context, BookingInfo booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reordering booking: ${booking.title}')),
    );
  }

  void _onViewReceiptTap(BuildContext context, BookingInfo booking) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing receipt for: ${booking.title}')),
    );
  }
}
