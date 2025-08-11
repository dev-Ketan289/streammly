import 'package:intl/intl.dart';

class BookingInfo {
  final int id; // booking internal ID, e.g. 10
  final String bookingId; // order_uid, e.g. "BK05082025010"
  final String otp;
  final String title;
  final String type;
  final String location;
  final String date;
  final String time;

  const BookingInfo({
    required this.id,
    required this.bookingId,
    required this.otp,
    required this.title,
    required this.type,
    required this.location,
    required this.date,
    required this.time,
  });

  factory BookingInfo.fromJson(Map<String, dynamic> booking) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final time =
        (booking['start_time'] ?? '') + " - " + (booking['end_time'] ?? '');

    String formattedDate = '';
    try {
      final parsedDate = DateTime.parse(booking['date_of_shoot']);
      formattedDate = dateFormat.format(parsedDate);
    } catch (_) {}

    return BookingInfo(
      id:
          booking['id'] is int
              ? booking['id']
              : int.tryParse(booking['id'].toString()) ?? 0,
      bookingId: booking['order_uid'] ?? '',
      otp: booking['otp'] ?? '',
      title: booking['package']?['title'] ?? '',
      type: booking['type'] ?? '',
      location: booking['location']?['address'] ?? 'No location',
      date: formattedDate,
      time: time,
    );
  }
}
