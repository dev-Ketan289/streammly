class CategoryModel {
  final int id;
  final String title;
  final String image;
  final String? shortDescription;

  CategoryModel({required this.id, required this.title, required this.image, this.shortDescription});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], title: json['title'], image: json['image'], shortDescription: json['short_description']);
  }
}
