import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/controllers/category_controller.dart';
import 'package:streammly/controllers/home_screen_controller.dart';
import 'package:streammly/models/category/category_item.dart';
import 'package:streammly/models/category/category_model.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';
import 'package:streammly/views/screens/home/widgets/category/recommended_list.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/category_scroller.dart';
import 'package:streammly/views/screens/home/widgets/promo_slider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mock recent searches list
    final List<String> recentSearches = [
      'Wedding Photographer',
      'Makeup Artist',
      'DJ Services',
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Search',
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 37,

                      width: 350,
                      padding: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.colorScheme.onSurface.withAlpha(60),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        decoration: InputDecoration(
                          hintText:
                              "Search for vendors, services, or event types...",
                          hintStyle: GoogleFonts.openSans(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                            fontSize: 10,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 16),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.restore, color: Colors.black),
                      const SizedBox(width: 5),
                      Text(
                        "Recent Searches",
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recentSearches.length,
                    itemBuilder: (context, index) {
                      final search = recentSearches[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: GestureDetector(
                          onTap: () {
                            log('Tapped on: $search');
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.history, color: Colors.grey),
                              const SizedBox(width: 5),
                              Text(
                                search,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildCategorySection(),
                GetBuilder<HomeController>(
                  builder: (headerCtrl) {
                    if (headerCtrl.isRecommendedLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (headerCtrl.recommendedVendors.isEmpty) {
                      return const Center(
                        child: Text("No recommended vendors found."),
                      );
                    } else {
                      return RecommendedList(
                        context: context,
                        recommendedVendors: headerCtrl.recommendedVendors,
                      );
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Text(
                    "Exclusive Offers",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                PromoSlider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCategorySection() {
  return GetBuilder<CategoryController>(
    builder: (controller) {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          CategoryScroller(
            // title: 'Categories',
            // onSeeAll: () => Get.to(const CategoryListScreen()),
            categories: _convertToCategoryItems(controller.categories),
          ),
        ],
      );
    },
  );
}

List<CategoryItem> _convertToCategoryItems(List<CategoryModel> models) {
  return models
      .map(
        (model) => CategoryItem(
          label: model.title,
          imagePath: model.icon,
          onTap:
              () => Get.to(() => CompanyLocatorMapScreen(categoryId: model.id)),
        ),
      )
      .toList();
}
