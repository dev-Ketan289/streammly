import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/promo_slider_controller.dart';
import '../../../../services/theme.dart' as theme;
import '../../common/container/circular_container.dart';

class PromoSlider extends StatelessWidget {
  final PromoSliderController controller = Get.put(PromoSliderController());
  final CarouselController carouselController = CarouselController();

  PromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items:
              controller.promoImages.map((imagePath) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to some detail page
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity)),
                  ),
                );
              }).toList(),
          carouselController: CarouselSliderController(),
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              controller.currentIndex.value = index;
            },
          ),
        ),

        const SizedBox(height: 8),

        // Dot Indicator with Obx
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < 3; i++)
                    TCircularContainer(
                      width: 20,
                      height: 4,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor: controller.currentIndex.value == i ? theme.primaryColor : Colors.grey,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
