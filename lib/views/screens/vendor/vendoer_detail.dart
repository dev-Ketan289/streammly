import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';

import '../../../models/category/category_item.dart';
import '../../../models/company/company_location.dart';
import '../../../navigation_menu.dart';
import '../home/widgets/category/review_card.dart';
import '../home/widgets/category/widgets/category_scroller.dart';
import '../home/widgets/header_banner.dart';
import '../home/widgets/horizontal_card.dart';
import 'vendor_group.dart';

class VendorDetailScreen extends StatefulWidget {
  final CompanyLocation company;

  const VendorDetailScreen({super.key, required this.company});

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final CompanyController companyController = Get.find();

  @override
  void initState() {
    super.initState();
    companyController.fetchCompanySubCategories(widget.company.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationHelper.buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---- Header Banner ----
              HeaderBanner(
                height: 280,
                backgroundImage:
                widget.company.bannerImage != null && widget.company.bannerImage!.isNotEmpty
                    ? 'http://192.168.1.113:8000/${widget.company.bannerImage}'
                    : 'assets/images/recommended_banner/FocusPointVendor.png',
                overlayColor: Colors.indigo.withValues(alpha: 0.6),
                overrideTitle: widget.company.companyName,
                overrideSubtitle: widget.company.categoryName,
              ),

              const SizedBox(height: 6),

              /// ---- Category Scroller (Subcategories) ----
              Obx(() {
                final subs = companyController.subCategories;

                if (subs.isEmpty) {
                  return CategoryScroller(
                    categories: [
                      CategoryItem(
                        label: 'Baby Shoot',
                        imagePath: 'assets/images/category/vendor_category/img.png',
                        onTap: () => Get.to(() => VendorGroup(company: widget.company, subCategoryId: 2)),
                      ),
                      CategoryItem(label: 'Wedding Shoot', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                      CategoryItem(label: 'Portfolio Shoot', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                      CategoryItem(label: 'Maternity Shoot', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                      CategoryItem(label: 'Family Function', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                    ],
                  );
                }

                return CategoryScroller(
                  categories:
                  subs.map((sub) {
                    return CategoryItem(
                      label: sub.title,
                      imagePath: 'http://192.168.1.113:8000/${sub.image ?? ""}',
                      onTap: () => Get.to(() => VendorGroup(company: widget.company, subCategoryId: sub.id)),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 10),

              /// ---- Reviews ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Text("See All", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w500)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    ReviewCard(
                      name: "Sarah M.",
                      dateTime: "05 April 2025 10:18 AM",
                      review: "Amazing experience! The team at FocusPoint Studios captured every moment perfectly.",
                      rating: 5,
                    ),
                    SizedBox(width: 12),
                    ReviewCard(
                      name: "Jason & Emily T.",
                      dateTime: "08 April 2025 10:20 AM",
                      review: "Great service and stunning photos! FocusPoint Studios made our special day unforgettable",
                      rating: 5,
                    ),
                    SizedBox(width: 12),
                    ReviewCard(
                      name: "Ravi K.",
                      dateTime: "09 April 2025 09:45 AM",
                      review: "Highly recommend FocusPoint Studios! They were professional, and delivered quality.",
                      rating: 5,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ---- Packages ----
              PackageSection(
                title: "Popular Packages",
                onSeeAll: () {},
                isPopular: true,
                packages: [
                  {"image": "assets/images/category/vendor_category/Baby.jpg", "label": "Album"},
                  {"image": "assets/images/category/vendor_category/Baby.jpg", "label": "Frame"},
                ],
              ),

              PackageSection(
                title: "Exclusive Offers Just For You",
                onSeeAll: () {},
                isPopular: false,
                packages: [
                  {"image": "assets/images/category/vendor_category/Baby.jpg", "label": "XYZ Packages", "price": "Rs. 2000/-"},
                  {"image": "assets/images/category/vendor_category/Baby.jpg", "label": "XYZ Packages", "price": "Rs. 2000/-"},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}