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
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Logo Image
          Container(
            width: 180,
            height: 180,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
              image: DecorationImage(
                image: NetworkImage(logoImage),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {},
              ),
            ),
          ),

          // Right side: Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row with rating and estimated time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 16,
                              ),
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
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    category,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    _stripHtml(description),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    maxLines: 6,
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
