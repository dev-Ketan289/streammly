import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/controllers/wishlist_controller.dart';
import 'package:streammly/views/screens/wishlist/components/custom_container.dart';

import '../../../controllers/category_controller.dart';
import '../../../models/company/company_location.dart';
import 'components/vendor_card.dart';

class Wishlistpage extends StatefulWidget {
  const Wishlistpage({super.key});

  @override
  State<Wishlistpage> createState() => _WishlistpageState();
}

class _WishlistpageState extends State<Wishlistpage> {
  final wishlistController = Get.find<WishlistController>();

  final CategoryController categoryController = Get.find<CategoryController>();
  final Map<String, List<CompanyLocation>> companiesByCategory = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
      wishlistController.loadBookmarks();
      // wishlistController.loadBookmarks();
    });
  }

  Future<void> _fetchData() async {
    try {
      companiesByCategory.clear();
      for (var category in categoryController.categories) {
        Get.find<CompanyController>().setCategoryId(category.id);
        await Get.find<CompanyController>().fetchCompaniesByCategory(
          category.id,
        );
        setState(() {
          companiesByCategory[category.title] = List.from(
            Get.find<CompanyController>().companies,
          );
        });
      }
      if (companiesByCategory.isEmpty) {
        Get.snackbar("Error", "No categories found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load wishlist: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton(text: 'All', onPressed: () {}),
                      CustomButton(text: 'Categories', onPressed: () {}),
                      CustomButton(text: 'Products', onPressed: () {}),
                      CustomButton(text: 'Packages', onPressed: () {}),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<CompanyController>(
                      builder: (controller) {
                        if (controller.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (companiesByCategory.isEmpty) {
                          return const Center(
                            child: Text(
                              "No items in your wishlist.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              companiesByCategory.entries.map((entry) {
                                final categoryTitle = entry.key;
                                final companies = entry.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      categoryTitle,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4867B7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children:
                                            companies.map((company) {
                                              return GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder:
                                                        (context) =>
                                                            WishlistBottomSheet(),
                                                  );
                                                },
                                                child: VendorCard(
                                                  companyName:
                                                      company.companyName,
                                                  rating: '3.9 ★',
                                                  timeDistance:
                                                      '${company.estimatedTime ?? '35-40 mins'} . ${company.distanceKm?.toStringAsFixed(1) ?? '4.2'} km',
                                                  category: categoryTitle,
                                                  imageUrl:
                                                      company.bannerImage !=
                                                                  null &&
                                                              company
                                                                  .bannerImage!
                                                                  .isNotEmpty
                                                          ? company.bannerImage!
                                                          : 'assets/images/demo.png',
                                                  isSelected: false,
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WishlistBottomSheet extends StatelessWidget {
  const WishlistBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(30),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Remove from Wishlist',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Are you sure you want to remove this?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Removing this will delete it from your saved Wishlist.'),
            SizedBox(height: 24),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.blue.shade700),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Yes, Remove',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 40,

              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.blue.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Keep Wishlist',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
