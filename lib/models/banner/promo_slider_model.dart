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
  final int? studioId;
  final String status;

  PromoSliderModel({
    required this.id,
    required this.title,
    required this.mediaType,
    this.media,
    this.url,
    required this.bannerType,
    this.categoryIds,
    this.subcategoryIds,
    this.vendorIds,
    this.companyId,
    this.studioId,
    required this.status,
  });

  factory PromoSliderModel.fromJson(Map<String, dynamic> json) {
    return PromoSliderModel(
      id: json['id'],
      title: json['title'] ?? '',
      mediaType: json['media_type'] ?? 'image',
      media: json['media'],
      url: json['url'],
      bannerType: json['banner_type'] ?? '',
      categoryIds: _parseIdList(json['category_ids']),
      subcategoryIds: _parseIdList(json['subcategory_ids']),
      vendorIds: _parseIdList(json['vendor_ids']),
      companyId: json['company_id'],
      studioId: json['studio_id'],
      status: json['status'] ?? 'inactive',
    );
  }

  static List<int>? _parseIdList(dynamic value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return value
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .where((e) => e != null)
          .cast<int>()
          .toList();
    }
    if (value is List) return value.cast<int>();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'mediaType': mediaType,
      'media': media,
      'url': url,
      'bannerType': bannerType,
      'categoryIds': categoryIds,
      'subcategoryIds': subcategoryIds,
      'vendorIds': vendorIds,
      'companyId': companyId,
      'studioId': studioId,
      'status': status,
    };
  }
}
