import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final vendors = [
      {"image": "assets/images/recommended_banner/flavor.png", "name": "Flavor Theory", "type": "Food & Caterers", "time": "35-40 mins", "distance": "4.2 km", "rating": "3.9"},
      {
        "image": "assets/images/recommended_banner/focuspoint.png",
        "name": "FocusPoint Studio",
        "type": "Photographer",
        "time": "28-33 mins",
        "distance": "3.6 km",
        "rating": "3.9",
      },
      {"image": "assets/images/recommended_banner/velvet.png", "name": "Velvet Parlour", "type": "Makeup Artist", "time": "42-48 mins", "distance": "5.1 km", "rating": "3.9"},
    ];

    return SizedBox(
      height: 270,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final vendor = vendors[index];

          return InkWell(
            onTap: () {
              // Navigate to vendor details
            },
            child: Container(
              width: 160, // Use a fixed width that's reasonable for all screen sizes
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 9, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(vendor["image"]!, height: 120, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Positioned(top: 8, right: 8, child: Icon(Icons.favorite, size: 20, color: Colors.white)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(vendor["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                              child: Text("${vendor["rating"]} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(vendor["type"]!, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(vendor["time"]!, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(vendor["distance"]!, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
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
