class BannerSlideItem {
  final String title;
  final String description;
  final String vectorImage;
  final bool isSvg;

  BannerSlideItem({required this.title, required this.description, required this.vectorImage, required this.isSvg});

  factory BannerSlideItem.fromJson({required Map<String, dynamic> parent, required Map<String, dynamic> image}) {
    return BannerSlideItem(title: parent['title'], description: parent['description'], vectorImage: image['image'], isSvg: image['image'].toString().endsWith(".svg"));
  }
}
