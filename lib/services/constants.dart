import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class PriceConverter {
  static convert(price) {
    return '₹ ${double.parse('$price').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    return '₹ ${double.parse('$price').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  String get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;

  //TODO: Change Base Url
  // static String baseUrl = 'https://admin.streammly.com/';
  static String baseUrl = 'http://192.168.1.113:8000/';

  static String appName = 'App Name';

  static const String agoraAppId = 'c87b710048c049f59570bd1895b7e561';

  // User
  static const String getUserProfile = 'api/v1/user/getuserprofile';
  static const String updateUserProfile = 'api/v1/user/updateuserprofile';

  // OTP
  static const String sendOtp = 'api/v1/user/auth/generateOtp';
  static const String verifyOtp = 'api/v1/user/auth/login';

  // Google
  static const String signInWithGoogle = 'api/v1/user/auth/googleLogin';

  // Extra
  static const String extras = 'api/v1/extra';

  // Category
  // Category
  static const String categoriesUrl = 'api/v1/basic/categories';

  // Home
  static const String headerSliderUrl = 'api/v1/basic/header-sliders';
  static const String recommendedCompaniesUrl = 'api/v1/company/getratingbasedrecomendedcompanies';

  // Promo Slider
  static const String slidersUrl = 'api/v1/basic/sliders';

  // Company
  static const String getCompanyLocations = 'api/v1/company/getcompanyslocations/';
  static const String getCompanyProfile = 'api/v1/company/getcompanysprofile/';
  static const String getCompanySubCategories = 'api/v1/company/getcompanysubcategories/';
  static const String getSubVerticals = 'api/v1/company/getsubvertical';

  // Bookmark
  static const String postBookmark = 'api/v1/user/togglebookmark/';
  static const String getBookMark = 'api/v1/user/getbookmark/';

  // Package
  static const String getPackagesUrl = "api/v1/package/getpackages";
  // Business Setting
  static const String businessSettingUri = "api/v1/basic/getbusinesssettings";
  //
  static const double horizontalPadding = 16;
  static const double verticalPadding = 20;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: AppConstants.horizontalPadding, vertical: AppConstants.verticalPadding);

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';
}
