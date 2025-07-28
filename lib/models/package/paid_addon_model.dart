class PaidAddOn {
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
  final int? price;
  final int? studioId; // For debug/tracking

  PaidAddOn({
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
    this.price,
    this.studioId,
  });

  factory PaidAddOn.fromJson(Map<String, dynamic> json, {int? studioId}) {
    final product = json['product'] ?? {};
    final category = product['product_and_service_category'] ?? {};

    // Find studio-specific price from product_details
    int? parsedPrice;
    final productDetails = product['product_details'] as List<dynamic>? ?? [];

    if (studioId != null && productDetails.isNotEmpty) {
      final detail = productDetails.firstWhere((e) => e['studio_id']?.toString() == studioId.toString(), orElse: () => null);
      if (detail != null && detail['price'] != null) {
        parsedPrice = int.tryParse(detail['price'].toString());
      }
    }

    // Fallback to general product price if studio-specific not found
    parsedPrice ??= int.tryParse(product['price']?.toString() ?? '');

    return PaidAddOn(
      id: json['id'] ?? 0,
      packageId: json['package_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      mainTitle: category['title'] ?? '',
      productTitle: product['title'] ?? '',
      description: product['description'] ?? product['decription'], // typo fallback
      coverImage: product['cover_image'],
      usageType: product['product_usage_type'],
      price: parsedPrice,
      studioId: studioId,
    );
  }
}

class PaidAddOnResponse {
  final List<String> mainTitles;
  final List<PaidAddOn> addons;

  PaidAddOnResponse({required this.mainTitles, required this.addons});

  factory PaidAddOnResponse.fromJson(Map<String, dynamic> json, {int? studioId}) {
    final data = json['data'] ?? {};
    final List<dynamic> rawAddons = data['data'] ?? [];

    final List<PaidAddOn> filteredAddons =
        rawAddons
            .where((item) {
              final product = item['product'];
              final productDetails = product?['product_details'] as List<dynamic>? ?? [];

              // If studioId is null, include all
              if (studioId == null) return true;

              // Only include products with matching studio_id in product_details
              return productDetails.any((detail) => detail['studio_id']?.toString() == studioId.toString());
            })
            .map((item) => PaidAddOn.fromJson(item, studioId: studioId))
            .toList();

    return PaidAddOnResponse(mainTitles: List<String>.from(data['main_title'] ?? []), addons: filteredAddons);
  }
}
