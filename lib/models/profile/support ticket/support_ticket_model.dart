class SupportTicket {
  final int id;
  final int userId;
  final int? companyDepartmentId;
  final String title;
  final String description;
  final String? referenceImage;
  final String platform;
  final String important;
  final int? companyId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupportTicket({
    required this.id,
    required this.userId,
    required this.companyDepartmentId,
    required this.title,
    required this.description,
    required this.referenceImage,
    required this.platform,
    required this.important,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'],
      userId: json['user_id'],
      companyDepartmentId: json['company_department_id'],
      title: json['title'],
      description: json['description'],
      referenceImage: json['reference_image'],
      platform: json['platform'],
      important: json['important'],
      companyId: json['company_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
