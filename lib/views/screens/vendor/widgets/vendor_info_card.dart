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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    /// Adjust image size according to screen width
    final imageSize = screenWidth * 0.4; // 40% of screen width
    final cardPadding = screenWidth * 0.04; // 4% of screen width

    return Container(
      margin: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left Side - Logo Image
          Container(
            width: imageSize,
            height: imageSize,
            margin: EdgeInsets.all(cardPadding),
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

          /// Right Side - Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: cardPadding,
                bottom: cardPadding,
                right: cardPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Row with Rating & Estimated Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rating!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (estimatedTime != null && distanceKm != null)
                        Text(
                          "$estimatedTime • $distanceKm",
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  /// Company Name & Category
                  Text(
                    companyName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045, // Responsive text
                    ),
                  ),
                  Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035, // Responsive text
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Description (stripped HTML)
                  Text(
                    _stripHtml(description),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();
  }
}
