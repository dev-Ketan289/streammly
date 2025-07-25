class FreeAddOn {
  final int id;
  final int packageId;
  final int productId;
  final String type;
  final String status;
  final String mainTitle;
  final String productTitle;
  final String? description;
  final String? coverImage;
  final String? usageType;

  FreeAddOn({
    required this.id,
    required this.packageId,
    required this.productId,
    required this.type,
    required this.status,
    required this.mainTitle,
    required this.productTitle,
    this.description,
    this.coverImage,
    this.usageType,
  });

  factory FreeAddOn.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    final category = product['product_and_service_category'] ?? {};
    return FreeAddOn(
      id: json['id'] ?? 0,
      packageId: json['package_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      mainTitle: category['title'] ?? '',
      productTitle: product['title'] ?? '',
      description: product['decription'] ?? product['description'],
      coverImage: product['cover_image'],
      usageType: product['product_usage_type'],
    );
  }
}

class FreeAddOnResponse {
  final List<String> mainTitles;
  final List<FreeAddOn> addons;

  FreeAddOnResponse({required this.mainTitles, required this.addons});

  factory FreeAddOnResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return FreeAddOnResponse(
      mainTitles: List<String>.from(data['main_title'] ?? []),
      addons: (data['data'] as List<dynamic>? ?? []).map((item) => FreeAddOn.fromJson(item)).toList(),
    );
  }
}
