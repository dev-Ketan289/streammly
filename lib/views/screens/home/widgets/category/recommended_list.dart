import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  final BuildContext context;
  final List<Map<String, dynamic>> recommendedCompanies;

  const RecommendedList({
    super.key,
    required this.context,
    required this.recommendedCompanies,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth * 0.45).clamp(140.0, 180.0);
    final itemHeight = itemWidth * 1.7;

    const baseUrl = "http://192.168.1.113:8000/";

    return SizedBox(
      height: itemHeight + 16,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: 8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: recommendedCompanies.length,
        separatorBuilder: (_, __) => SizedBox(width: screenWidth * 0.03),
        itemBuilder: (_, index) {
          final vendor = recommendedCompanies[index];

          final imageUrl = vendor["banner_image"] != null
              ? baseUrl + vendor["banner_image"]
              : "assets/images/placeholder.jpg";

          final rating = vendor["rating"]?.toStringAsFixed(1) ?? "--";
          final companyName = vendor["company_name"] ?? "Unknown";
          final category = vendor["category_name"] ?? "Service";

          final distanceKm = vendor["distance_km"];
          final distanceText = distanceKm != null
              ? (distanceKm < 1
              ? "${(distanceKm * 1000).toStringAsFixed(0)} m"
              : "${distanceKm.toStringAsFixed(1)} km")
              : "--";
          final time =
          distanceKm != null ? "${(distanceKm * 7).round()} mins" : "--";

          return InkWell(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: vendor)));
            },
            child: Container(
              width: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: theme.colorScheme.surface, // Theme-based background
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: .05),
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
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.favorite,
                            size: itemWidth * 0.12,
                            color: theme.colorScheme.onPrimary,
                          ),
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
