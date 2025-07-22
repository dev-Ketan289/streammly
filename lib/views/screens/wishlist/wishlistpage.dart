import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/home/widgets/category/widgets/recommended_vendor_card.dart';
import 'package:streammly/models/vendors/recommanded_vendors.dart';
import 'package:streammly/views/screens/wishlist/components/wishlist_bottom_sheet.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final wishlistController = Get.find<WishlistController>();

  String selectedFilter = 'company';
  final Map<String, String> filterTypes = {
    'All': '',
    'Categories': 'category',
    'Packages': 'package',
    'Products': 'product',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      wishlistController.loadBookmarks(selectedFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth * 0.45).clamp(140.0, 180.0);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Color(0xFF2864A6),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GetBuilder<WishlistController>(
          builder: (controller) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.bookmarks.isEmpty) {
              return const Center(
                child: Text(
                  "No items in your wishlist.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              );
            }

            // Group bookmarks by type (companyType)
            final Map<String, List<RecommendedVendors>> grouped = {};
            for (var vendor in controller.bookmarks) {
              final type =
                  vendor.vendorcategory?.first.getCategory?.title ?? 'Other';
              if (!grouped.containsKey(type)) grouped[type] = [];
              grouped[type]!.add(vendor);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children:
                  grouped.entries.map((entry) {
                    final type = entry.key;
                    final vendors = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            type,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: itemWidth * 1.7,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: vendors.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final vendor = vendors[index];
                              return RecommendedVendorCard(
                                itemWidth: itemWidth,
                                theme: Theme.of(context),
                                wishlistController: wishlistController,
                                onTap: () {
                                  Get.bottomSheet(
                                    WishlistBottomSheet(
                                      vendor: vendor,
                                      onRemove: () async {
                                        final result = await wishlistController
                                            .addBookmark(vendor.id, "company");
                                        if (result.isSuccess) {
                                          Get.snackbar(
                                            'Removed',
                                            'Item removed from wishlist',
                                          );
                                        } else {
                                          Get.snackbar('Error', result.message);
                                        }
                                      },
                                    ),
                                  );
                                },
                                vendor: vendor,
                                imageUrl: vendor.logo ?? '',
                                rating:
                                    vendor.rating?.toStringAsFixed(1) ?? '--',
                                companyName: vendor.companyName ?? 'Unknown',
                                category:
                                    vendor
                                        .vendorcategory
                                        ?.first
                                        .getCategory
                                        ?.title ??
                                    'Service',
                                time:
                                    vendor.id != null
                                        ? "${(vendor.id! * 7).round()} mins . ${vendor.id!.toStringAsFixed(1)} km"
                                        : '--',
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 23,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      ),
    );
  }
}
