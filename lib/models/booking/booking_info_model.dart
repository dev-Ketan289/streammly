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

  factory BookingInfo.fromJson(Map<String, dynamic> json) {
    String formattedDate = '';
    String formattedTime = '';

    // Format date if needed (ex: "2025-08-05" to "Tue, 5th Aug 2025")
    try {
      final dateObj = DateTime.parse(json['date_of_shoot']);
      formattedDate =
          '${dateObj.weekdayName()}, ${dateObj.day}${dateObj.daySuffix()} ${dateObj.monthName()} ${dateObj.year}';
    } catch (_) {
      formattedDate = json['date_of_shoot'] ?? '';
    }

    try {
      final startTime = json['start_time'] ?? '';
      final endTime = json['end_time'] ?? '';
      formattedTime = '$startTime - $endTime';
    } catch (_) {
      formattedTime = '';
    }

    return BookingInfo(
      bookingId: json['order_uid'] ?? json['booking_id'] ?? '',
      otp: json['otp']?.toString() ?? '',
      title: json['package']?['title'] ?? '',
      type: json['type'] ?? '',
      location: json['address'] ?? '',
      date: formattedDate,
      time: formattedTime,
    );
  }
}

// Helper extensions for date formatting (optional)
extension DateFormatting on DateTime {
  String weekdayName() {
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[this.weekday - 1];
  }

  String monthName() {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[this.month - 1];
  }

  String daySuffix() {
    if (this.day >= 11 && this.day <= 13) return 'th';
    switch (this.day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
