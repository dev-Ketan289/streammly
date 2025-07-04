class PackageModel {
  final int id;
  final String title;
  final String type;
  final String shortDescription;
  final String longDescription;
  final String termsAndCondition;
  final bool specialOffer;
  final List<Variation> variations;
  final List<PackageExtraQuestion> packageExtraQuestions;

  PackageModel({
    required this.id,
    required this.title,
    required this.type,
    required this.shortDescription,
    required this.longDescription,
    required this.termsAndCondition,
    required this.specialOffer,
    required this.variations,
    required this.packageExtraQuestions,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      shortDescription: json['short_description'] ?? '',
      longDescription: json['long_description'] ?? '',
      termsAndCondition: json['terms_and_condition'] ?? '',
      specialOffer: (json['status'] ?? '').toString().toLowerCase() == 'active',
      variations: (json['packagevariations'] as List<dynamic>? ?? []).map((v) => Variation.fromJson(v)).toList(),
      packageExtraQuestions: (json['packageextra_questions'] as List<dynamic>? ?? []).map((v) => PackageExtraQuestion.fromJson(v)).toList(), // <-- Parsing extra questions
    );
  }
}

class Variation {
  final String duration;
  final String durationType;
  final String amount;

  Variation({required this.duration, required this.durationType, required this.amount});

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(duration: json['duration']?.toString() ?? '', durationType: json['duration_type']?.toString() ?? '', amount: json['amount']?.toString() ?? '');
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
