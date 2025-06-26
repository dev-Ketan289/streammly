import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageNav extends StatelessWidget {
  const PageNav({super.key});

  @override
  Widget build(BuildContext context) {
    final filters = ['Wishlist', 'Recommended', 'Bundles'];
    final selectedIndex = 1.obs; // Default to 'Recommended'

    final icons = [Icons.favorite, Icons.recommend, Icons.card_giftcard];

    return Stack(
      children: [
        Row(
          children: [
            // Expanded to prevent overflow
            Expanded(
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 1,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(filters.length, (index) {
                          final isSelected = selectedIndex.value == index;

                          return GestureDetector(
                            onTap: () => selectedIndex.value = index,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    icons[index],
                                    size: 16,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    filters[index],
                                    style: TextStyle(
                                      fontSize: 9,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
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
            // const SizedBox(width: 8),
            // InkWell(
            //   onTap: () {
            //     // TODO: Navigate to full list
            //   },
            //   child: Row(
            //     children: const [
            //       Text(
            //         "See all",
            //         style: TextStyle(
            //           color: Colors.blue,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 13,
            //         ),
            //       ),
            //       SizedBox(width: 4),
            //       Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
            //     ],
            //   ),
            // ),
          ],
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0 ,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to full list
            },
            child: Row(
              children: const [
                Text(
                  "See all",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
