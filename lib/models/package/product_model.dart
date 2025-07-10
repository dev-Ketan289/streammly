class Product {
  final int id;
  final String uniqueId;
  final String title;
  final String description;
  final String coverImage;
  final int totalQuantity;
  final String status;
  final String productUsageType;

  Product({
    required this.id,
    required this.uniqueId,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.totalQuantity,
    required this.status,
    required this.productUsageType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      uniqueId: json['unique_id'] ?? '',
      title: json['title'] ?? '',
      description: json['decription'] ?? '',
      coverImage: json['cover_image'] ?? '',
      totalQuantity: int.tryParse(json['total_quantity']?.toString() ?? '0') ?? 0,
      status: json['status'] ?? '',
      productUsageType: json['product_usage_type'] ?? '',
    );
  }
}
