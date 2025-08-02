import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/recommended_vendor_card.dart';

import '../../../../../models/company/company_location.dart';
import '../../../vendor/vendoer_detail.dart';

class RecommendedList extends StatefulWidget {
  final BuildContext context;
  final List<RecommendedVendors> recommendedVendors;
  final WishlistController wishlistController = Get.find<WishlistController>();

  RecommendedList({super.key, required this.context, required this.recommendedVendors});

  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.wishlistController.loadBookmarks("company");
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth * 0.45).clamp(140.0, 180.0);
    final itemHeight = itemWidth * 1.7;

    return SizedBox(
      height: itemHeight + 16,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: widget.recommendedVendors.length,
        separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.03),
        itemBuilder: (_, index) {
          final vendor = widget.recommendedVendors[index];

          final imageUrl = vendor.logo != null ? (vendor.logo ?? '') : "assets/images/placeholder.jpg";

          final rating = vendor.rating?.toStringAsFixed(1) ?? "--";
          final companyName = vendor.companyName ?? "Unknown";
          final category = vendor.vendorcategory?.first.getCategory?.title ?? "Service";

          final distanceKm = vendor.id;
          // final distanceText =
          distanceKm != null ? (distanceKm < 1 ? "${(distanceKm * 1000).toStringAsFixed(0)} m" : "${distanceKm.toStringAsFixed(1)} km") : "--";
          final time = distanceKm != null ? "${(distanceKm * 7).round()} mins . ${distanceKm.toStringAsFixed(1)} km" : "--";

          return RecommendedVendorCard(
            vendor: vendor,
            imageUrl: imageUrl,
            rating: rating,
            companyName: companyName,
            category: category,
            time: time,
            itemWidth: itemWidth,
            theme: theme,
            wishlistController: widget.wishlistController,
            onTap: () {
              final double? lat = vendor.latitude != null ? double.tryParse(vendor.latitude.toString()) : null;
              final double? lng = vendor.longitude != null ? double.tryParse(vendor.longitude.toString()) : null;

              final company = CompanyLocation(
                id: vendor.id ?? 0,
                companyId: vendor.id ?? 0,
                type: 'studio', // fallback/default (if you need type)
                name: vendor.companyName ?? "Unknown", // fallback
                companyName: vendor.companyName ?? "Unknown",
                latitude: lat,
                longitude: lng,
                distanceKm: null, // You can add a front-end calculation here if desired
                estimatedTime: null, // Same
                bannerImage: vendor.bannerImage,
                logo: vendor.logo,
                description: vendor.description,
                categoryName: vendor.vendorcategory?.isNotEmpty == true ? vendor.vendorcategory!.first.getCategory?.title : "Service",
                rating: vendor.rating?.toDouble(),
                specialities: vendor.specialities ?? [],
                // If your CompanyLocation now supports other fields, add them here with similar null/default handling
              );
              final mainState = context.findAncestorStateOfType<NavigationFlowState>();
              // Get.to(() => CompanyLocatorMapScreen(categoryId: cat.id));
              mainState?.pushToCurrentTab(VendorDetailScreen(studio: company), hideBottomBar: true);
              // Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: company)));
              // final navKey = Get.find<NavigationController>().navigatorKeys[0];
              // navKey.currentState?.push(
              //   MaterialPageRoute(
              //     builder: (_) => VendorDetailScreen(company: company),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}
