class BannerItem {
  final String image;        // background image
  final String title;
  final String subtitle;
  final String? vectorImage; // vector/illustration on banner

  BannerItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.vectorImage,
  });
}
