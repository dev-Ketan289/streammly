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
  static String baseUrl = 'http://192.168.1.10:8000/';
  // static String baseUrl = 'http://192.168.1.5:9000/'; ///USE FOR LOCAL
  //TODO: Change Base Url
  static String appName = 'App Name';

  static const String agoraAppId = 'c87b710048c049f59570bd1895b7e561';

  // Auth
  static const String sendOtp = 'api/v1/user/auth/generateOtp';

  static const String extras = 'api/v1/extra';

  //
  static const double horizontalPadding = 16;
  static const double verticalPadding = 20;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: AppConstants.horizontalPadding,
    vertical: AppConstants.verticalPadding,
  );

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';
}
