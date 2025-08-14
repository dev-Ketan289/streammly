import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controllers/promo_slider_controller.dart';

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

        final validSliders =
            controller.promoList
                .where((item) => item.media != null && item.media!.isNotEmpty)
                .toList();

        if (validSliders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            CarouselSlider(
              items:
                  validSliders.map((item) {
                    // final imageUrl = item.media != null ? AppConstants.baseUrl + item.media! : '';
                    return GestureDetector(
                      onTap: () async {
                        // // Debug current item data
                        // print(
                        //   'Tapped slider: ${item.toJson()}',
                        // ); // Add toJson() method to model
                        //
                        // if (item.studioId != null && item.companyId != null) {
                        //   final companyController =
                        //       Get.find<CompanyController>();
                        //
                        //   try {
                        //     final companyLocation = await companyController
                        //         .fetchAndCacheCompanyById(item.companyId!);
                        //
                        //     if (companyLocation != null) {
                        //       final navigationState =
                        //           context
                        //               .findAncestorStateOfType<
                        //                 NavigationFlowState
                        //               >();
                        //
                        //       navigationState?.pushToCurrentTab(
                        //         VendorDetailScreen(studio: companyLocation),
                        //         hideBottomBar: false,
                        //         transitionType: PageTransitionType.rightToLeft,
                        //       );
                        //     } else {
                        //       Get.snackbar(
                        //         "Error",
                        //         "Unable to load vendor details",
                        //       );
                        //     }
                        //   } catch (e) {
                        //     Get.snackbar("Error", "Something went wrong: $e");
                        //   }
                        // } else {
                        //   // Show which IDs are missing
                        //   final missing = <String>[];
                        //   if (item.studioId == null) missing.add('studioId');
                        //   if (item.companyId == null) missing.add('companyId');
                        //
                        //   Get.snackbar(
                        //     "Debug",
                        //     "Missing: ${missing.join(', ')}",
                        //   );
                        // }
                      },

                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xffE2EDF9),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withAlpha(25),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(
                            item.media!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                            errorBuilder:
                                (_, __, ___) => Icon(
                                  Icons.image_not_supported,
                                  color: theme.colorScheme.error,
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                ),
                              );
                            },
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

            // Replaced Row with custom ExpandingDotIndicator below
            ExpandingDotIndicator(
              count: validSliders.length,
              activeIndex: controller.currentIndex,
              activeColor: theme.colorScheme.primary,
              inactiveColor: theme.colorScheme.outlineVariant,
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

// Custom expanding dot indicator widget
class ExpandingDotIndicator extends StatelessWidget {
  final int count;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;

  const ExpandingDotIndicator({
    super.key,
    required this.count,
    required this.activeIndex,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(right: 10),
          width: isActive ? 20 : 4,
          height: 4,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }
}
