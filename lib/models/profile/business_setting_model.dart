class BusinessSettings {
  final String termsAndCondition;
  final String privacyPolicy;
  final String aboutUs;
  final String contactUs;
  final String openSourceLibraries;
  final String licensesAndRegistrations;

  BusinessSettings({
    required this.termsAndCondition,
    required this.privacyPolicy,
    required this.aboutUs,
    required this.contactUs,
    required this.openSourceLibraries,
    required this.licensesAndRegistrations,
  });

  factory BusinessSettings.fromJson(Map<String, dynamic> json) {
    return BusinessSettings(
      termsAndCondition: json['terms_and_condition'] ?? "",
      privacyPolicy: json['privacy_policy'] ?? "",
      aboutUs: json['about_us'] ?? "",
      contactUs: json['contact_us'] ?? "",
      openSourceLibraries: json['open_source_libraries'] ?? "",
      licensesAndRegistrations: json['licenses_and_registrations'] ?? "",
    );
  }
}
