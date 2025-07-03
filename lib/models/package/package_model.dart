class PackageModel {
  final int id;
  final String title;
  final String type;
  final String shortDescription;
  final String longDescription;
  final bool specialOffer;
  final List<Variation> variations;

  PackageModel({
    required this.id,
    required this.title,
    required this.type,
    required this.shortDescription,
    required this.longDescription,
    required this.specialOffer,
    required this.variations,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      shortDescription: json['short_description'] ?? '',
      longDescription: json['long_description'] ?? '',
      specialOffer: (json['status'] ?? '').toString().toLowerCase() == 'active',
      variations: (json['packagevariations'] as List<dynamic>? ?? []).map((v) => Variation.fromJson(v)).toList(),
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
