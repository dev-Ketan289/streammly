import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';

import '../../../vendor/vendor_detail.dart';
import '../../vendor_locator.dart';

class ExploreUs extends StatelessWidget {
  final int? vendorId;

  const ExploreUs({super.key, this.vendorId});

  @override
  Widget build(BuildContext context) {
    final CompanyController companyController = Get.put(CompanyController());

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

        Obx(() {
          final vendors = companyController.companies;

          final filteredVendors = vendorId != null ? vendors.where((v) => v.id == vendorId).toList() : vendors;

          if (filteredVendors.isEmpty) {
            return const Padding(padding: EdgeInsets.all(16), child: Center(child: Text("No vendors found")));
          }

          return ListView.builder(
            itemCount: filteredVendors.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final vendor = filteredVendors[index];

              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: vendor)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: Colors.white, boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                            child:
                                vendor.bannerImage != null && vendor.bannerImage!.isNotEmpty
                                    ? Image.network('http://192.168.1.10:8000/${vendor.bannerImage}', height: 150, width: double.infinity, fit: BoxFit.cover)
                                    : Image.asset('assets/images/recommended_banner/FocusPointVendor.png', height: 150, width: double.infinity, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: CircleAvatar(backgroundColor: Colors.white, radius: 14, child: const Icon(Icons.favorite_border, size: 16, color: Colors.red)),
                          ),
                        ],
                      ),

                      // Info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(vendor.companyName ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 2),
                                  Text(vendor.categoryName ?? "Unknown", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      const Text("31–36 mins", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        vendor.distanceKm != null && vendor.distanceKm! > 1
                                            ? "${vendor.distanceKm!.toStringAsFixed(1)} km"
                                            : "${(vendor.distanceKm ?? 0) * 1000 ~/ 1} m",
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(8)),
                              child: Text("${vendor.rating?.toStringAsFixed(1) ?? "0.0"} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
