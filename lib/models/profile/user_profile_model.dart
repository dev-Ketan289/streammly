// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

class UserProfileModel {
  int? id;
  String? type;
  String? userUid;
  String? name;
  dynamic surname;
  String? email;
  dynamic primaryMobile;
  String? secondaryMobile;
  String? phone;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profileImage;
  int? userType;
  dynamic companyName;
  dynamic gstNo;
  int? wallet;
  dynamic clientId;
  String? spam;
  dynamic lastChatSeenAt;
  dynamic deviceType;
  dynamic addresss;
  dynamic deletedAt;
  DateTime? dob;
  String? gender;
  dynamic dateOfBirth;
  dynamic emailVerifiedAt;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic pincode;
  dynamic salesPerson;
  dynamic preferredStudioId;
  List<Address>? addresses;

  UserProfileModel({
    this.id,
    this.type,
    this.userUid,
    this.name,
    this.surname,
    this.email,
    this.primaryMobile,
    this.secondaryMobile,
    this.phone,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.profileImage,
    this.userType,
    this.companyName,
    this.gstNo,
    this.wallet,
    this.clientId,
    this.spam,
    this.lastChatSeenAt,
    this.deviceType,
    this.addresss,
    this.deletedAt,
    this.dob,
    this.gender,
    this.dateOfBirth,
    this.emailVerifiedAt,
    this.countryId,
    this.stateId,
    this.cityId,
    this.pincode,
    this.salesPerson,
    this.preferredStudioId,
    this.addresses,
  });

  factory UserProfileModel.fromJson(
    Map<String, dynamic> json,
  ) => UserProfileModel(
    id: json["id"],
    type: json["type"],
    userUid: json["user_uid"],
    name: json["name"],
    surname: json["surname"],
    email: json["email"],
    primaryMobile: json["primary_mobile"],
    secondaryMobile: json["secondary_mobile"],
    phone: json["phone"],
    status: json["status"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    profileImage: json["profile_image"],
    userType: json["user_type"],
    companyName: json["company_name"],
    gstNo: json["gst_no"],
    wallet: json["wallet"],
    clientId: json["client_id"],
    spam: json["spam"],
    lastChatSeenAt: json["last_chat_seen_at"],
    deviceType: json["device_type"],
    addresss: json["addresss"],
    deletedAt: json["deleted_at"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    dateOfBirth: json["date_of_birth"],
    emailVerifiedAt: json["email_verified_at"],
    countryId: json["country_id"],
    stateId: json["state_id"],
    cityId: json["city_id"],
    pincode: json["pincode"],
    salesPerson: json["sales_person"],
    preferredStudioId: json["preferred_studio_id"],
    addresses:
        json["addresses"] == null
            ? []
            : List<Address>.from(
              json["addresses"]!.map((x) => Address.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_uid": userUid,
    "name": name,
    "surname": surname,
    "email": email,
    "primary_mobile": primaryMobile,
    "secondary_mobile": secondaryMobile,
    "phone": phone,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "profile_image": profileImage,
    "user_type": userType,
    "company_name": companyName,
    "gst_no": gstNo,
    "wallet": wallet,
    "client_id": clientId,
    "spam": spam,
    "last_chat_seen_at": lastChatSeenAt,
    "device_type": deviceType,
    "addresss": addresss,
    "deleted_at": deletedAt,
    "dob":
        "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "date_of_birth": dateOfBirth,
    "email_verified_at": emailVerifiedAt,
    "country_id": countryId,
    "state_id": stateId,
    "city_id": cityId,
    "pincode": pincode,
    "sales_person": salesPerson,
    "preferred_studio_id": preferredStudioId,
    "addresses":
        addresses == null
            ? []
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
  };
}

class Address {
  int? id;
  int? userId;
  String? title;
  String? addressOne;
  String? addressTwo;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? latitude;
  String? longitude;
  int? isDefault;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Address({
    this.id,
    this.userId,
    this.title,
    this.addressOne,
    this.addressTwo,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    addressOne: json["address_one"],
    addressTwo: json["address_two"],
    landmark: json["landmark"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isDefault: json["is_default"],
    status: json["status"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "title": title,
    "address_one": addressOne,
    "address_two": addressTwo,
    "landmark": landmark,
    "city": city,
    "state": state,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "is_default": isDefault,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

