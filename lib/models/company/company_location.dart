import 'package:streammly/services/constants.dart';

class CompanyLocation {
  // Primary identifiers and location
  final int id;
  final int companyId;
  final String type;
  final String name;
  final String companyName;
  final double? latitude;
  final double? longitude;
  double? distance; // from backend
  double? distanceKm; // for client-calculated (optional)
  String? estimatedTime;

  // Contact and address
  final String? address;
  final String? mapLink;
  final String? line1;
  final String? line2;
  final String? pincode;
  final String? supportNumber;
  final String? status;

  // Branding and visuals
  final String? logo;
  final String? bannerImage;
  final String? descriptionBackgroundImage;
  final String? description;
  final String? categoryName;

  // Ratings, etc
  final double? rating;

  // Specialities and mapping
  final List<String> specialities;
  final Map<String, String> _specialityTitleToImage;

  // Nested objects (optional)
  final StudioLocation? studioLocation;
  final CompanyDetails? company;

  CompanyLocation({
    required this.id,
    required this.companyId,
    required this.type,
    required this.name,
    required this.companyName,
    this.latitude,
    this.longitude,
    this.distance,
    this.distanceKm,
    this.estimatedTime,
    this.address,
    this.mapLink,
    this.line1,
    this.line2,
    this.pincode,
    this.supportNumber,
    this.status,
    this.logo,
    this.bannerImage,
    this.descriptionBackgroundImage,
    this.description,
    this.categoryName,
    this.rating,
    this.specialities = const [],
    Map<String, String>? specialityTitleToImage,
    this.studioLocation,
    this.company,
  }) : _specialityTitleToImage = specialityTitleToImage ?? {};

  /// Get image URL for a given speciality title
  String? getSpecialityImage(String title) => _specialityTitleToImage[title];

  // Use company fallback if field is null or empty
  String? get effectiveBannerImage => (bannerImage != null && bannerImage!.isNotEmpty) ? bannerImage : company?.bannerImage;

  String? get effectiveLogo => (logo != null && logo!.isNotEmpty) ? logo : company?.logo;

  String get effectiveCompanyName => companyName.isNotEmpty ? companyName : company?.companyName ?? name;

  factory CompanyLocation.fromJson(Map<String, dynamic> json) {
    String fullUrl(String? path) {
      if (path == null || path.isEmpty) return '';
      if (path.startsWith('http')) return path;
      return AppConstants.baseUrl + path;
    }

    Map<String, String> extractSpecialityMap(dynamic vendorsubcategory) {
      final Map<String, String> result = {};
      if (vendorsubcategory is List) {
        for (var item in vendorsubcategory) {
          final subcategory = item['subcategory'];
          if (subcategory != null && subcategory['specialities'] != null) {
            for (var speciality in subcategory['specialities']) {
              final title = speciality['title'];
              final image = speciality['image'];
              if (title != null) {
                result[title] = fullUrl(image);
              }
            }
          }
        }
      }
      return result;
    }

    final specialityMap = extractSpecialityMap(json['vendorsubcategory']);

    return CompanyLocation(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      companyId: (json['company_id'] is int) ? json['company_id'] : int.tryParse(json['company_id'].toString()) ?? 0,
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      companyName: json['company_name'] ?? json['name'] ?? '',
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      distance: json['distance'] != null ? double.tryParse(json['distance'].toString()) : null,
      address: json['address'],
      mapLink: json['map_link'],
      line1: json['line1'],
      line2: json['line2'],
      pincode: json['pincode']?.toString(),
      supportNumber: json['support_number'],
      status: json['status'],
      logo: fullUrl(json['logo']),
      bannerImage: fullUrl(json['banner_image']),
      descriptionBackgroundImage: fullUrl(json['description_background_image']),
      description: json['description'],
      categoryName: json['category_title'],
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      specialities: specialityMap.keys.toList(),
      specialityTitleToImage: specialityMap,
      studioLocation: json['studiolocation'] != null ? StudioLocation.fromJson(json['studiolocation']) : null,
      company: json['company'] != null ? CompanyDetails.fromJson(json['company']) : null,
    );
  }
}

// --- Nested StudioLocation model ---

class StudioLocation {
  final int id;
  final int studioId;
  final int? typeId;
  final String? type;
  final String? bufferTime;
  final String? status;
  final List<WorkingDay> workingDays;
  final List<WorkingDay> working_days; // support both camel and snake

  StudioLocation({required this.id, required this.studioId, this.typeId, this.type, this.bufferTime, this.status, this.workingDays = const [], this.working_days = const []});

  factory StudioLocation.fromJson(Map<String, dynamic> json) {
    return StudioLocation(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      studioId: (json['studio_id'] is int) ? json['studio_id'] : int.tryParse(json['studio_id'].toString()) ?? 0,
      typeId: json['type_id'] != null ? (json['type_id'] is int ? json['type_id'] : int.tryParse(json['type_id'].toString())) : null,
      type: json['type'],
      bufferTime: json['buffer_time'],
      status: json['status'],
      workingDays: (json['workingDays'] as List?)?.map((w) => WorkingDay.fromJson(w)).toList() ?? [],
      working_days: (json['working_days'] as List?)?.map((w) => WorkingDay.fromJson(w)).toList() ?? [],
    );
  }
}

// --- Nested WorkingDay Model ---

class WorkingDay {
  final int id;
  final int studioId;
  final int studioLocationId;
  final String day;
  final String? status;
  final List<WorkingHour> workingHours;

  WorkingDay({required this.id, required this.studioId, required this.studioLocationId, required this.day, this.status, this.workingHours = const []});

  factory WorkingDay.fromJson(Map<String, dynamic> json) {
    return WorkingDay(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      studioId: (json['studio_id'] is int) ? json['studio_id'] : int.tryParse(json['studio_id'].toString()) ?? 0,
      studioLocationId: (json['studio_location_id'] is int) ? json['studio_location_id'] : int.tryParse(json['studio_location_id'].toString()) ?? 0,
      day: json['day'] ?? '',
      status: json['status'],
      workingHours: (json['working_hours'] as List?)?.map((w) => WorkingHour.fromJson(w)).toList() ?? [],
    );
  }
}

// --- Nested WorkingHour Model ---

class WorkingHour {
  final int id;
  final int studioLocationId;
  final int slWorkingDayId;
  final String startTime;
  final String endTime;
  final String? status;

  WorkingHour({required this.id, required this.studioLocationId, required this.slWorkingDayId, required this.startTime, required this.endTime, this.status});

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      id: (json['id'] is int) ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      studioLocationId: (json['studio_location_id'] is int) ? json['studio_location_id'] : int.tryParse(json['studio_location_id'].toString()) ?? 0,
      slWorkingDayId: (json['sl_working_day_id'] is int) ? json['sl_working_day_id'] : int.tryParse(json['sl_working_day_id'].toString()) ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      status: json['status'],
    );
  }
}

// --- CompanyDetails for fallback branding ---

class CompanyDetails {
  final int id;
  final String companyName;
  final String? logo;
  final String? bannerImage;
  final String? descriptionBackgroundImage;
  final String? description;
  final double? rating;
  final String? categoryName;
  final int? advanceDayBooking;

  CompanyDetails({
    required this.id,
    required this.companyName,
    this.logo,
    this.bannerImage,
    this.descriptionBackgroundImage,
    this.advanceDayBooking,
    this.description,
    this.rating,
    this.categoryName,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      id: json['id'],
      companyName: json['company_name'] ?? '',
      logo: json['logo'],
      bannerImage: json['banner_image'],
      descriptionBackgroundImage: json['description_background_image'],
      description: json['description'],
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      categoryName: json['category_title'],
      advanceDayBooking: int.tryParse(json['advance_day_booking'].toString()) ?? 0,
    );
  }

  String? get fullLogoUrl => logo;
  String? get fullBannerImageUrl => bannerImage;
}
