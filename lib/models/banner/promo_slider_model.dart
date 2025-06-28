class PromoSliderModel {
  final int id;
  final String title;
  final String mediaType;
  final String? media;
  final String? url;
  final String bannerType;
  final List<int>? categoryIds;
  final List<int>? subcategoryIds;
  final List<int>? vendorIds;
  final int? companyId;
  final String status;

  PromoSliderModel({
    required this.id,
    required this.title,
    required this.mediaType,
    this.media,
    required this.url,
    required this.bannerType,
    required this.categoryIds,
    required this.subcategoryIds,
    required this.vendorIds,
    required this.companyId,
    required this.status,
  });

  factory PromoSliderModel.fromJson(Map<String, dynamic> json) {
    return PromoSliderModel(
      id: json['id'],
      title: json['title'] ?? '',
      mediaType: json['media_type'] ?? 'image',
      media: json['media'],
      url: json['url'],
      bannerType: json['banner_type'],
      categoryIds: _parseIdList(json['category_ids']),
      subcategoryIds: _parseIdList(json['subcategory_ids']),
      vendorIds: _parseIdList(json['vendor_ids']),
      companyId: json['company_id'],
      status: json['status'] ?? 'inactive',
    );
  }

  static List<int>? _parseIdList(dynamic value) {
    if (value == null) return null;
    if (value is List) return value.cast<int>();
    return null;
  }
}
