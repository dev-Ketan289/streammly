import 'dart:developer';
import 'package:get/get.dart';
import 'package:streammly/controllers/promo_slider_controller.dart';
import 'package:streammly/data/api/api_client.dart';
import 'package:streammly/data/repository/promo_slider_repo.dart';
import 'package:streammly/models/response/response_model.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';
import 'package:streammly/services/constants.dart';
import '../data/repository/header_repo.dart';
import '../models/banner/banner_item.dart';
import '../controllers/category_controller.dart';
import '../controllers/booking_form_controller.dart';
import '../controllers/company_controller.dart';

class HomeController extends GetxController {
  final HomeRepo homeRepo;
  HomeController({required this.homeRepo});

  List<BannerSlideItem> headerSlides = [];
  List<RecommendedVendors> recommendedVendors = [];

  bool isHeaderLoading = false;
  bool isRecommendedLoading = false;

  @override
  void onInit() {
    super.onInit();
    refreshHome(); // fetch on init
  }

  /// 🔹 This will reload all API data for Home tab
  void refreshHome() {
    fetchSlides();
    fetchRecommendedCompanies();
    Get.find<CategoryController>().fetchCategories();
    Get.find<CompanyController>().fetchCompanyById(1);
    Get.find<BookingController>().fetchBookings();
    Get.put(PromoSliderController(promoSliderRepo: PromoSliderRepo(apiClient: ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()))));
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

  Future<ResponseModel> fetchRecommendedCompanies() async {
    isRecommendedLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await homeRepo.fetchRecommendedCompanies();
      log("${response.bodyString}", name: "fetchRecommendedCompanies");
      if (response.statusCode == 200) {
        recommendedVendors =
            (response.body['data'] as List<dynamic>)
                .map((item) => RecommendedVendors.fromJson(item))
                .toList();
        responseModel = ResponseModel(true, "Recommended vendors fetched");
      } else {
        responseModel =
            ResponseModel(false, "Error while fetching recommended vendors");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
    }
    isRecommendedLoading = false;
    update();
    return responseModel;
  }
}
