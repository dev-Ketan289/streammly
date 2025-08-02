class Speciality {
  final int id;
  final int categoryId;
  final String title;
  final String? image;
  final String status;

  Speciality({required this.id, required this.categoryId, required this.title, this.image, required this.status});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(id: json['id'], categoryId: json['category_id'], title: json['title'] ?? '', image: json['image'], status: json['status'] ?? '');
  }
}
