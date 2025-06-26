class CompanySubCategory {
  final int id;
  final String title;
  final String image;

  CompanySubCategory({required this.id, required this.title, required this.image});

  factory CompanySubCategory.fromJson(Map<String, dynamic> json) {
    return CompanySubCategory(id: json['id'], title: json['title'] ?? 'No Title', image: json['image'] ?? '');
  }
}
