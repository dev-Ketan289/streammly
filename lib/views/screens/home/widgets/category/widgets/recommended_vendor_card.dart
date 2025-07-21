import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';
import 'package:streammly/services/theme.dart';

class RecommendedVendorCard extends StatelessWidget {
  final RecommendedVendors vendor;
  final String imageUrl;
  final String rating;
  final String companyName;
  final String category;
  final String time;
  final double itemWidth;
  final ThemeData theme;
  final WishlistController wishlistController;
  final VoidCallback onTap;

  const RecommendedVendorCard({
    Key? key,
    required this.vendor,
    required this.imageUrl,
    required this.rating,
    required this.companyName,
    required this.category,
    required this.time,
    required this.itemWidth,
    required this.theme,
    required this.wishlistController,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        width: itemWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Color(0xffE2EDF9), width: 2),
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
                    bottom: Radius.circular(16),
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
                                  wishlistController.loadBookmarks("company");
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
                            fontSize: itemWidth * 0.08,
                            color: theme.colorScheme.onSurface,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
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
                              "$rating",
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: itemWidth * 0.075,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.star,
                              size: itemWidth * 0.075,
                              color: Color(0xffF8DE1E),
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
                        color: Color(0xffB8B7C8),
                      ),
                      SizedBox(width: itemWidth * 0.025),
                      Expanded(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: itemWidth * 0.075,
                            color: Color(0xffB8B7C8),
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  if (vendor.specialities != null &&
                      vendor.specialities!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: itemWidth * 0.02),
                      child: Text(
                        "Specialities: " + vendor.specialities!.join(", "),
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
  }
}
