import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoSliderController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final PageController pageController = PageController();
  final CarouselController carouselController = CarouselController();

  final List<String> promoImages = [
    'assets/images/recommended_banner/PromoSlider.jpg',
    'assets/images/recommended_banner/PromoSlider.jpg',
    'assets/images/recommended_banner/PromoSlider.jpg',
  ];

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
