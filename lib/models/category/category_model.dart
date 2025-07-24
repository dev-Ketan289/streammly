import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';

class CategoryModel {
  final int id;
  final String title;
  final String? image;
  final String? shortDescription;
  final String? companyName;
  final double? latitude;
  final double? longitude;
  final String? icon;

  CategoryModel({required this.id, required this.title, this.image, this.shortDescription, this.companyName, this.latitude, this.longitude, this.icon});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'],
      image: json['image'],
      shortDescription: json['short_description'],
      companyName: json['company_name'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      icon: json['icon'],
    );
  }

  bool get isBookMarked {
    return Get.find<WishlistController>().bookmarks.any((e) => id == e.id && (e.companyType?.contains("company") ?? false));
  }
}

class VendorCategory {
  final int id;
  final int companyId;
  final int categoryId;
  final int? subCategoryId;

  VendorCategory({required this.id, required this.companyId, required this.categoryId, this.subCategoryId});

  factory VendorCategory.fromJson(Map<String, dynamic> json) {
    return VendorCategory(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      companyId: (json['company_id'] is int) ? json['company_id'] : int.tryParse(json['company_id'].toString()) ?? 0,
      categoryId: (json['category_id'] is int) ? json['category_id'] : int.tryParse(json['category_id'].toString()) ?? 0,
      subCategoryId: json['sub_category_id'] != null ? int.tryParse(json['sub_category_id'].toString()) : null,
    );
  }
}
