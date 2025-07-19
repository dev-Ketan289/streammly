import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/category_controller.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/models/company/company_location.dart';

import '../home/vendor_locator.dart';
import 'bundle_package_selection.dart';

class BundleCategories extends StatefulWidget {
  const BundleCategories({super.key, required this.selectedCategories});
  final List<String> selectedCategories;

  @override
  State<BundleCategories> createState() => _BundleCategoriesState();
}

class _BundleCategoriesState extends State<BundleCategories> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final Map<String, List<CompanyLocation>> companiesByCategory = {};
  final List<String> _selectedVendorIds = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData({String? newCategory}) async {
    try {
      if (newCategory != null) {
        final category = categoryController.categories.firstWhereOrNull((cat) => cat.title == newCategory);
        if (category != null) {
          Get.find<CompanyController>().setCategoryId(category.id);
          await Get.find<CompanyController>().fetchCompaniesByCategory(category.id);
          setState(() {
            companiesByCategory[newCategory] = List.from(Get.find<CompanyController>().companies);
          });
        } else {
          Get.snackbar("Error", "Category not found: $newCategory");
        }
      } else {
        companiesByCategory.clear();
        _selectedVendorIds.clear();
        for (var categoryTitle in widget.selectedCategories) {
          final category = categoryController.categories.firstWhereOrNull((cat) => cat.title == categoryTitle);
          if (category != null) {
            Get.find<CompanyController>().setCategoryId(category.id);
            await Get.find<CompanyController>().fetchCompaniesByCategory(category.id);
            companiesByCategory[categoryTitle] = List.from(Get.find<CompanyController>().companies);
          }
        }
        if (companiesByCategory.isEmpty) {
          Get.snackbar("Error", "No valid categories found.");
        }
        setState(() {});
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load companies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FF),
      appBar: AppBar(
        title: const Text('Categories', style: TextStyle(color: Color(0xFF2E5CDA), fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(onTap: () {}, child: const Text('View Categories ', style: TextStyle(fontSize: 15, color: Color(0xFF997D15)))),
                  GestureDetector(
                    onTap: () {
                      final selectedCategory = categoryController.categories.firstWhereOrNull((e) => e.title == widget.selectedCategories.first);
                      if (selectedCategory != null) {
                        Get.to(() => CompanyLocatorMapScreen(categoryId: selectedCategory.id));
                      } else {
                        Get.snackbar("Error", "Please select a valid category");
                      }
                    },
                    child: const Text('/ View Map', style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Vendor Cards
              GetBuilder<CompanyController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (companiesByCategory.isEmpty) {
                    return const Center(child: Text("No companies found for selected categories."));
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
                              Text(categoryTitle, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF4867B7))),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      companies.map((company) {
                                        final companyId = company.id.toString();
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (_selectedVendorIds.contains(companyId)) {
                                                _selectedVendorIds.remove(companyId);
                                              } else {
                                                _selectedVendorIds.add(companyId);
                                              }
                                            });
                                          },
                                          child: VendorCard(
                                            companyName: company.companyName,
                                            rating: '3.9 ★',
                                            timeDistance: '${company.estimatedTime ?? '35-40 mins'} . ${company.distanceKm?.toStringAsFixed(1) ?? '4.2'} km',
                                            category: categoryTitle,
                                            imageUrl: company.logo != null && company.logo!.isNotEmpty ? company.logo! : 'assets/images/demo.png',
                                            isSelected: _selectedVendorIds.contains(companyId),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Selected Vendors
              const Center(child: Text('Selected Vendors', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF4867B7)))),
              const SizedBox(height: 10),
              GetBuilder<CompanyController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_selectedVendorIds.isEmpty) {
                    return const Center(child: Text("No Vendors selected.", style: TextStyle(fontSize: 14, color: Colors.grey)));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        companiesByCategory.entries.expand((entry) {
                          final categoryTitle = entry.key;
                          final companies = entry.value;
                          return companies.where((company) => _selectedVendorIds.contains(company.id.toString())).map((company) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: VendorRect(
                                companyName: company.companyName,
                                rating: '3.9 ★',
                                timeDistance: '${company.estimatedTime ?? '35-40 mins'} . ${company.distanceKm?.toStringAsFixed(1) ?? '4.2'} km',
                                category: categoryTitle,
                                description: company.description ?? '',
                                imageUrl: company.logo != null && company.logo!.isNotEmpty ? company.logo! : 'assets/images/demo.png',
                              ),
                            );
                          }).toList();
                        }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Continue Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_selectedVendorIds.isEmpty) {
                        Get.snackbar("No Vendors", "Please select at least one vendor to continue.");
                        return;
                      }

                      Get.to(() => BundlePackageSelectionScreen(selectedVendorIds: _selectedVendorIds));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5CDA),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class






VendorCard extends StatelessWidget {
  final String companyName;
  final String rating;
  final String timeDistance;
  final String category;
  final String imageUrl;
  final bool isSelected;

  const VendorCard({
    super.key,
    required this.companyName,
    required this.rating,
    required this.timeDistance,
    required this.category,
    required this.imageUrl,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: isSelected ? Border.all(color: Color(0xFF2E5CDA), width: 2) : null,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 3, offset: const Offset(1, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child:
                imageUrl.startsWith('http')
                    ? Image.network(
                      imageUrl,
                      height: 100,
                      width: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset('assets/images/demo.png', height: 100, width: 160, fit: BoxFit.cover),
                    )
                    : Image.asset(imageUrl, height: 100, width: 160, fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(category, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 3),
                    Expanded(child: Text(timeDistance, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                    child: Text(rating, style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VendorRect extends StatelessWidget {
  final String companyName;
  final String rating;
  final String timeDistance;
  final String category;
  final String description;
  final String? imageUrl;

  const VendorRect({super.key, required this.companyName, required this.rating, required this.timeDistance, required this.category, required this.description, this.imageUrl});

  /// Converts HTML-like text to bullet-friendly plain lines
  List<String> _htmlToLines(String html) {
    html = html.replaceAll(RegExp(r'<br\s*/?>'), '\n');
    html = html.replaceAllMapped(RegExp(r'<li>(.*?)<li>', dotAll: true), (match) => '• ${match[1]!.trim()}');
    html = html.replaceAll(RegExp(r'<[^>]+>'), ''); // Remove remaining tags
    html = html.replaceAll('&nbsp;', ' ');
    return html.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lines = _htmlToLines(description);

    return Container(
      padding: const EdgeInsets.all(8),
      height: 178,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[200] ?? Colors.grey, width: 2), borderRadius: BorderRadius.circular(16), color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageUrl != null && imageUrl!.startsWith('http')
                    ? Image.network(
                      imageUrl!,
                      width: 150,
                      height: 160,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(width: 150, height: 160, child: Center(child: CircularProgressIndicator()));
                      },
                      errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/vendor_demo.png', width: 150, height: 160, fit: BoxFit.cover),
                    )
                    : Image.asset(imageUrl ?? 'assets/images/vendor_demo.png', width: 150, height: 160, fit: BoxFit.cover),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Rating and time-distance
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(rating, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.location_on, size: 15, color: Colors.grey.shade300),
                    const SizedBox(width: 4),
                    Expanded(child: Text(timeDistance, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 4),

                /// Title & Category
                Text(companyName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(category, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 8),

                /// Description
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          lines.map((line) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check, size: 14, color: Colors.green),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text(line, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
