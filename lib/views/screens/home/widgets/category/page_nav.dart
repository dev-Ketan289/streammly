import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/bundle/bundle_information.dart';
import 'package:streammly/views/screens/wishlist/wishlistpage.dart';

class PageNav extends StatelessWidget {
  const PageNav({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['Wishlist', 'Recommended', 'Bundles'];
    final selectedIndex = 1.obs; // Default to 'Recommended'
    final icons = [Icons.favorite, Icons.recommend, Icons.card_giftcard];
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
                                await Navigator.push(context, getCustomRoute(child: const BundleInformation()));
                                selectedIndex.value = 1;
                              } else if (filters[index] == 'Wishlist') {
                                await Navigator.push(context, getCustomRoute(child: Wishlistpage()));
                                selectedIndex.value = 1;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  Icon(icons[index], size: 16, color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant),
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
                Text("See all", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500, fontSize: 13)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
