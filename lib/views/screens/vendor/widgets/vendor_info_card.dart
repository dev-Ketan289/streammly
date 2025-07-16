import 'package:flutter/material.dart';

class VendorInfoCard extends StatelessWidget {
  final String logoImage;
  final String companyName;
  final String category;
  final String description;
  final String? distanceKm;
  final String? estimatedTime;
  final String? rating;

  const VendorInfoCard({
    super.key,
    required this.logoImage,
    required this.companyName,
    required this.category,
    required this.description,
    this.distanceKm,
    this.estimatedTime,
    this.rating,
  });

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

    return Row(
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
                logoImage,
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
                    logoImage,
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
        if (rating != null)
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 8,
                vertical: isSmallScreen ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                    size: isSmallScreen ? 14 : 16,
                  ),
                  SizedBox(width: isSmallScreen ? 2 : 4),
                  Flexible(
                    child: Text(
                      rating!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 11 : 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (estimatedTime != null && distanceKm != null)
          Flexible(
            flex: 2,
            child: Text(
              "$estimatedTime • $distanceKm",
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 13,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
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
          companyName,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        const SizedBox(height: 4),
        Text(
          category,
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
      _stripHtml(description),
      style: TextStyle(fontSize: isSmallScreen ? 11 : 13, color: Colors.grey),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
