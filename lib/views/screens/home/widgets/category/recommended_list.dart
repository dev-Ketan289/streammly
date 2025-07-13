import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';
import '../../../../../models/company/company_location.dart';
import '../../../vendor/vendoer_detail.dart';

class RecommendedList extends StatefulWidget {
  final BuildContext context;
  final List<RecommendedVendors> recommendedVendors;
  final WishlistController wishlistController = Get.find<WishlistController>();

  RecommendedList({
    super.key,
    required this.context,
    required this.recommendedVendors,
  });

  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.wishlistController.loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth * 0.45).clamp(140.0, 180.0);
    final itemHeight = itemWidth * 1.7;

    const baseUrl = "https://admin.streammly.com/";

    return SizedBox(
      height: itemHeight + 16,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: widget.recommendedVendors.length,
        separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.03),
        itemBuilder: (_, index) {
          final vendor = widget.recommendedVendors[index];

          final imageUrl =
          vendor.bannerImage != null
              ? baseUrl + (vendor.bannerImage ?? '')
              : "assets/images/placeholder.jpg";

          final rating = vendor.rating?.toStringAsFixed(1) ?? "--";
          final companyName = vendor.companyName ?? "Unknown";
          final category =
              vendor.vendorcategory?.first.getCategory?.title ?? "Service";

          final distanceKm = vendor.id;
          final distanceText =
          distanceKm != null
              ? (distanceKm < 1
              ? "${(distanceKm * 1000).toStringAsFixed(0)} m"
              : "${distanceKm.toStringAsFixed(1)} km")
              : "--";
          final time =
          distanceKm != null ? "${(distanceKm * 7).round()} mins" : "--";

          return InkWell(
            onTap: () {
              final company = CompanyLocation(
                id: vendor.id,
                companyName: vendor.companyName ?? "Unknown",
                latitude: vendor.latitude != null ? double.tryParse(vendor.latitude.toString()) : null,
                longitude: vendor.longitude != null ? double.tryParse(vendor.longitude.toString()) : null,
                bannerImage: vendor.bannerImage != null ? 'https://admin.streammly.com/${vendor.bannerImage}' : null,
                logo: vendor.logo != null ? 'https://admin.streammly.com/${vendor.logo}' : null,
                description: vendor.description,
                categoryName: vendor.vendorcategory?.isNotEmpty == true ? vendor.vendorcategory!.first.getCategory?.title : "Service",
                rating: vendor.rating?.toDouble(),
                specialities: vendor.specialities ?? [],
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VendorDetailScreen(company: company),
                ),
              );
            },

            child: Container(
              width: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
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
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          imageUrl,
                          height: itemWidth * 1.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Image.asset(
                              'assets/images/placeholder.jpg',
                              height: itemWidth * 1.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GetBuilder<WishlistController>(
                          builder: (wishlistController) {
                            return GestureDetector(
                              onTap: () {
                                wishlistController
                                    .addBookmark(vendor.id, "company")
                                    .then((value) {
                                  if (value.isSuccess) {
                                    wishlistController.loadBookmarks();
                                  }
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                color:
                                vendor.isChecked == true
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
                                  fontSize: itemWidth * 0.09,
                                  color: theme.colorScheme.onSurface,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: itemWidth * 0.04,
                                vertical: itemWidth * 0.015,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "$rating ★",
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: itemWidth * 0.075,
                                ),
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
                              Icons.access_time,
                              size: itemWidth * 0.085,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: itemWidth * 0.025),
                            Expanded(
                              child: Text(
                                time,
                                style: TextStyle(
                                  fontSize: itemWidth * 0.075,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: itemWidth * 0.015),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: itemWidth * 0.085,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: itemWidth * 0.025),
                            Expanded(
                              child: Text(
                                distanceText,
                                style: TextStyle(
                                  fontSize: itemWidth * 0.075,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Specialities Added Below
                        if (vendor.specialities != null &&
                            vendor.specialities!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: itemWidth * 0.02),
                            child: Text(
                              "Specialities: ${vendor.specialities!.join(", ")}",
                              style: TextStyle(
                                fontSize: itemWidth * 0.07,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
