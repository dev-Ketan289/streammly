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

  CategoryModel({required this.id, required this.title, this.image, this.shortDescription, this.companyName, this.latitude, this.longitude});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      shortDescription: json['short_description'],
      companyName: json['company_name'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    );
  }
  bool get isBookMarked {
    return Get.find<WishlistController>().bookmarks.any((e) => id == e.id && (e.companyType?.contains("company") ?? false));
  }
}

