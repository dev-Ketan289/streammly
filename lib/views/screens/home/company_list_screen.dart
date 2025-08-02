import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/services/custom_image.dart';
import 'package:streammly/services/theme.dart';
import '../../../controllers/company_controller.dart';
import '../../../controllers/category_controller.dart';
import '../vendor/vendor_description.dart';
import '../../../navigation_flow.dart';

class CompanyListScreen extends StatefulWidget {
  final int categoryId;

  const CompanyListScreen({super.key, required this.categoryId});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  @override
  void initState() {
    super.initState();
    final companyController = Get.find<CompanyController>();
    // Fetch companies only if category ID differs or no companies are loaded
    if (companyController.selectedCategoryId != widget.categoryId ||
        companyController.companies.isEmpty) {
      companyController.setCategoryId(widget.categoryId);
      companyController.fetchCompaniesByCategory(widget.categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      body: GetBuilder<CompanyController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.companies.isEmpty) {
            return const Center(child: Text('No companies available'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: controller.companies.length,
            itemBuilder: (context, index) {
              final company = controller.companies[index];
              return GestureDetector(
                onTap: () {
                  log(
                    'Navigating to VendorDescription for company: ${company.name}',
                  );
                  final mainState =
                      context.findAncestorStateOfType<NavigationFlowState>();
                  // Get.to(() => CompanyLocatorMapScreen(categoryId: cat.id));
                  mainState?.pushToCurrentTab(
                    VendorDescription(company: company),
                    hideBottomBar: true,
                  );
                },

                child: VendorRectCard(
                  logoImage: company.company?.logo ?? '',
                  companyName: company.company?.companyName ?? company.name,
                  category:
                      categoryController.categories
                          .firstWhere(
                            (cat) => cat.id == controller.selectedCategoryId,
                          )
                          .title,
                  description: company.company?.description ?? '',
                  rating:
                      company.company?.rating?.toStringAsFixed(2) ??
                      company.rating?.toStringAsFixed(2) ??
                      '3.9',
                  estimatedTime: "${company.estimatedTime} · ",
                  distanceKm:
                      company.distanceKm != null
                          ? (company.distanceKm! < 1
                              ? (company.distanceKm! * 1000).toStringAsFixed(0)
                              : "${company.distanceKm!.toStringAsFixed(1)} km")
                          : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VendorRectCard extends StatelessWidget {
  final String logoImage;
  final String companyName;
  final String category;
  final String description;
  final String? distanceKm;
  final String? estimatedTime;
  final String? rating;
  final int? vendorId;

  const VendorRectCard({
    super.key,
    required this.logoImage,
    required this.companyName,
    required this.category,
    required this.description,
    this.distanceKm,
    this.estimatedTime,
    this.rating,
    this.vendorId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth * 0.45; // Responsive width for card
    final wishlistController = Get.find<WishlistController>();

    return Container(
      padding: const EdgeInsets.all(10),
      width: itemWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE2EDF9), width: 2),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(15),
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                    bottom: Radius.circular(16),
                  ),
                  child: CustomImage(
                    path:
                        logoImage.isNotEmpty
                            ? logoImage
                            : 'assets/images/placeholder.jpg',
                    height: itemWidth * 1.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      // if (vendorId != null) {
                      //   wishlistController
                      //       .addBookmark(vendorId!, "company")
                      //       .then((value) {
                      //         if (value.isSuccess) {
                      //           wishlistController.loadBookmarks("company");
                      //         }
                      //       });
                      // }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: GetBuilder<WishlistController>(
                        builder: (controller) {
                          return Icon(
                            Icons.favorite,
                            size: 25,
                            color:
                                controller.bookmarks.any(
                                      (element) => element.id == vendorId,
                                    )
                                    ? Colors.red
                                    : Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(itemWidth * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        companyName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: itemWidth * 0.08,
                          color: theme.colorScheme.onSurface,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                    if (rating != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: itemWidth * 0.04,
                          vertical: itemWidth * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: ratingColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              rating!,
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: itemWidth * 0.075,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.star,
                              size: itemWidth * 0.075,
                              color: const Color(0xffF8DE1E),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: itemWidth * 0.015),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: itemWidth * 0.075,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: itemWidth * 0.015),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: itemWidth * 0.085,
                      color: const Color(0xffB8B7C8),
                    ),
                    SizedBox(width: itemWidth * 0.025),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            estimatedTime ?? 'N/A',
                            style: TextStyle(
                              fontSize: itemWidth * 0.065,
                              color: const Color(0xffB8B7C8),
                            ),
                          ),
                          Text(
                            distanceKm ?? 'N/A',
                            style: TextStyle(
                              fontSize: itemWidth * 0.065,
                              color: const Color(0xffB8B7C8),
                            ),
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // String _stripHtml(String html) {
  //   return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  // }
}
