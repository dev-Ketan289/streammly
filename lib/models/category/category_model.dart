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

  CategoryModel({
    required this.id,
    required this.title,
    this.image,
    this.shortDescription,
    this.companyName,
    this.latitude,
    this.longitude,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      shortDescription: json['short_description'],
      companyName: json['company_name'],
      latitude:
          json['latitude'] != null
              ? double.tryParse(json['latitude'].toString())
              : null,
      longitude:
          json['longitude'] != null
              ? double.tryParse(json['longitude'].toString())
              : null,
    );
  }
  bool get isBookMarked {
    return Get.find<WishlistController>().bookmarks.any(
      (e) => id == e.bookmarkableId,
    );
  }
}

class WishlistModel {
  int? id;
  int? userId;
  String? bookmarkableType;
  int? bookmarkableId;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  WishlistModel({
    this.id,
    this.userId,
    this.bookmarkableType,
    this.bookmarkableId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
    id: json["id"],
    userId: json["user_id"],
    bookmarkableType: json["bookmarkable_type"],
    bookmarkableId: json["bookmarkable_id"],
    deletedAt: json["deleted_at"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "bookmarkable_type": bookmarkableType,
    "bookmarkable_id": bookmarkableId,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
  };
}
