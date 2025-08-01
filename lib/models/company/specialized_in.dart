class SpecializedItem {
  final String title;
  final String image;

  SpecializedItem({required this.title, required this.image});

  factory SpecializedItem.fromJson(Map<String, dynamic> json) {
    final sub = json['subverticals'];
    if (sub is Map<String, dynamic>) {
      return SpecializedItem(title: sub['title'] ?? '', image: sub['image'] ?? '');
    } else {
      // fallback or log error
      return SpecializedItem(title: '', image: '');
    }
  }
}
