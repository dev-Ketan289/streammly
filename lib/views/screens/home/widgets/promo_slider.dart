import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/promo_slider_controller.dart';
import '../../../../services/theme.dart' as theme;
import '../../common/container/circular_container.dart';

class PromoSlider extends StatelessWidget {
  final PromoSliderController controller = Get.put(PromoSliderController());

  PromoSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          CarouselSlider(
            items:
                controller.promoList.map((item) {
                  final imageUrl = controller.baseUrl + item.media;
                  return GestureDetector(
                    onTap: () => controller.handleTap(item),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) => const Icon(Icons.error)),
                      ),
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    controller.promoList.length,
                    (i) => TCircularContainer(
                      width: 20,
                      height: 4,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor: controller.currentIndex.value == i ? theme.primaryColor : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
