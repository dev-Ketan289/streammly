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
  });

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    String fullUrl(String? path) {
      if (path == null || path.isEmpty) return '';
      return path.replaceFirst(RegExp(r'^/+'), '');
    }

    return CompanyLocation(
      id: json['id'],
      companyName: json['company_name'] ?? 'Unknown',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      bannerImage: fullUrl(json['banner_image']),
      logo: fullUrl(json['logo']),
      description: json['description'],
      categoryName: json['category_name'],
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) ?? 3.9 : 3.9,
      specialities: json['specialitise'] != null ? List<String>.from(json['specialitise']) : [],
    );
  }
}
