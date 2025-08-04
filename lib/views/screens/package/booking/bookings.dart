import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/booking/widgets/booking_details.dart';
import 'package:streammly/views/screens/package/booking/widgets/custom_bookingcard.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

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
  const Bookings({super.key});

  static const List<BookingInfo> upcomingBookings = [
    BookingInfo(
      bookingId: 'BKEIAP4514578541258442',
      otp: '390668',
      title: 'Cuteness',
      type: 'HomeShoot',
      location:
          '1st Floor, Hiren Industrial Estate, 104 & 105 - B, Mogul Ln,Behind Johnson, Bethany Co Operative Housing Society,  Mahim West, Mahim, Maharashtra 400016.',
      date: 'Sat, 24th May 2025',
      time: '12.00 PM - 01:00 PM',
    ),
    BookingInfo(
      bookingId: 'BKEIAP4514578541258443',
      otp: '390669',
      title: 'Moments',
      type: 'HomeShoot',
      location:
          '1st Floor, Hiren Industrial Estate, 104 & 105 - B, Mogul Ln,Behind Johnson, Bethany Co Operative Housing Society,  Mahim West, Mahim, Maharashtra 400016.',
      date: 'Sat, 24th May 2025',
      time: '12.00 PM - 01:00 PM',
    ),
  ];

  static const List<BookingInfo> cancelledBookings = [
    BookingInfo(
      bookingId: 'CANCELLED123',
      otp: '000000',
      title: 'Cancelled Example',
      type: 'Studio',
      location: 'Some cancelled location',
      date: 'Mon, 1st Jan 2024',
      time: '10.00 AM - 11:00 AM',
    ),
  ];

  static const List<BookingInfo> completedBookings = [
    BookingInfo(
      bookingId: 'COMPLETED123',
      otp: '111111',
      title: 'Completed Example',
      type: 'Outdoor',
      location: 'Some completed location',
      date: 'Tue, 2nd Feb 2024',
      time: '2.00 PM - 3:00 PM',
    ),
  ];

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
    // Placeholder for reschedule logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rescheduling booking: ${booking.title}')),
    );
  }

  void _onViewDetailsTap(BuildContext context, BookingInfo booking) {
    // Navigate to BookingDetailsPage with the specific booking
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BookingDetailsPage(
              booking: booking,
              status: 'Upcoming', // Status for Upcoming tab
              statusColor: Colors.green, // Optional: color for status
            ),
      ),
    );
  }

  void _onReorderTap(BuildContext context, BookingInfo booking) {
    // Placeholder for reorder logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reordering booking: ${booking.title}')),
    );
  }

  void _onViewReceiptTap(BuildContext context, BookingInfo booking) {
    // Placeholder for view receipt logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing receipt for: ${booking.title}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: CustomBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
              // Upcoming Bookings
              _buildBookingList(
                context,
                upcomingBookings,
                topActionLabel: 'Reschedule',
                leftActionLabel: 'View Details',
                onTopAction: (booking) => _onRescheduleTap(context, booking),
                onLeftAction: (booking) => _onViewDetailsTap(context, booking),
                onViewReceipt: (booking) => _onViewReceiptTap(context, booking),
              ),
              // Cancelled Bookings
              _buildBookingList(
                context,
                cancelledBookings,
                status: 'Cancelled',
                statusColor: Colors.red,
                showReschedule: false,
                showActionButtons: false,
                leftActionLabel: '',
              ),
              // Completed Bookings
              _buildBookingList(
                context,
                completedBookings,
                topActionLabel: 'Reorder',
                leftActionLabel: 'Reorder',
                onTopAction: (booking) => _onReorderTap(context, booking),
                onLeftAction: (booking) => _onReorderTap(context, booking),
                onViewReceipt: (booking) => _onViewReceiptTap(context, booking),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
