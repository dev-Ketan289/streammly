import 'dart:developer';

import 'package:get/get.dart';
import 'package:streammly/models/response/response_model.dart';

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

  Future<ResponseModel> fetchSlider() async {
    isHeaderLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await homeRepo.fetchHeader();
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, "Headers fetched successfully");
      } else {
        responseModel = ResponseModel(false, "Error while fetching sliders");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
    }
    isHeaderLoading = false;
    update();
    return responseModel;
  }

  Future<void> fetchSlides() async {
    isHeaderLoading = true;
    update();

    try {
      headerSlides = await homeRepo.fetchHeaderSlides();
    } catch (e) {
      log("Error fetching header slides: $e");
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
