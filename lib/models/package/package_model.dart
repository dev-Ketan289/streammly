class PackageModel {
  final int id;
  final int studioId;
  final String title;
  final int typeId;
  final String type;
  final String packageType;
  final String subTitle;
  final String shortDescription;
  final String longDescription;
  final String termsAndCondition;
  final bool specialOffer;
  final String? imageUpload;
  final String? offerStart;
  final String? offerEnd;
  final String? actionAfterExpiry;
  final String? markPopular;
  final List<Variation> variations;
  final List<PackageExtraQuestion> packageExtraQuestions;

  PackageModel({
    required this.id,
    required this.studioId,
    required this.title,
    required this.type,
    required this.packageType,
    required this.subTitle,
    required this.shortDescription,
    required this.longDescription,
    required this.termsAndCondition,
    required this.specialOffer,
    required this.variations,
    required this.packageExtraQuestions,
    this.imageUpload,
    this.offerStart,
    this.offerEnd,
    this.actionAfterExpiry,
    this.markPopular,
    required this.typeId,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      studioId: json['studio_id'],
      title: json['title'] ?? '',
      typeId: json['type_id'] ?? '',
      type: json['type'] ?? '',
      packageType: json['package_type'] ?? '',
      subTitle: json['sub_title'] ?? '',
      shortDescription: json['short_description'] ?? '',
      longDescription: json['long_description'] ?? '',
      termsAndCondition: json['terms_and_condition'] ?? '',
      specialOffer: (json['status'] ?? '').toString().toLowerCase() == 'active',
      imageUpload: json['image_upload'],
      offerStart: json['offer_start'],
      offerEnd: json['offer_end'],
      actionAfterExpiry: json['action_after_expiry'],
      markPopular: json['mark_popular'],
      variations: (json['packagevariations'] as List<dynamic>? ?? []).map((v) => Variation.fromJson(v)).toList(),
      packageExtraQuestions: (json['packageextra_questions'] as List<dynamic>? ?? []).map((v) => PackageExtraQuestion.fromJson(v)).toList(),
    );
  }
}

class Variation {
  final String duration;
  final String durationType;
  final String amount;
  final String? extraDurationCharge;

  Variation({required this.duration, required this.durationType, required this.amount, this.extraDurationCharge});

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      duration: json['duration']?.toString() ?? '',
      durationType: json['duration_type']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '',
      extraDurationCharge: json['extra_duration_charge']?.toString(),
    );
  }
}

class PackageExtraQuestion {
  final int id;
  final String questionType;
  final String question;

  PackageExtraQuestion({required this.id, required this.questionType, required this.question});

  factory PackageExtraQuestion.fromJson(Map<String, dynamic> json) {
    return PackageExtraQuestion(id: json['id'], questionType: json['question_type'] ?? '', question: json['question'] ?? '');
  }
}
