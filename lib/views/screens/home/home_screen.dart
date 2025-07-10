import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/route_helper.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';
import 'package:streammly/views/screens/home/widgets/category/page_nav.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../models/category/category_item.dart';
import '../../../models/category/category_model.dart';
import '../home/widgets/category/category.dart';
import '../home/widgets/category/explore_us.dart';
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
  final HomeController headerController = Get.find<HomeController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final LocationController locationController = Get.put(LocationController());

  @override
  void initState() {
    super.initState();
    headerController.fetchSlides();
    headerController.fetchRecommendedCompanies();
    categoryController.fetchCategories();
  }

  List<CategoryItem> convertToCategoryItems(List<CategoryModel> models) {
    final String baseUrl = 'http://192.168.1.113:8000';
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
          Navigator.push(context, getCustomRoute(child: CompanyLocatorMapScreen(categoryId: model.id)));
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          final slides = headerController.headerSlides;
          final isCategoryLoading = controller.isLoading;
          final categoryModels = controller.categories;

          if (slides.isEmpty && isCategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HeaderBanner(slides: slides, height: 370, backgroundImage: "assets/images/banner.png", overlayColor: Colors.white.withValues(alpha: 0.1)),
                  const SizedBox(height: 24),
                  UpcomingOfferCard(),
                  const SizedBox(height: 24),
                  isCategoryLoading
                      ? const CircularProgressIndicator()
                      : CategoryScroller(title: "Categories", onSeeAll: () => Navigator.push(context, getCustomRoute(child: CategoryListScreen())), categories: convertToCategoryItems(categoryModels)),
                  const SizedBox(height: 24),
                  PageNav(),
                  const SizedBox(height: 24),

                  // RECOMMENDED LIST
                  GetBuilder<HomeController>(
                    builder: (headerCtrl) {
                      if (headerCtrl.isRecommendedLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (headerCtrl.recommendedVendors.isEmpty) {
                        return const Center(child: Text("No recommended vendors found."));
                      } else {
                        return RecommendedList(context: context, recommendedVendors: headerCtrl.recommendedVendors);
                      }
                    },
                  ),

                  const SizedBox(height: 24),
                  ExploreUs(vendorId: 1),
                  const SizedBox(height: 26),
                  PromoSlider(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
