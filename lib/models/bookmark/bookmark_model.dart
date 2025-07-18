import 'dart:convert';

List<RecommendedVendors> recommendedVendorsFromJson(String str) =>
    List<RecommendedVendors>.from(
      json.decode(str).map((x) => RecommendedVendors.fromJson(x)),
    );

String recommendedVendorsToJson(List<RecommendedVendors> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecommendedVendors {
  int? id;
  String? uniqueId;
  dynamic vendorId;
  dynamic categoryId;
  int? subCategoryId;
  int? companyId;
  int? typeId;
  String? type;
  String? packageType;
  String? title;
  String? subTitle;
  dynamic description;
  dynamic imageUpload;
  dynamic noOfFreeEditImages;
  dynamic extraImageEditCharge;
  DateTime? offerStart;
  DateTime? offerEnd;
  String? actionAfterExpiry;
  String? shortDescription;
  String? longDescription;
  String? termsAndCondition;
  dynamic gst;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  dynamic deletedAt;
  int? studioId;
  int? subVerticalId;
  String? markPopular;

  RecommendedVendors({
    this.id,
    this.uniqueId,
    this.vendorId,
    this.categoryId,
    this.subCategoryId,
    this.companyId,
    this.typeId,
    this.type,
    this.packageType,
    this.title,
    this.subTitle,
    this.description,
    this.imageUpload,
    this.noOfFreeEditImages,
    this.extraImageEditCharge,
    this.offerStart,
    this.offerEnd,
    this.actionAfterExpiry,
    this.shortDescription,
    this.longDescription,
    this.termsAndCondition,
    this.gst,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.deletedAt,
    this.studioId,
    this.subVerticalId,
    this.markPopular,
  });

  factory RecommendedVendors.fromJson(
    Map<String, dynamic> json,
  ) => RecommendedVendors(
    id: json["id"],
    uniqueId: json["unique_id"],
    vendorId: json["vendor_id"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    companyId: json["company_id"],
    typeId: json["type_id"],
    type: json["type"],
    packageType: json["package_type"],
    title: json["title"],
    subTitle: json["sub_title"],
    description: json["description"],
    imageUpload: json["image_upload"],
    noOfFreeEditImages: json["no_of_free_edit_images"],
    extraImageEditCharge: json["extra_image_edit_charge"],
    offerStart:
        json["offer_start"] == null
            ? null
            : DateTime.parse(json["offer_start"]),
    offerEnd:
        json["offer_end"] == null ? null : DateTime.parse(json["offer_end"]),
    actionAfterExpiry: json["action_after_expiry"],
    shortDescription: json["short_description"],
    longDescription: json["long_description"],
    termsAndCondition: json["terms_and_condition"],
    gst: json["gst"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    deletedAt: json["deleted_at"],
    studioId: json["studio_id"],
    subVerticalId: json["sub_vertical_id"],
    markPopular: json["mark_popular"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "unique_id": uniqueId,
    "vendor_id": vendorId,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "company_id": companyId,
    "type_id": typeId,
    "type": type,
    "package_type": packageType,
    "title": title,
    "sub_title": subTitle,
    "description": description,
    "image_upload": imageUpload,
    "no_of_free_edit_images": noOfFreeEditImages,
    "extra_image_edit_charge": extraImageEditCharge,
    "offer_start":
        "${offerStart!.year.toString().padLeft(4, '0')}-${offerStart!.month.toString().padLeft(2, '0')}-${offerStart!.day.toString().padLeft(2, '0')}",
    "offer_end":
        "${offerEnd!.year.toString().padLeft(4, '0')}-${offerEnd!.month.toString().padLeft(2, '0')}-${offerEnd!.day.toString().padLeft(2, '0')}",
    "action_after_expiry": actionAfterExpiry,
    "short_description": shortDescription,
    "long_description": longDescription,
    "terms_and_condition": termsAndCondition,
    "gst": gst,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "deleted_at": deletedAt,
    "studio_id": studioId,
    "sub_vertical_id": subVerticalId,
    "mark_popular": markPopular,
  };
}
