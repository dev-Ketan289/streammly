import 'package:flutter/material.dart';
import 'package:streammly/views/screens/home/vendor_locator.dart';
import 'package:streammly/views/screens/vendor/vendor_detail.dart';

class ExploreUs extends StatelessWidget {
  const ExploreUs({super.key});

  @override
  Widget build(BuildContext context) {
    final vendors = [
      {
        "image": "assets/images/recommended_banner/FocusPointVendor.png",
        "name": "FocusPoint Studios",
        "type": "Photographer",
        "time": "31–36 mins",
        "distance": "4.0 km",
        "rating": "3.9",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Explore Us !!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CompanyLocatorMapScreen(categoryId: 1)));
                },
                child: Row(
                  children: const [
                    Text("View Map", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                    SizedBox(width: 4),
                    Icon(Icons.map_outlined, color: Colors.blue, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: vendors.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image with Favorite Icon
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Image.asset(vendor["image"]!, height: 150, width: double.infinity, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(backgroundColor: Colors.white, radius: 14, child: const Icon(Icons.favorite_border, size: 16, color: Colors.red)),
                        ),
                      ],
                    ),

                    // Text Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vendor["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(vendor["type"]!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(vendor["time"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(vendor["distance"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(8)),
                            child: Text("${vendor["rating"]} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
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
      ],
    );
  }
}
