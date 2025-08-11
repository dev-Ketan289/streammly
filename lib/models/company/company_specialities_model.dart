// // To parse this JSON data, do
// //
// //     final companySpecialities = companySpecialitiesFromJson(jsonString);

// import 'dart:convert';

// List<CompanySpecialities> companySpecialitiesFromJson(String str) => List<CompanySpecialities>.from(json.decode(str).map((x) => CompanySpecialities.fromJson(x)));

// String companySpecialitiesToJson(List<CompanySpecialities> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanySpecialities {
    int? id;
    int? subCategoryId;
    int? specialityId;
    dynamic createdAt;
    dynamic updatedAt;
    String? status;
    dynamic deletedAt;
    Speciality? speciality;

    CompanySpecialities({
        this.id,
        this.subCategoryId,
        this.specialityId,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.deletedAt,
        this.speciality,
    });

    factory CompanySpecialities.fromJson(Map<String, dynamic> json) => CompanySpecialities(
        id: json["id"],
        subCategoryId: json["sub_category_id"],
        specialityId: json["speciality_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        status: json["status"],
        deletedAt: json["deleted_at"],
        speciality: json["speciality"] == null ? null : Speciality.fromJson(json["speciality"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "sub_category_id": subCategoryId,
        "speciality_id": specialityId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "status": status,
        "deleted_at": deletedAt,
        "speciality": speciality?.toJson(),
    };
}

class Speciality {
    int? id;
    int? categoryId;
    String? title;
    String? image;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? status;
    dynamic deletedAt;

    Speciality({
        this.id,
        this.categoryId,
        this.title,
        this.image,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.deletedAt,
    });

    factory Speciality.fromJson(Map<String, dynamic> json) => Speciality(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        image: json["image"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        status: json["status"],
        deletedAt: json["deleted_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "image": image,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "status": status,
        "deleted_at": deletedAt,
    };
}
