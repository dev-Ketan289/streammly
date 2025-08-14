import '../../booking/booking_info_model.dart';

class SupportTicket {
  final int id;
  final String? status;
  final int userId;
  final int? companyDepartmentId;
  final String title;
  final String description;
  final String? referenceImage;
  final String platform;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final String important;
  final int? companyId;
  final int? bookingId;
  final BookingInfo? booking;

  const SupportTicket({
    required this.id,
    this.status,
    required this.userId,
    this.companyDepartmentId,
    required this.title,
    required this.description,
    this.referenceImage,
    required this.platform,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.important,
    this.companyId,
    this.bookingId,
    this.booking,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? 0,
      status: json['status'],
      userId: json['user_id'] ?? 0,
      companyDepartmentId: json['company_department_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      referenceImage: json['reference_image'],
      platform: json['platform'] ?? '',
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      important: json['important'] ?? '',
      companyId: json['company_id'],
      bookingId: json['booking_id'],
      booking:
          json['booking'] != null
              ? BookingInfo.fromJson(json['booking'] as Map<String, dynamic>)
              : null,
    );
  }

  // Helper methods for status
  bool get isPending => status == 'pending' || status == null;
  bool get isResolved => status == 'resolved';
  bool get isRejected => status == 'rejected';

  String get displayStatus {
    if (status == null) return 'Pending';
    switch (status!.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'resolved':
        return 'Resolved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  String get displayBookingId {
    return booking?.bookingId ?? 'N/A';
  }
}
