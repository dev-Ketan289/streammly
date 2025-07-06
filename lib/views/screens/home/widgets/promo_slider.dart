import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controllers/promo_slider_controller.dart';
import '../../../../services/constants.dart';
import '../../common/container/circular_container.dart';

class PromoSlider extends StatefulWidget {
  const PromoSlider({super.key});

  @override
  State<PromoSlider> createState() => _PromoSliderState();
}

class _PromoSliderState extends State<PromoSlider> {
  final controller = Get.find<PromoSliderController>();

  @override
  void initState() {
    super.initState();
    controller.fetchSliders();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<PromoSliderController>(
      builder: (_) {
        if (controller.isLoading) {
          return shimmerWidget(theme);
        }

        final validSliders = controller.promoList
            .where((item) => item.media != null && item.media!.isNotEmpty)
            .toList();

        if (validSliders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            CarouselSlider(
              items: validSliders.map((item) {
                final imageUrl =
                item.media != null ? AppConstants.baseUrl + item.media! : '';
                return GestureDetector(
                  onTap: () {
                    // navigation logic here
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withAlpha(25),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => Icon(Icons.error,
                            color: theme.colorScheme.error),
                      ),
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                onPageChanged: (index, _) => controller.setCurrentIndex(index),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                validSliders.length,
                    (i) => TCircularContainer(
                  width: 20,
                  height: 4,
                  margin: const EdgeInsets.only(right: 10),
                  backgroundColor: controller.currentIndex == i
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget shimmerWidget(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest,
        highlightColor: theme.colorScheme.surface,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
