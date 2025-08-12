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
import '../home/widgets/horizontal_card.dart';
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
                /// ---- Header Banner ----
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

                /// ---- Category Scroller (Subcategories) ----
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
                                    const Duration(milliseconds: 50),
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

                /// ---- Reviews ----
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

                /// ---- Packages ----
                PackageSection(
                  title: "Popular Packages",
                  onSeeAll: () {},
                  isPopular: true,
                  packages: [
                    {
                      "image":
                          "assets/images/category/vendor_category/Baby.jpg",
                      "label": "Album",
                    },
                    {
                      "image":
                          "assets/images/category/vendor_category/Baby.jpg",
                      "label": "Frame",
                    },
                  ],
                ),

                PackageSection(
                  title: "Exclusive Offers Just For You",
                  onSeeAll: () {},
                  isPopular: false,
                  packages: [
                    {
                      "image":
                          "assets/images/category/vendor_category/Baby.jpg",
                      "label": "XYZ Packages",
                      "price": "Rs. 2000/-",
                    },
                    {
                      "image":
                          "assets/images/category/vendor_category/Baby.jpg",
                      "label": "XYZ Packages",
                      "price": "Rs. 2000/-",
                    },
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
