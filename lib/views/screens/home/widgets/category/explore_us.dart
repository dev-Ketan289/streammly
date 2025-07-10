import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streammly/controllers/company_controller.dart';

import '../../../vendor/vendoer_detail.dart';
import '../../vendor_locator.dart';

class ExploreUs extends StatelessWidget {
  final int? vendorId;

  const ExploreUs({super.key, this.vendorId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final CompanyController companyController = Get.find<CompanyController>();

    if (companyController.companies.isEmpty) {
      companyController.fetchCompaniesByCategory(companyController.selectedCategoryId);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---- Title & Map Button ----
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Explore Us !!!", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CompanyLocatorMapScreen(categoryId: 1)));
                },
                child: Row(
                  children: [
                    Text("View Map", style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    Icon(Icons.map_outlined, color: theme.colorScheme.primary, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// ---- Shimmer or Vendor List ----
        GetBuilder<CompanyController>(
          builder: (controller) {
            if (companyController.isLoading) {
              return _buildShimmerList();
            }

            return GetBuilder<CompanyController>(
              builder: (controller) {
                final vendors = controller.companies;
                final filtered = vendorId != null ? vendors.where((v) => v.id == vendorId).toList() : vendors;

                if (filtered.isEmpty) {
                  return const Padding(padding: EdgeInsets.all(16), child: Center(child: Text("No vendors found")));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final vendor = filtered[index];

                    return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: vendor)));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: const Offset(0, 4))],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                              child:
                                  vendor.bannerImage != null && vendor.bannerImage!.isNotEmpty
                                      ? Image.network('https://admin.streammly.com/${vendor.bannerImage}', height: 150, width: double.infinity, fit: BoxFit.cover)
                                      : Image.asset('assets/images/recommended_banner/FocusPointVendor.png', height: 150, width: double.infinity, fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(vendor.companyName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(vendor.categoryName ?? "Unknown", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(vendor.estimatedTime ?? "N/A", style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 12)),
                                            const SizedBox(width: 10),
                                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              vendor.distanceKm != null && vendor.distanceKm! > 1
                                                  ? "${vendor.distanceKm!.toStringAsFixed(1)} km"
                                                  : "${(vendor.distanceKm ?? 0) * 1000 ~/ 1} m",
                                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(8)),
                                    child: Text("${vendor.rating?.toStringAsFixed(1) ?? "0.0"} ★", style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontSize: 12)),
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
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: const Offset(0, 4))],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              children: [
                Container(height: 150, width: double.infinity, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 12, width: 100, color: Colors.white),
                            const SizedBox(height: 8),
                            Container(height: 10, width: 80, color: Colors.white),
                            const SizedBox(height: 10),
                            Container(height: 10, width: 120, color: Colors.white),
                          ],
                        ),
                      ),
                      Container(height: 24, width: 40, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
