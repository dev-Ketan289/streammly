import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../models/category/category_item.dart';
import '../../../models/company/company_location.dart';
import '../home/widgets/category/review_card.dart';
import '../home/widgets/category/widgets/category_scroller.dart';
import '../home/widgets/header_banner.dart';
import 'vendor_group.dart';

class VendorDetailScreen extends StatefulWidget {
  final CompanyLocation studio;

  const VendorDetailScreen({super.key, required this.studio});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final CompanyController companyController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      companyController.fetchCompanySubCategories(widget.studio.companyId);
      companyController.fetchSpecialized(widget.studio.companyId);
      companyController.fetchPopularPackages(
        widget.studio.companyId,
        widget.studio.id, // Use the studio ID from your CompanyLocation object
      );
    });
  }

  String resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return url.startsWith('http') ? url : url.replaceFirst(RegExp(r'^/'), '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.04;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- Header Banner ----
                GetBuilder<CompanyController>(
                  builder: (controller) {
                    final specialized = controller.specialized;
                    return HeaderBanner(
                      height: screenWidth * 0.7,
                      backgroundImage:
                          (widget.studio.company?.bannerImage?.isNotEmpty ==
                                  true)
                              ? resolveImageUrl(
                                widget.studio.company?.bannerImage,
                              )
                              : 'assets/images/recommended_banner/FocusPointVendor.png',
                      overlayColor: primaryColor.withValues(alpha: 0.6),
                      overrideTitle: widget.studio.company?.companyName,
                      overrideSubtitle: widget.studio.categoryName,
                      specialized: specialized,
                    );
                  },
                ),

                SizedBox(height: screenWidth * 0.02),

                // ---- Category Scroller (Subcategories) ----
                GetBuilder<CompanyController>(
                  builder: (controller) {
                    final subs = controller.subCategories;

                    if (subs.isEmpty) {
                      return CategoryScroller(
                        categories:
                            subs.map((sub) {
                              return CategoryItem(
                                label: sub.title,
                                imagePath: resolveImageUrl(sub.image),
                                onTap: () {
                                  final mainState =
                                      context
                                          .findAncestorStateOfType<
                                            NavigationFlowState
                                          >();

                                  // Add a smooth transition delay
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () {
                                      mainState?.pushToCurrentTab(
                                        VendorGroup(
                                          studio: widget.studio,
                                          subCategoryId: sub.id,
                                        ),
                                        hideBottomBar: false,
                                      );
                                    },
                                  );
                                },
                              );
                            }).toList(),
                      );
                    }

                    return CategoryScroller(
                      categories:
                          subs.map((sub) {
                            return CategoryItem(
                              label: sub.title,
                              imagePath: resolveImageUrl(sub.image),
                              onTap: () {
                                final mainState =
                                    context
                                        .findAncestorStateOfType<
                                          NavigationFlowState
                                        >();
                                mainState?.pushToCurrentTab(
                                  VendorGroup(
                                    studio: widget.studio,
                                    subCategoryId: sub.id,
                                  ),
                                  hideBottomBar: false,
                                );
                              },
                            );
                          }).toList(),
                    );
                  },
                ),

                SizedBox(height: screenWidth * 0.04),

                // ---- Reviews ----
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: screenWidth * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              "See All",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_right,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 210,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ReviewCard(
                        name: "Sarah M.",
                        dateTime: "05 April 2025 10:18 AM",
                        review:
                            "Amazing experience! The team at FocusPoint Studios captured every moment perfectly.",
                        rating: 5,
                      ),
                      ReviewCard(
                        name: "Jason & Emily T.",
                        dateTime: "08 April 2025 10:20 AM",
                        review:
                            "Great service and stunning photos! FocusPoint Studios made our special day unforgettable",
                        rating: 5,
                      ),
                      ReviewCard(
                        name: "Ravi K.",
                        dateTime: "09 April 2025 09:45 AM",
                        review:
                            "Highly recommend FocusPoint Studios! They were professional, and delivered quality.",
                        rating: 5,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenWidth * 0.05),

                // ---- Popular Packages ----
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Packages",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "View all",
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Popular Packages List
                // Popular Packages List
                SizedBox(
                  height: 120,
                  child: GetBuilder<CompanyController>(
                    builder: (controller) {
                      if (controller.popularPackagesList.isEmpty) {
                        return Center(child: Text("No packages available"));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: horizontalPadding),
                        itemCount: controller.popularPackagesList.length,
                        itemBuilder: (context, index) {
                          final package = controller.popularPackagesList[index];
                          return Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: _buildPopularPackageCard(
                              "₹${package['price']}",
                              package['title'] ?? "Untitled",
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // ---- Exclusive Offers ----
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Exclusive Offers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "View all",
                        style: TextStyle(fontSize: 14, color: primaryColor),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Exclusive Offers Slider
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ), // matches design
                    children: [
                      _buildExclusiveOfferSlide(),
                      _buildExclusiveOfferSlide(),
                      _buildExclusiveOfferSlide(),
                    ],
                  ),
                ),

                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Popular Packages Card
  Widget _buildPopularPackageCard(String price, String title) {
    return Container(
      width: 240,
      height: 97, // fixed height so all cards align
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue, // softer border color from screenshot
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section (price + title)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$price/-",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const Spacer(),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Divider line
          Container(
            height: 1,
            color: const Color(0xFFE4E4E4),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),

          // Bottom section (More Details + BUY)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "More Details",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "BUY",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExclusiveOfferSlide() {
    return Container(
      width: 0.88 * Get.width, // around 88% of screen width
      height: 140, // proportional to screenshot
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: AssetImage("assets/images/recommended_banner/PromoSlider.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
