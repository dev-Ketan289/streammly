import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/banner/banner_item.dart';

class HomeController extends GetxController {
  List<BannerSlideItem> headerSlides = [];
  List<Map<String, dynamic>> recommendedCompanies = [];

  bool isHeaderLoading = true;
  bool isRecommendedLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchSlides();
    fetchRecommendedCompanies();
  }

  Future<void> fetchSlides() async {
    isHeaderLoading = true;
    update();

    try {
      final res = await http.get(Uri.parse("http://192.168.1.113:8000/api/v1/basic/header-sliders"));
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        final List data = json['data'];
        final List<BannerSlideItem> result = [];

        for (var item in data) {
          for (var img in item['header_slider_images']) {
            if (img['header_slider_id'] == item['id']) {
              result.add(BannerSlideItem.fromJson(parent: item, image: img));
            }
          }
        }

        headerSlides = result;
      }
    } catch (e) {
      print("Error fetching header slides: $e");
    }

    isHeaderLoading = false;
    update();
  }

  Future<void> fetchRecommendedCompanies() async {
    isRecommendedLoading = true;
    update();

    const url = "http://192.168.1.113:8000/api/v1/company/getratingbasedrecomendedcompanies";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List allCompanies = data["data"] ?? [];

        recommendedCompanies = allCompanies.where((c) => (c["rating"] ?? 0) >= 4).cast<Map<String, dynamic>>().toList();
      }
    } catch (e) {
      print("Error fetching recommended companies: $e");
    }

    isRecommendedLoading = false;
    update();
  }
}
