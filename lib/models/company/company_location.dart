import 'package:streammly/services/constants.dart';

class CompanyLocation {
  final int? id;
  final int? companyId; // ✅ Added to identify parent company

  final String companyName;
  final double? latitude;
  final double? longitude;
  double? distanceKm;
  String? estimatedTime;

  final String? bannerImage;
  final String? logo;
  final String? description;
  final String? categoryName;
  final double? rating;
  final List<String> specialities;
  final String? descriptionBackgroundImage;

  final Map<String, String> _specialityTitleToImage;

  CompanyLocation({
    this.id,
    this.companyId, // ✅ included in constructor
    required this.companyName,
    required this.latitude,
    required this.longitude,
    this.distanceKm,
    this.estimatedTime,
    this.bannerImage,
    this.logo,
    this.description,
    this.categoryName,
    this.rating,
    this.specialities = const [],
    this.descriptionBackgroundImage,
    Map<String, String>? specialityTitleToImage,
  }) : _specialityTitleToImage = specialityTitleToImage ?? {};

  String? getSpecialityImage(String title) {
    return _specialityTitleToImage[title];
  }

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    String fullUrl(String? path) {
      if (path == null || path.isEmpty) return '';
      if (path.startsWith('http')) return path;
      return AppConstants.baseUrl + path;
    }

    Map<String, String> extractSpecialityMap(dynamic vendorsubcategory) {
      final Map<String, String> result = {};
      if (vendorsubcategory is List) {
        for (var item in vendorsubcategory) {
          final subcategory = item['subcategory'];
          if (subcategory != null && subcategory['specialities'] != null) {
            for (var speciality in subcategory['specialities']) {
              final title = speciality['title'];
              final image = speciality['image'];
              if (title != null) {
                result[title] = fullUrl(image);
              }
            }
          }
        }
      }
      return result;
    }

    final specialityMap = extractSpecialityMap(json['vendorsubcategory']);

    return CompanyLocation(
      id: json['id'],
      companyId: json['company_id'], // ✅ fetched from API
      companyName: json['company_name'] ?? 'Unknown',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      bannerImage: fullUrl(json['banner_image']),
      logo: fullUrl(json['logo']),
      description: json['description'],
      categoryName: json['category_name'],
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) ?? 3.9 : 3.9,
      specialities: specialityMap.keys.toList(),
      descriptionBackgroundImage: fullUrl(json['description_background_image']),
      specialityTitleToImage: specialityMap,
    );
  }
}
