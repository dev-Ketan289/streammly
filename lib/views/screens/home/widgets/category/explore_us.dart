import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart';

import '../../../vendor/vendoer_detail.dart';
import '../../vendor_locator.dart';

class ExploreUs extends StatefulWidget {
  final List<int>? vendorIds;

  const ExploreUs({super.key, this.vendorIds});

  @override
  State<ExploreUs> createState() => _ExploreUsState();
}

class _ExploreUsState extends State<ExploreUs> {
  final CompanyController companyController = Get.find<CompanyController>();
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    _loadVendorsByIds();
  }

  Future<void> _loadVendorsByIds() async {
    if (widget.vendorIds == null || widget.vendorIds!.isEmpty) return;

    setState(() => isFetching = true);

    final alreadyFetched = companyController.companies.map((e) => e.id).toSet();

    for (final id in widget.vendorIds!) {
      if (!alreadyFetched.contains(id)) {
        await companyController.fetchCompanyById(id);
        if (companyController.selectedCompany != null) {
          companyController.companies.add(companyController.selectedCompany!);
        }
      }
    }

    companyController.update();
    setState(() => isFetching = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Explore Us !!!",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xff1E2742),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompanyLocatorMapScreen(categoryId: 1),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "View Map",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(Assets.svgMap, height: 15, width: 15),
                  ],
                ),
              ),
            ],
          ),
        ),

        GetBuilder<CompanyController>(
          builder: (controller) {
            if (controller.isLoading || isFetching) {
              return _buildShimmerList();
            }

            final vendors = controller.companies;
            final filtered =
                widget.vendorIds != null && widget.vendorIds!.isNotEmpty
                    ? vendors
                        .where((v) => widget.vendorIds!.contains(v.id))
                        .toList()
                    : vendors;

            if (filtered.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: Text("No matching vendors found")),
              );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VendorDetailScreen(company: vendor),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),

                    margin: const EdgeInsets.only(bottom: 10),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Color(0xffE2EDF9), width: 2),
                      color: theme.colorScheme.surface,
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(18),
                            bottom: Radius.circular(18),
                          ),
                          child:
                              vendor.bannerImage != null &&
                                      vendor.bannerImage!.isNotEmpty
                                  ? Image.network(
                                    vendor.bannerImage!,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.fill,
                                  )
                                  : Image.asset(
                                    'assets/images/recommended_banner/FocusPointVendor.png',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
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
                                    Text(
                                      vendor.companyName,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      vendor.categoryName ?? "Unknown",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          vendor.estimatedTime ?? "N/A",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Color(0xffB8B7C8),
                                                fontSize: 12,
                                              ),
                                        ),
                                        Text(
                                          vendor.distanceKm != null &&
                                                  vendor.distanceKm! > 1
                                              ? " . ${vendor.distanceKm!.toStringAsFixed(1)} km"
                                              : "${(vendor.distanceKm ?? 0) * 1000 ~/ 1} m",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: Color(0xffB8B7C8),
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ratingColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "${vendor.rating?.toStringAsFixed(1) ?? "0.0"} ",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Color(0xffF8DE1E),
                                      size: 8,
                                    ),
                                  ],
                                ),
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
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 12,
                              width: 100,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 10,
                              width: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 10,
                              width: 120,
                              color: Colors.white,
                            ),
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
