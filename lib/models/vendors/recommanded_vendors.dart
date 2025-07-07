import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';

class RecommendedVendors {
  int? id;
  dynamic uniqueId;
  dynamic vendorId;
  String? companyName;
  String? companyOwnerName;
  String? email;
  String? phone;
  String? password;
  dynamic isVerified;
  dynamic isFeatured;
  String? logo;
  String? bannerImage;
  String? companyType;
  String? gstno;
  int? rating;
  String? line1;
  String? line2;
  String? country;
  String? state;
  String? city;
  int? pincode;
  String? latitude;
  String? longitude;
  String? bankName;
  String? branchName;
  String? accountHolderName;
  String? accountNo;
  String? ifscCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  String? description;
  dynamic rememberToken;
  dynamic deletedAt;
  List<Vendorcategory>? vendorcategory;

  RecommendedVendors({
    this.id,
    this.uniqueId,
    this.vendorId,
    this.companyName,
    this.companyOwnerName,
    this.email,
    this.phone,
    this.password,
    this.isVerified,
    this.isFeatured,
    this.logo,
    this.bannerImage,
    this.companyType,
    this.gstno,
    this.rating,
    this.line1,
    this.line2,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.latitude,
    this.longitude,
    this.bankName,
    this.branchName,
    this.accountHolderName,
    this.accountNo,
    this.ifscCode,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.description,
    this.rememberToken,
    this.deletedAt,
    this.vendorcategory,
  });

  factory RecommendedVendors.fromJson(
    Map<String, dynamic> json,
  ) => RecommendedVendors(
    id: json["id"],
    uniqueId: json["unique_id"],
    vendorId: json["vendor_id"],
    companyName: json["company_name"],
    companyOwnerName: json["company_owner_name"],
    email: json["email"],
    phone: json["phone"],
    password: json["password"],
    isVerified: json["is_verified"],
    isFeatured: json["is_featured"],
    logo: json["logo"],
    bannerImage: json["banner_image"],
    companyType: json["company_type"],
    gstno: json["gstno"],
    rating: json["rating"],
    line1: json["line1"],
    line2: json["line2"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    bankName: json["bank_name"],
    branchName: json["branch_name"],
    accountHolderName: json["account_holder_name"],
    accountNo: json["account_no"],
    ifscCode: json["ifsc_code"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    description: json["description"],
    rememberToken: json["remember_token"],
    deletedAt: json["deleted_at"],
    vendorcategory:
        json["vendorcategory"] == null
            ? []
            : List<Vendorcategory>.from(
              json["vendorcategory"]!.map((x) => Vendorcategory.fromJson(x)),
            ),
  );
  bool get isChecked {
    return Get.find<WishlistController>().bookmarks.any(
      (e) =>
          id == e.bookmarkableId &&
          (e.bookmarkableType?.contains("VendorCompany") ?? false),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "vendor_id": vendorId,
    "company_name": companyName,
    "company_owner_name": companyOwnerName,
    "email": email,
    "phone": phone,
    "password": password,
    "is_verified": isVerified,
    "is_featured": isFeatured,
    "logo": logo,
    "banner_image": bannerImage,
    "company_type": companyType,
    "gstno": gstno,
    "rating": rating,
    "line1": line1,
    "line2": line2,
    "country": country,
    "state": state,
    "city": city,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "bank_name": bankName,
    "branch_name": branchName,
    "account_holder_name": accountHolderName,
    "account_no": accountNo,
    "ifsc_code": ifscCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "description": description,
    "remember_token": rememberToken,
    "deleted_at": deletedAt,
    "vendorcategory":
        vendorcategory == null
            ? []
            : List<dynamic>.from(vendorcategory!.map((x) => x.toJson())),
  };
}

class Vendorcategory {
  int? id;
  dynamic uniqueId;
  int? companyId;
  dynamic vendorId;
  int? categoryId;
  dynamic subCategoryId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  dynamic deletedAt;
  GetCategory? getCategory;

  Vendorcategory({
    this.id,
    this.uniqueId,
    this.companyId,
    this.vendorId,
    this.categoryId,
    this.subCategoryId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
    this.getCategory,
  });

  factory Vendorcategory.fromJson(Map<String, dynamic> json) => Vendorcategory(
    id: json["id"],
    uniqueId: json["unique_id"],
    companyId: json["company_id"],
    vendorId: json["vendor_id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    deletedAt: json["deleted_at"],
    getCategory:
        json["get_category"] == null
            ? null
            : GetCategory.fromJson(json["get_category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "company_id": companyId,
    "vendor_id": vendorId,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "deleted_at": deletedAt,
    "get_category": getCategory?.toJson(),
  };
}

class GetCategory {
  int? id;
  String? title;
  String? image;
  String? shortDescription;
  String? uniqueId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  dynamic deletedAt;

  GetCategory({
    this.id,
    this.title,
    this.image,
    this.shortDescription,
    this.uniqueId,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
  });

  factory GetCategory.fromJson(Map<String, dynamic> json) => GetCategory(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    shortDescription: json["short_description"],
    uniqueId: json["unique_id"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "short_description": shortDescription,
    "unique_id": uniqueId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "deleted_at": deletedAt,
  };
}
