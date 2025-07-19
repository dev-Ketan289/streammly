import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';
import 'package:streammly/views/screens/home/widgets/page_nav.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/home_screen_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../models/category/category_item.dart';
import '../../../models/category/category_model.dart';
import '../../../navigation_menu.dart';
import '../../../services/constants.dart';
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
          Get.to(() => CompanyLocatorMapScreen(categoryId: model.id));
        },
      );
    }).toList();
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

            if (slides.isEmpty && isCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
            
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderBanner(
                      slides: slides,
                      height: 370,
                      backgroundImage: "assets/images/banner.png",
                      overlayColor: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 24),
                    UpcomingOfferCard(),
                    const SizedBox(height: 24),
                    isCategoryLoading
                        ? const CircularProgressIndicator()
                        : CategoryScroller(
                          title: "Categories",
                          onSeeAll: () => Get.find<NavigationController>().setIndex(5),
                          categories: convertToCategoryItems(categoryModels),
                        ),
                    const SizedBox(height: 24),
                    PageNav(),
                    const SizedBox(height: 24),

                    // RECOMMENDED LIST
                    GetBuilder<HomeController>(
                      builder: (headerCtrl) {
                        if (headerCtrl.isRecommendedLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
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
