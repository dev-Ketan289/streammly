import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../models/category/category_item.dart';
import '../../../models/category/category_model.dart';
import '../home/widgets/category/category.dart';
import '../home/widgets/category/explore_us.dart';
import '../home/widgets/category/page_nav.dart';
import '../home/widgets/category/recommended_list.dart';
import '../home/widgets/category/widgets/category_scroller.dart';
import '../home/widgets/header_banner.dart';
import '../home/widgets/promo_slider.dart';
import '../home/widgets/upcoming_offer_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HeaderController headerController = Get.put(HeaderController());
  final LocationController locationController = Get.put(LocationController());

  // Using Get.find to get the pre-initialized controller
  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    headerController.fetchSlides();
    categoryController.fetchCategories();
  }

  List<CategoryItem> convertToCategoryItems(List<CategoryModel> models) {
    const String baseUrl = 'http://192.168.1.113:8000';
    return models.map((model) {
      String? fullImageUrl;
      if (model.image != null && model.image!.isNotEmpty) {
        final path = model.image!.startsWith('/') ? model.image! : '/${model.image!}';
        fullImageUrl = '$baseUrl$path';
      }

      return CategoryItem(
        label: model.title,
        imagePath: fullImageUrl,
        onTap: () {
          //Navigate Directly to vendor Locator
          Get.to(() => CompanyLocatorMapScreen(categoryId: model.id));
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final slides = headerController.headerSlides;
        final isCategoryLoading = categoryController.isLoading.value;
        final categoryModels = categoryController.categories;

        if (slides.isEmpty && isCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderBanner(slides: slides, height: 370, backgroundImage: "assets/images/banner.png", overlayColor: Colors.white.withValues(alpha: 0.3), ),
                const SizedBox(height: 24),
                UpcomingOfferCard(),
                const SizedBox(height: 24),

                isCategoryLoading
                    ? const CircularProgressIndicator()
                    : CategoryScroller(title: "Categories", onSeeAll: () => Get.to(() => CategoryListScreen()), categories: convertToCategoryItems(categoryModels)),

                const SizedBox(height: 24),
                PageNav(),
                const SizedBox(height: 24),
                RecommendedList(context: context),
                const SizedBox(height: 24),
                ExploreUs(vendorId: 1),
                const SizedBox(height: 26),
                PromoSlider(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }
}
