import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:streammly/data/repository/booking_repo.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_details.dart';
import 'package:streammly/views/screens/package/booking/widgets/custom_bookingcard.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../../controllers/auth_controller.dart';
import '../../../../controllers/booking_form_controller.dart';

class BookingInfo {
  final String bookingId;
  final String otp;
  final String title;
  final String type;
  final String location;
  final String date;
  final String time;

  const BookingInfo({
    required this.bookingId,
    required this.otp,
    required this.title,
    required this.type,
    required this.location,
    required this.date,
    required this.time,
  });
}

class Bookings extends StatelessWidget {
  Bookings({super.key});

  final BookingController controller = Get.put(
    BookingController(bookingrepo: BookingRepo(apiClient: Get.find())),
  );

  final AuthController authController = Get.find();

  BookingInfo _mapToBookingInfo(dynamic booking) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final time =
        (booking['start_time'] ?? '') + " - " + (booking['end_time'] ?? '');

    String formattedDate = '';
    try {
      final parsedDate = DateTime.parse(booking['date_of_shoot']);
      formattedDate = dateFormat.format(parsedDate);
    } catch (_) {}

    return BookingInfo(
      bookingId: booking['order_uid'] ?? '',
      otp: booking['otp'] ?? '',
      title: booking['package']?['title'] ?? '',
      type: booking['type'] ?? '',
      location: booking['location']?['address'] ?? 'No location',
      date: formattedDate,
      time: time,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check login status
    if (!authController.isLoggedIn()) {
      // Show welcome screen with login/signup button
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
                onPressed: () {
                  // Navigate to your login route
                  Get.toNamed('/login'); // Change route as per your app
                },
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // User is logged in, show bookings

    controller.fetchBookings();

    return GetBuilder<BookingController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final upcoming =
            controller.upcomingBookings.map(_mapToBookingInfo).toList();
        final cancelled =
            controller.cancelledBookings.map(_mapToBookingInfo).toList();
        final completed =
            controller.completedBookings.map(_mapToBookingInfo).toList();

        return DefaultTabController(
          length: 3,
          child: CustomBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                // leading: IconButton(
                //   icon: const Icon(
                //     Icons.arrow_back_ios_new,
                //     color: Colors.grey,
                //     size: 20,
                //   ),
                //   onPressed: () => Navigator.of(context).pop(),
                // ),
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
                  labelStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
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
                    onTopAction:
                        (booking) => _onRescheduleTap(context, booking),
                    onLeftAction:
                        (booking) => _onViewDetailsTap(context, booking),
                    onViewReceipt:
                        (booking) => _onViewReceiptTap(context, booking),
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
                    onTopAction: (booking) => _onReorderTap(context, booking),
                    onLeftAction: (booking) => _onReorderTap(context, booking),
                    onViewReceipt:
                        (booking) => _onViewReceiptTap(context, booking),
                  ),
                ],
              ),
            ),
          ),
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
      // Show "No bookings found" message instead of list
      return Center(
        child: Text(
          'No bookings found',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey),
        ),
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
