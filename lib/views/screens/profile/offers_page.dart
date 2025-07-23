import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/category_controller.dart';
import 'package:streammly/models/category/category_item.dart';
import 'package:streammly/models/category/category_model.dart';
import 'package:streammly/services/custom_image.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/category_scroller.dart';
import 'package:streammly/views/screens/profile/components/company_card.dart';
import 'package:streammly/views/screens/profile/components/scallop_divider.dart';

class OffersPage extends StatelessWidget {
  const OffersPage({super.key});

  List<CategoryItem> _convertToCategoryItems(List<CategoryModel> models) {
    return models
        .map(
          (model) => CategoryItem(
            label: model.title,
            imagePath: model.icon,
            onTap:
                () =>
                    Get.to(() => CompanyLocatorMapScreen(categoryId: model.id)),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              SizedBox(height: 30),
              const CompanyCard(),
              _buildCategorySection(),
              _buildSliderSection(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: primaryColor),
          child: Image.asset(Assets.imagesOffersDoodle),
        ),
        Positioned(
          left: 30,
          bottom: 25,
          child: RichText(
            text: TextSpan(
              text: 'Great\n',
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontSize: 38,
              ),
              children: [
                TextSpan(
                  text: 'Offers',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 146,
          right: 12,
          child: SvgPicture.asset(Assets.svgOffers),
        ),
        const Positioned(top: 275, left: 0, right: 0, child: ScallopDivider()),
      ],
    );
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
              title: 'Categories',
              onSeeAll: () => Get.to(const CategoryListScreen()),
              categories: _convertToCategoryItems(controller.categories),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSliderSection(ThemeData theme) {
    int count = 5;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          count,
          (index) => Container(
            margin: const EdgeInsets.all(12),
            height: 200,
            width: 340,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                CustomImage(
                  path: Assets.imagesOfferslide,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  left: 23,
                  bottom: 23,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(primaryColor),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      fixedSize: WidgetStatePropertyAll(const Size(93, 33)),
                    ),
                    child: Text(
                      "Book Now",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
