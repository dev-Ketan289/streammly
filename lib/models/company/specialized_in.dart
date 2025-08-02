class SpecializedItem {
  final String title;
  final String image;

  SpecializedItem({required this.title, required this.image});

  factory SpecializedItem.fromJson(Map<String, dynamic> json) {
    final sub = json['subverticals'];
    return SpecializedItem(title: sub['title'] ?? '', image: sub['image'] ?? '');
  }
}
