import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/banner/banner_item.dart';

class HeaderController extends GetxController {
  RxList<BannerSlideItem> headerSlides = <BannerSlideItem>[].obs;

  Future<void> fetchSlides() async {
    try {
      final res = await http.get(Uri.parse("http://192.168.1.10:8000/api/v1/basic/header-sliders"));
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

        headerSlides.value = result;
      }
    } catch (e) {
      print("Error fetching header slides: $e");
    }
  }
}
