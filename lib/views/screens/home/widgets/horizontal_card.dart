import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class PackageSection extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  final List<Map<String, String>> packages;
  final bool isPopular;

  const PackageSection({
    super.key,
    required this.title,
    required this.onSeeAll,
    required this.packages,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and See All
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              InkWell(
                onTap: onSeeAll,
                child: Row(
                  children: [
                    Text(
                      "See All",
                      style: textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_right, size: 24, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Card List
        SizedBox(
          height: isPopular ? 160 : 190,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: packages.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              return isPopular
                  ? _buildPopularCard(pkg, theme)
                  : _buildExclusiveCard(pkg, theme);
            },
          ),
        ),
      ],
    );
  }

  // Popular Package Card
  Widget _buildPopularCard(Map<String, String> pkg, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 140,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // White background
              Positioned.fill(child: Container(color: Colors.white)),
              // Image with padding
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(pkg['image']!, fit: BoxFit.cover),
                  ),
                ),
              ),
              // Text overlay at bottom
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  height: 20,
                  width: 114,
                  decoration: BoxDecoration(
                    color: backgroundLight.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    pkg['label']!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Exclusive Offer Card
  Widget _buildExclusiveCard(Map<String, String> pkg, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: 300,
        height: 123,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: theme.colorScheme.surface,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image on top
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                  bottom: Radius.circular(14),
                ),
                child: Image.asset(
                  pkg['image']!,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Text
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg['label']!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pkg['price']!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
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
