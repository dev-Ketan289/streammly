import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/home/widgets/home_header_banner.dart';
import 'package:streammly/views/screens/home/widgets/page_nav.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../models/category/category_item.dart';
import '../../../models/category/category_model.dart';
import '../home/widgets/category/explore_us.dart';
import '../home/widgets/category/recommended_list.dart';
import '../home/widgets/category/widgets/category_scroller.dart';
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
  final LocationController locationController = Get.find<LocationController>();
  final CompanyController companyController = Get.find<CompanyController>();

  @override
  void initState() {
    super.initState();
    headerController.fetchSlides();
    headerController.fetchRecommendedCompanies();
    categoryController.fetchCategories();
    companyController.fetchCompanyById(1);
  }

  List<CategoryItem> convertToCategoryItems(List<CategoryModel> models) {
    return models.map((model) {
      return CategoryItem(
        label: model.title,
        imagePath: model.icon,
        onTap: () {
          final mainState = context.findAncestorStateOfType<NavigationFlowState>();
          mainState?.pushToCurrentTab(CompanyLocatorMapScreen(categoryId: model.id), hideBottomBar: true);
        },
      );
    }).toList();
  }

  // SHIMMER PLACEHOLDERS

  Widget _shimmerCategoryScroller() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 18, width: 120, color: Colors.white, margin: EdgeInsets.symmetric(horizontal: 16)),
          SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              padding: EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => SizedBox(width: 16),
              itemBuilder: (_, __) => Container(width: 65, height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerRecommendedList() {
    return ListView.separated(
      itemCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(margin: EdgeInsets.symmetric(horizontal: 16), height: 66, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
        );
      },
    );
  }

  Widget _shimmerHomeHeaderBanner() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(margin: EdgeInsets.all(16.0), height: 150, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: GetBuilder<CategoryController>(
          builder: (controller) {
            final slides = headerController.headerSlides;
            final isCategoryLoading = controller.isLoading;
            final categoryModels = controller.categories;

            // Main Shimmer Condition for Banner and Category list
            if (slides.isEmpty && isCategoryLoading) {
              return SafeArea(child: Column(children: [SizedBox(height: 20), _shimmerHomeHeaderBanner(), SizedBox(height: 24), _shimmerCategoryScroller()]));
            }

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    slides.isEmpty ? _shimmerHomeHeaderBanner() : HomeHeaderBanner(slides: slides),
                    const SizedBox(height: 24),
                    UpcomingOfferCard(),
                    const SizedBox(height: 24),
                    isCategoryLoading
                        ? _shimmerCategoryScroller()
                        : CategoryScroller(
                          title: "Categories",
                          onSeeAll: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryListScreen()));
                          },
                          categories: convertToCategoryItems(categoryModels),
                        ),
                    const SizedBox(height: 24),
                    PageNav(),
                    const SizedBox(height: 24),

                    // RECOMMENDED LIST shimmer
                    GetBuilder<HomeController>(
                      builder: (headerCtrl) {
                        if (headerCtrl.isRecommendedLoading) {
                          return _shimmerRecommendedList();
                        } else if (headerCtrl.recommendedVendors.isEmpty) {
                          return const Center(child: Text("No recommended vendors found."));
                        } else {
                          return RecommendedList(context: context, recommendedVendors: headerCtrl.recommendedVendors);
                        }
                      },
                    ),

                    const SizedBox(height: 24),
                    ExploreUs(vendorIds: ([1])),
                    const SizedBox(height: 26),
                    PromoSlider(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
