class Product {
  final int id;
  final String uniqueId;
  final String title;
  final String description;
  final String coverImage;
  final String productUsageType;

  Product({
    required this.id,
    required this.uniqueId,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.productUsageType,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      uniqueId: json['unique_id'],
      title: json['title'],
      description: json['decription'] ?? '',
      coverImage: json['cover_image'],
      productUsageType: json['product_usage_type'],
    );
  }
}

class ProductInPackage {
  final int id;
  final int quantity;
  final String dataRequestStage;
  final Product product;

  ProductInPackage({
    required this.id,
    required this.quantity,
    required this.dataRequestStage,
    required this.product,
  });

  factory ProductInPackage.fromJson(Map<String, dynamic> json) {
    return ProductInPackage(
      id: json['id'],
      quantity: json['quantity'],
      dataRequestStage: json['data_request_stage'] ?? '',
      product: Product.fromJson(json['products']),
    );
  }
}

class ProductCategory {
  final String title;
  final List<ProductInPackage> items;

  ProductCategory({
    required this.title,
    required this.items,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      title: json['product_and_service_category']['title'] ?? '',
      items: (json['product_in_packages'] as List)
          .map((e) => ProductInPackage.fromJson(e))
          .toList(),
    );
  }
}
