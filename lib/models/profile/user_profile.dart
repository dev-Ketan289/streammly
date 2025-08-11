class UserProfile {
  final int id;
  final String? phone;             // Primary phone
  final String? secondaryMobile;   // Alternate phone
  final String? name;
  final String? email;
  final String status;
  final String? profileImage;
  final int userType;
  final String? dob;
  final String? gender;
  final double? wallet;

  UserProfile({
    required this.id,
    this.phone,
    this.secondaryMobile,
    this.name,
    this.email,
    required this.status,
    this.profileImage,
    required this.userType,
    this.dob,
    this.gender,
    this.wallet,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      phone: json['phone'],                           // Keep primary
      secondaryMobile: json['secondary_mobile'],      // Keep alternate
      name: json['name'],
      email: json['email'],
      status: json['status'],
      profileImage: json['profile_image'],
      userType: json['user_type'],
      dob: json['dob'],
      gender: json['gender'],
      wallet: json['wallet'] != null
          ? (json['wallet'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'secondary_mobile': secondaryMobile,
      'name': name,
      'email': email,
      'status': status,
      'profile_image': profileImage,
      'user_type': userType,
      'dob': dob,
      'gender': gender,
      'wallet': wallet,
    };
  }
}
