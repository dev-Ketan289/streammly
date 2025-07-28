import '../../services/constants.dart';

class Company {
  final int id;
  final String companyName;
  final String? logo;
  final String? bannerImage;
  final String? descriptionBackgroundImage;
  final double? rating;
  final int? categoryId;
  final String? categoryName;

  Company({required this.id, required this.companyName, this.logo, this.bannerImage, this.descriptionBackgroundImage, this.rating, this.categoryId, this.categoryName});

  factory Company.fromJson(Map<String, dynamic> json) {
    String fullUrl(String? path) {
      if (path == null || path.isEmpty) return '';
      if (path.startsWith('http')) return path;
      return AppConstants.baseUrl + path;
    }

    return Company(
      id: json['id'],
      companyName: json['company_name'] ?? '',
      logo: fullUrl(json['logo']),
      bannerImage: fullUrl(json['banner_image']),
      descriptionBackgroundImage: fullUrl(json['description_background_image']),
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      categoryId: json['category_id'], // <-- NEW
      categoryName: json['category_name'], // <-- NEW
    );
  }
}
