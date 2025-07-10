import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/services/constants.dart';

import '../../../../../controllers/category_controller.dart';
import '../../../../../navigation_menu.dart';
import '../../../common/images/rounded_image.dart';
import '../../vendor_locator.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final CategoryController controller = Get.find<CategoryController>();
  final wishlistcontroller = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wishlistcontroller.loadBookmarks();
      // wishlistController.loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      bottomNavigationBar: NavigationHelper.buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: Text(
          "Categories",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
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
                  Get.to(() => CompanyLocatorMapScreen(categoryId: cat.id));
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
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TRoundedImage(
                                imageUrl: "${AppConstants.baseUrl}${cat.image}",
                                height: 100,
                                width: 380,
                                fit: BoxFit.cover,
                                borderRadius: 16,
                                isNetworkImage: true,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GetBuilder<WishlistController>(
                              builder: (wishlistController) {
                                return GestureDetector(
                                  onTap: () {
                                    wishlistController
                                        .addBookmark(cat.id, "category")
                                        .then((value) {
                                          if (value.isSuccess) {
                                            wishlistController.loadBookmarks();
                                          }
                                        });

                                    // if (isToggled) {
                                    //   isToggled = !isToggled;

                                    // }
                                  },

                                  child: Icon(
                                    Icons.bookmark,
                                    size: 25,
                                    color:
                                        cat.isBookMarked
                                            ? Colors.red
                                            : Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
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
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
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
    );
  }
}
