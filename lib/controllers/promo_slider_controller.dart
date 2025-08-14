import 'package:get/get.dart';

import '../../models/banner/promo_slider_model.dart';
import '../data/repository/promo_slider_repo.dart';

class PromoSliderController extends GetxController {
  final PromoSliderRepo promoSliderRepo;

  PromoSliderController({required this.promoSliderRepo});

  List<PromoSliderModel> promoList = [];
  bool isLoading = true;
  int currentIndex = 0;

  Future<void> fetchSliders() async {
    isLoading = true;
    update();

    try {
      promoList = await promoSliderRepo.getSliders();

      // Debug: Log each slider's data
      for (int i = 0; i < promoList.length; i++) {
        final item = promoList[i];
        print(
          'Slider $i: ID=${item.id}, StudioID=${item.studioId}, '
          'CompanyID=${item.companyId}, Categories=${item.categoryIds}, '
          'SubCategories=${item.subcategoryIds}, Vendors=${item.vendorIds}',
        );
      }
    } catch (e) {
      promoList = [];
      print('Error fetching sliders: $e');
    }

    isLoading = false;
    update();
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    update();
  }
}
