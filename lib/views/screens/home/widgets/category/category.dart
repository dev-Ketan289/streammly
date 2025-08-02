import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../../../controllers/category_controller.dart';
import '../../../../../navigation_flow.dart';
import '../../../common/images/rounded_image.dart';
import '../../vendor_locator.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryController controller = Get.find<CategoryController>();
  // final wishlistcontroller = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Categorie's",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          centerTitle: true,
          // leading: IconButton(
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new,
          //     color: Color(0xff666666),
          //   ),
          //   onPressed: () {
          //     if (Navigator.canPop(context)) {
          //       Get.back();
          //     } else {
          //       // Optional: navigate to home or dashboard
          //       Get.offAll(() => const NavigationMenu());
          //     }
          //   },
          // ),
        ),
        body: GetBuilder<CategoryController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.categories.isEmpty) {
              return Center(
                child: Text(
                  "No categories found.",
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final cat = controller.categories[index];

                return GestureDetector(
                  onTap: () {
                    final mainState =
                        context.findAncestorStateOfType<NavigationFlowState>();
                    // Get.to(() => CompanyLocatorMapScreen(categoryId: cat.id));
                    mainState?.pushToCurrentTab(
                      CompanyLocatorMapScreen(categoryId: cat.id),
                      hideBottomBar: true,
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(40),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 15,
                                  right: 15,
                                ),
                                child: TRoundedImage(
                                  imageUrl: cat.image ?? '',
                                  height: 100,
                                  width: 380,
                                  fit: BoxFit.fill,
                                  borderRadius: 16,
                                  isNetworkImage: true,
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: 10,
                            //   right: 10,
                            //   child: GetBuilder<WishlistController>(
                            //     builder: (wishlistController) {
                            //       return GestureDetector(
                            //         onTap: () {
                            //           wishlistController
                            //               .addBookmark(cat.id, "category")
                            //               .then((value) {
                            //                 if (value.isSuccess) {
                            //                   wishlistController
                            //                       .loadBookmarks("category");
                            //                 }
                            //               });
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.fromLTRB(
                            //             10,
                            //             5,
                            //             10,
                            //             10,
                            //           ),
                            //           child: Container(
                            //             height: 30,
                            //             width: 30,
                            //             decoration: BoxDecoration(
                            //               color: backgroundLight.withAlpha(70),
                            //               borderRadius: BorderRadius.circular(
                            //                 10,
                            //               ),
                            //             ),
                            //             child: Icon(
                            //               Icons.bookmark_rounded,
                            //               size: 25,
                            //               color:
                            //                   cat.isBookMarked
                            //                       ? Colors.red
                            //                       : Colors.white,
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.title,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat.shortDescription ??
                                    "No description available",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
