import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/banner/promo_slider_model.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';


class PromoSliderRepo {
  final ApiClient apiClient;

  PromoSliderRepo({required this.apiClient});

  Future<List<PromoSliderModel>> getSliders() async {
    final response = await apiClient.getData(AppConstants.slidersUrl); // Add this to constants
    final List<dynamic> data = response.body['data'] ?? [];
    return data.map((e) => PromoSliderModel.fromJson(e)).toList();
  }
}
