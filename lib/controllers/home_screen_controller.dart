import 'package:get/get.dart';

import '../data/repository/header_repo.dart';
import '../models/banner/banner_item.dart';

class HomeController extends GetxController {
  final HomeRepo homeRepo;

  HomeController({required this.homeRepo});

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
      headerSlides = await homeRepo.fetchHeaderSlides();
    } catch (e) {
      print("Error fetching header slides: $e");
      headerSlides = [];
    }

    isHeaderLoading = false;
    update();
  }

  Future<void> fetchRecommendedCompanies() async {
    isRecommendedLoading = true;
    update();

    try {
      recommendedCompanies = await homeRepo.fetchRecommendedCompanies();
    } catch (e) {
      print("Error fetching recommended companies: $e");
      recommendedCompanies = [];
    }

    isRecommendedLoading = false;
    update();
  }
}
