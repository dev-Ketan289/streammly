import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/models/category/category_model.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';
import 'package:streammly/services/theme.dart';

class VendorInfoCard extends StatefulWidget {
  final String logoImage;
  final String companyName;
  final String category;
  final String description;
  final String? distanceKm;
  final String? estimatedTime;
  final String? rating;
  final int? vendorId; // Add vendor ID for bookmark functionality

  const VendorInfoCard({
    super.key,
    required this.logoImage,
    required this.companyName,
    required this.category,
    required this.description,
    this.distanceKm,
    this.estimatedTime,
    this.rating,
    this.vendorId, // Add vendor ID parameter
  });

  @override
  State<VendorInfoCard> createState() => _VendorInfoCardState();
}

class _VendorInfoCardState extends State<VendorInfoCard> {
  List<RecommendedVendors> bookmarks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishlistController = Get.find<WishlistController>();
      wishlistController.loadBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenWidth < 360;

    // Responsive dimensions with constraints
    final cardMargin = isSmallScreen ? 8.0 : 16.0;
    final maxImageSize = isTablet ? 200.0 : (isSmallScreen ? 120.0 : 180.0);
    final imageMargin = isSmallScreen ? 8.0 : 12.0;
    final contentPadding = isSmallScreen ? 12.0 : 16.0;

    return Container(
      margin: EdgeInsets.all(cardMargin),
      constraints: BoxConstraints(maxWidth: screenWidth - (cardMargin * 2)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child:
          screenWidth < 600
              ? _buildMobileLayout(
                context,
                maxImageSize,
                imageMargin,
                contentPadding,
                screenWidth,
              )
              : _buildTabletLayout(
                context,
                maxImageSize,
                imageMargin,
                contentPadding,
                screenWidth,
              ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    double maxImageSize,
    double imageMargin,
    double contentPadding,
    double screenWidth,
  ) {
    // Calculate available space for image
    final availableWidth = screenWidth - (imageMargin * 4) - contentPadding;
    final imageSize = (availableWidth * 0.4).clamp(80.0, maxImageSize);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Logo Image
          Flexible(
            flex: 2,
            child: Container(
              width: imageSize,
              height: imageSize,
              margin: EdgeInsets.all(imageMargin),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.logoImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/default_logo.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
          ),

          // Right side: Info
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(
                top: contentPadding,
                bottom: contentPadding,
                right: contentPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRatingAndTimeRow(context),
                  const SizedBox(height: 8),
                  _buildCompanyInfo(context),
                  const SizedBox(height: 4),
                  _buildDescription(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    double maxImageSize,
    double imageMargin,
    double contentPadding,
    double screenWidth,
  ) {
    // Calculate available space for image
    final availableWidth =
        screenWidth - (imageMargin * 4) - (contentPadding * 2);
    final imageSize = (availableWidth * 0.3).clamp(120.0, maxImageSize);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top: Image and basic info
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                width: imageSize,
                height: imageSize,
                margin: EdgeInsets.all(imageMargin),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.logoImage,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/default_logo.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(contentPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingAndTimeRow(context),
                    const SizedBox(height: 12),
                    _buildCompanyInfo(context),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Bottom: Description
        Padding(
          padding: EdgeInsets.only(
            left: contentPadding,
            right: contentPadding,
            bottom: contentPadding,
          ),
          child: _buildDescription(context),
        ),
      ],
    );
  }

  Widget _buildRatingAndTimeRow(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.rating != null)
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 8,
                vertical: isSmallScreen ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: ratingColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: isSmallScreen ? 2 : 4),
                  Text(
                    widget.rating!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 11 : 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Icon(
                    Icons.star,
                    color: const Color(0xFFF8DE1E),
                    size: isSmallScreen ? 14 : 16,
                  ),
                ],
              ),
            ),
          ),
        if (widget.estimatedTime != null && widget.distanceKm != null)
          Text(
            "${widget.estimatedTime} • ${widget.distanceKm}",
            style: TextStyle(
              fontSize: isSmallScreen ? 7 : 11,
              color: Colors.black,
            ),
            overflow: TextOverflow.visible,
            maxLines: 1,
          ),
        const SizedBox(width: 10),
        GetBuilder<WishlistController>(
          builder: (wishlistController) {
            return GestureDetector(
              onTap: () {
                if (widget.vendorId != null) {
                  wishlistController
                      .addBookmark(widget.vendorId!, "company")
                      .then((value) {
                        if (value.isSuccess) {
                          wishlistController.loadBookmarks();
                        }
                      });
                }
              },
              child: Icon(
                Icons.bookmark_rounded,
                color:
                    widget.vendorId != null &&
                            wishlistController.bookmarks.any(
                              (bookmark) => bookmark.id == widget.vendorId,
                            )
                        ? Colors.redAccent
                        : Colors.grey,
                size: isSmallScreen ? 20 : 25,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.companyName,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Text(
          widget.category,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: Colors.grey,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Text(
      _stripHtml(widget.description),
      style: TextStyle(fontSize: isSmallScreen ? 11 : 13, color: Colors.grey),
      maxLines: 2,
      overflow: TextOverflow.visible,
    );
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
