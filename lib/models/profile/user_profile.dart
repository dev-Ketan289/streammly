class UserProfile {
  final int id;
  final String? phone;
  final String? name;
  final String? email;
  final String status;
  final String? profileImage;
  final int userType;
  final String? dob;

  UserProfile({required this.id, this.phone, this.name, this.email, required this.status, this.profileImage, required this.userType, this.dob});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      phone: json['phone'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
      profileImage: json['profile_image'],
      userType: json['user_type'],
      dob: json['dob'],
    );
  }
}
