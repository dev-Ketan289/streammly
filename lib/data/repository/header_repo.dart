import 'package:get/get.dart';

import '../../../models/banner/banner_item.dart';
import '../../../services/constants.dart';
import '../../data/api/api_client.dart';

class HomeRepo {
  final ApiClient apiClient;

  HomeRepo({required this.apiClient});
  Future<Response> fetchHeader() async =>
      await apiClient.getData(AppConstants.headerSliderUrl);

  Future<List<BannerSlideItem>> fetchHeaderSlides() async {
    final res = await apiClient.getData(AppConstants.headerSliderUrl);
    final List data = res.body['data'] ?? [];
    final List<BannerSlideItem> result = [];

    for (var item in data) {
      for (var img in item['header_slider_images']) {
        if (img['header_slider_id'] == item['id']) {
          result.add(BannerSlideItem.fromJson(parent: item, image: img));
        }
      }
    }

    return result;
  }

  Future<Response> fetchRecommendedCompanies() async =>
      await apiClient.getData(AppConstants.recommendedCompaniesUrl);

  // Future<List<Map<String, dynamic>>> fetchRecommendedCompanies() async {
  //   final res = await apiClient.getData(AppConstants.recommendedCompaniesUrl);
  //   final List data = res.body['data'] ?? [];

  //   return data
  //       .where((c) => (c["rating"] ?? 0) >= 4)
  //       .cast<Map<String, dynamic>>()
  //       .toList();
  // }
}
