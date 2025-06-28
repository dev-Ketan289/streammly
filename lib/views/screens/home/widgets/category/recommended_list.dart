import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate item width dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    // Use a fraction of screen width for item width, capped for larger screens
    final itemWidth = (screenWidth * 0.45).clamp(140.0, 180.0);
    // Adjust height based on content needs
    final itemHeight = itemWidth * 1.7; // Aspect ratio for card

    final vendors = [
      {
        "image": "assets/images/recommended_banner/flavor.png",
        "name": "Flavor Theory",
        "type": "Food & Caterers",
        "time": "35-40 mins",
        "distance": "4.2 km",
        "rating": "3.9",
      },
      {
        "image": "assets/images/recommended_banner/focuspoint.png",
        "name": "FocusPoint Studio",
        "type": "Photographer",
        "time": "28-33 mins",
        "distance": "3.6 km",
        "rating": "3.9",
      },
      {
        "image": "assets/images/recommended_banner/velvet.png",
        "name": "Velvet Parlour",
        "type": "Makeup Artist",
        "time": "42-48 mins",
        "distance": "5.1 km",
        "rating": "3.9",
      },
    ];

    return SizedBox(
      height: itemHeight + 16, // Add padding to height
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04, // Responsive padding
          vertical: 8,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder:
            (_, __) => SizedBox(width: screenWidth * 0.03), // Responsive gap
        itemBuilder: (_, index) {
          final vendor = vendors[index];

          return InkWell(
            onTap: () {
              // Navigate to vendor details
            },
            child: Container(
              width: itemWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
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
                        child: Image.asset(
                          vendor["image"]!,
                          height: itemWidth * 1.0, // Responsive image height
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          size: itemWidth * 0.12, // Responsive icon size
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                      itemWidth * 0.025,
                    ), // Responsive padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                vendor["name"]!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: itemWidth * 0.09, // Responsive font
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
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${vendor["rating"]} ★",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: itemWidth * 0.075,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: itemWidth * 0.015),
                        Text(
                          vendor["type"]!,
                          style: TextStyle(
                            fontSize: itemWidth * 0.075,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: itemWidth * 0.015),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: itemWidth * 0.085,
                              color: Colors.grey,
                            ),
                            SizedBox(width: itemWidth * 0.025),
                            Expanded(
                              child: Text(
                                vendor["time"]!,
                                style: TextStyle(
                                  fontSize: itemWidth * 0.075,
                                  color: Colors.grey,
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
                              color: Colors.grey,
                            ),
                            SizedBox(width: itemWidth * 0.025),
                            Expanded(
                              child: Text(
                                vendor["distance"]!,
                                style: TextStyle(
                                  fontSize: itemWidth * 0.075,
                                  color: Colors.grey,
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
