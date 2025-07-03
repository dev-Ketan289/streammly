import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/banner/promo_slider_model.dart';

class PromoSliderController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final CarouselController carouselController = CarouselController();
  final RxList<PromoSliderModel> promoList = <PromoSliderModel>[].obs;
  final RxBool isLoading = true.obs;

  final String baseUrl = 'http://192.168.1.113:8000/';
  final String apiUrl = 'http://192.168.1.113:8000/api/v1/basic/sliders';

  @override
  void onInit() {
    fetchPromoImages();
    super.onInit();
  }

  Future<void> fetchPromoImages() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List data = jsonData['data'];

        // Filter out entries with missing or empty image
        promoList.value = data.where((item) => item['image'] != null && item['image'].toString().trim().isNotEmpty).map((item) => PromoSliderModel.fromJson(item)).toList();
      } else {
        Get.snackbar("Error", "Failed to load sliders");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void handleTap(PromoSliderModel item) {
    if (item.url != null && item.url!.isNotEmpty) {
      Get.toNamed('/webview', arguments: item.url);
    } else if (item.categoryIds != null) {
      Get.toNamed('/category', arguments: item.categoryIds);
    } else if (item.subcategoryIds != null) {
      Get.toNamed('/subcategory', arguments: item.subcategoryIds);
    } else if (item.vendorIds != null) {
      Get.toNamed('/vendor', arguments: item.vendorIds);
    } else if (item.companyId != null) {
      Get.toNamed('/company', arguments: item.companyId);
    } else {
      Get.snackbar("No Action", "No redirection set for this banner");
    }
  }
}
