import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/bundle/bundle_information.dart';
import 'package:streammly/views/screens/wishlist/wishlistpage.dart';

class PageNav extends StatelessWidget {
  const PageNav({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['Wishlist', 'Recommended', 'Bundles'];
    final selectedIndex = 1.obs; // Default to 'Recommended'
    final svgIcons = [
      Assets.svgWishlist, // Wishlist
      Assets.svgDiamondhome, // Recommended
      Assets.svgDiamondhome, // Bundles
    ];
    final theme = Theme.of(context);

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(40)),
                      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(filters.length, (index) {
                          final isSelected = selectedIndex.value == index;

                          return GestureDetector(
                            onTap: () async {
                              selectedIndex.value = index;

                              if (filters[index] == 'Bundles') {
                                await Get.to(() => const BundleInformation());
                                selectedIndex.value = 1;
                              } else if (filters[index] == 'Wishlist') {
                                await Get.to(() => WishlistPage());
                                selectedIndex.value = 1;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  SvgPicture.asset(svgIcons[index], width: 12, height: 10),
                                  const SizedBox(width: 4),
                                  Text(
                                    filters[index],
                                    style: TextStyle(fontSize: 9, color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to full list
            },
            child: Row(
              children: [
                Text("See all", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 14, color: primaryColor),
                SizedBox(width: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
