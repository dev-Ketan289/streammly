class PopularPackage {
  final int id;
  final String title;
  final String type;
  final String? subTitle;
  final String? description;
  final String image;
  final List<dynamic> variations;
  final List<dynamic> extraQuestions;

  PopularPackage({
    required this.id,
    required this.title,
    required this.type,
    required this.image,
    required this.variations,
    required this.extraQuestions,
    this.subTitle,
    this.description,
  });

  factory PopularPackage.fromJson(Map<String, dynamic> json) {
    final variations = json['packagevariations'] ?? [];
    return PopularPackage(
      id: json['id'],
      title: json['title'] ?? '',
      type: json['type'] ?? 'N/A',
      subTitle: json['sub_title'],
      description: json['short_description'] ?? json['long_description'],
      image:
          (json['image_upload'] != null && json['image_upload'] != '')
              ? 'https://admin.streammly.com/${json["image_upload"]}'
              : 'assets/images/category/vendor_category/Baby.jpg',
      variations: variations,
      extraQuestions: json['packageextra_questions'] ?? [],
    );
  }
}
