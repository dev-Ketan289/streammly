class SubVertical {
  final int id;
  final String title;
  final String? image;

  SubVertical({required this.id, required this.title, this.image});

  factory SubVertical.fromJson(Map<String, dynamic> json) {
    final rawPath = json['image'] ?? '';
    final cleanedPath = rawPath.toString().replaceFirst(RegExp(r'^/+'), '');

    return SubVertical(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      image: cleanedPath.isNotEmpty ? cleanedPath : null,
    );
  }
}
