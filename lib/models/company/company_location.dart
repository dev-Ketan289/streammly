class CompanyLocation {
  final int? id;
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

  CompanyLocation({
    this.id,
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
  });

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    String fullUrl(String? path) {
      if (path == null || path.isEmpty) return '';
      if (path.startsWith('http')) return path;
      return 'https://appdid.blr1.digitaloceanspaces.com/$path';
    }

    List<String> extractSpecialities(dynamic vendorsubcategory) {
      final Set<String> result = {};

      if (vendorsubcategory is List) {
        for (var item in vendorsubcategory) {
          final subcategory = item['subcategory'];
          if (subcategory != null && subcategory['specialities'] != null) {
            for (var speciality in subcategory['specialities']) {
              if (speciality['title'] != null) {
                result.add(speciality['title']);
              }
            }
          }
        }
      }

      return result.toList();
    }

    return CompanyLocation(
      id: json['id'],
      companyName: json['company_name'] ?? 'Unknown',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      bannerImage: fullUrl(json['banner_image']),
      logo: fullUrl(json['logo']),
      description: json['description'],
      categoryName: json['category_name'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 3.9
          : 3.9,
      specialities: extractSpecialities(json['vendorsubcategory']),
      descriptionBackgroundImage:
      fullUrl(json['description_background_image']),
    );
  }
}
