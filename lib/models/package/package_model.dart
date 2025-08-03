class PackageModel {
  final int id;
  final String uniqueId;
  final int? vendorId;
  final int? categoryId;
  final int? subCategoryId;
  final int companyId;
  final int typeId;
  final String type;
  final String packageType;
  final String title;
  final String subTitle;
  final String? description;
  final String? imageUpload;
  final int? noOfFreeEditImages;
  final String? extraImageEditCharge;
  final String? offerStart;
  final String? offerEnd;
  final String? actionAfterExpiry;
  final String? shortDescription;
  final String? longDescription;
  final String? termsAndCondition;
  final double? gst;
  final String status;
  final int studioId;
  final int subVerticalId;
  final String? markPopular;
  final int? paymentTermId;
  final List<Variation> variations;
  final List<PackageExtraQuestion> packageExtraQuestions;

  PackageModel({
    required this.id,
    required this.uniqueId,
    this.vendorId,
    this.categoryId,
    this.subCategoryId,
    required this.companyId,
    required this.typeId,
    required this.type,
    required this.packageType,
    required this.title,
    required this.subTitle,
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
    required this.status,
    required this.studioId,
    required this.subVerticalId,
    this.markPopular,
    this.paymentTermId,
    required this.variations,
    required this.packageExtraQuestions,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      uniqueId: json['unique_id'] ?? '',
      vendorId: json['vendor_id'],
      categoryId: json['category_id'],
      subCategoryId: json['sub_category_id'],
      companyId: json['company_id'],
      typeId: json['type_id'],
      type: json['type'] ?? '',
      packageType: json['package_type'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['sub_title'] ?? '',
      description: json['description'],
      imageUpload: json['image_upload'],
      noOfFreeEditImages: json['no_of_free_edit_images'],
      extraImageEditCharge: json['extra_image_edit_charge']?.toString(),
      offerStart: json['offer_start'],
      offerEnd: json['offer_end'],
      actionAfterExpiry: json['action_after_expiry'],
      shortDescription: json['short_description'],
      longDescription: json['long_description'],
      termsAndCondition: json['terms_and_condition'],
      gst: json['gst'] != null ? double.tryParse(json['gst'].toString()) : null,
      status: json['status'] ?? '',
      studioId: json['studio_id'],
      subVerticalId: json['sub_vertical_id'],
      markPopular: json['mark_popular'],
      paymentTermId: json['payment_term_id'],
      variations: (json['packagevariations'] as List<dynamic>? ?? [])
          .map((v) => Variation.fromJson(v))
          .toList(),
      packageExtraQuestions: (json['packageextra_questions'] as List<dynamic>? ?? [])
          .map((v) => PackageExtraQuestion.fromJson(v))
          .toList(),
    );
  }
}

class Variation {
  final int id;
  final String? uniqueId;
  final int packageId;
  final String durationType;
  final String duration;
  final String amount;
  final String? extraDurationCharge;
  final String status;

  Variation({
    required this.id,
    this.uniqueId,
    required this.packageId,
    required this.durationType,
    required this.duration,
    required this.amount,
    this.extraDurationCharge,
    required this.status,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      uniqueId: json['unique_id'],
      packageId: json['package_id'],
      durationType: json['duration_type'] ?? '',
      duration: json['duration']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      extraDurationCharge: json['extra_duration_charge']?.toString(),
      status: json['status'] ?? '',
    );
  }
}

class PackageExtraQuestion {
  final int id;
  final String? uniqueId;
  final int packageId;
  final int? extraQuestionId;
  final String questionType;
  final String question;
  final String status;

  PackageExtraQuestion({
    required this.id,
    this.uniqueId,
    required this.packageId,
    this.extraQuestionId,
    required this.questionType,
    required this.question,
    required this.status,
  });

  factory PackageExtraQuestion.fromJson(Map<String, dynamic> json) {
    return PackageExtraQuestion(
      id: json['id'],
      uniqueId: json['unique_id'],
      packageId: json['package_id'],
      extraQuestionId: json['extra_question_id'],
      questionType: json['question_type'] ?? '',
      question: json['question'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
