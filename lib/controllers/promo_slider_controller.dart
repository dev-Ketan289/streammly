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
    } catch (_) {
      promoList = [];
    }

    isLoading = false;
    update();
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    update();
  }
}
