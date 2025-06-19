import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/models/category/category_item.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/category_scroller.dart';
import 'package:streammly/views/screens/home/widgets/header_banner.dart';
import 'package:streammly/views/screens/vendor/vendor_group.dart';

import '../../../models/banner/banner_item.dart';
import '../../../navigation_menu.dart';
import '../home/widgets/category/review_card.dart';
import '../home/widgets/horizontal_card.dart';

class VendorDetailScreen extends StatelessWidget {
  const VendorDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationHelper.buildBottomNav(), // Use the helper method
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image & Name
              HeaderBanner(
                banners: [BannerItem(image: "assets/images/recommended_banner/FocusPointVendor.png", title: "Photography", subtitle: "Capture your moments perfectly.")],
                height: 280,
                // location: "Mahim",
                // address: "MTNL Telephone Colony, VSNL Colony",
                color: Colors.indigo.withValues(alpha: 0.4),
                overlayOpacity: 0.7,
              ),
              const SizedBox(height: 6),
              CategoryScroller(
                categories: [
                  CategoryItem(
                    label: 'Baby Shoot',
                    imagePath: 'assets/images/category/vendor_category/img.png',
                    onTap: () {
                      Get.to(() => VendorGroup());
                    },
                  ),
                  CategoryItem(label: 'wedding Shoot', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                  CategoryItem(label: 'Portfolio Shoot', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                  CategoryItem(label: 'Maternity Shoot', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                  CategoryItem(label: 'Family Function', imagePath: 'assets/images/category/vendor_category/img.png', onTap: () {}),
                ],
              ),
              const SizedBox(height: 10),
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
