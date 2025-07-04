import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/category_controller.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/models/company/company_location.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, required this.selectedCategories});
  final List<String> selectedCategories;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final Map<String, List<CompanyLocation>> companiesByCategory = {};
  final List<String> _selectedCategories =
      []; // Track multiple selected categories

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
        if (companiesByCategory.containsKey(newCategory)) {
          setState(() {
            if (_selectedCategories.contains(newCategory)) {
              _selectedCategories.remove(
                newCategory,
              ); // Deselect if already selected
            } else {
              _selectedCategories.add(
                newCategory,
              ); // Add to selected categories
            }
          });
          return;
        }
        final category = categoryController.categories.firstWhereOrNull(
          (cat) => cat.title == newCategory,
        );
        if (category != null) {
          Get.find<CompanyController>().setCategoryId(category.id);
          print(
            "Fetching companies for category: $newCategory (ID: ${category.id})",
          );
          await Get.find<CompanyController>().fetchCompaniesByCategory(
            category.id,
          );
          setState(() {
            companiesByCategory[newCategory] = List.from(
              Get.find<CompanyController>().companies,
            );
            _selectedCategories.add(newCategory); // Add to selected categories
          });
        } else {
          print("Category not found: $newCategory");
          Get.snackbar("Error", "Category not found: $newCategory");
        }
      } else {
        companiesByCategory.clear();
        _selectedCategories.clear();
        for (var categoryTitle in widget.selectedCategories) {
          final category = categoryController.categories.firstWhereOrNull(
            (cat) => cat.title == categoryTitle,
          );
          if (category != null) {
            Get.find<CompanyController>().setCategoryId(category.id);
            print(
              "Fetching companies for category: $categoryTitle (ID: ${category.id})",
            );
            await Get.find<CompanyController>().fetchCompaniesByCategory(
              category.id,
            );
            companiesByCategory[categoryTitle] = List.from(
              Get.find<CompanyController>().companies,
            );
          } else {
            print("Category not found: $categoryTitle");
          }
        }
        if (companiesByCategory.isEmpty) {
          Get.snackbar("Error", "No valid categories found.");
        }
        setState(() {});
      }
    } catch (e) {
      print("Error fetching companies: $e");
      Get.snackbar("Error", "Failed to load companies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F4FF),
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Color(0xFF2E5CDA),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Categories ',
                    style: TextStyle(fontSize: 15, color: Color(0xFF997D15)),
                  ),
                  Text(
                    '/ View Map',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GetBuilder<CompanyController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (companiesByCategory.isEmpty) {
                    return const Center(
                      child: Text(
                        "No companies found for selected categories.",
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
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF4867B7),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (var company in companies)
                                      GestureDetector(
                                        onTap: () {
                                          _fetchData(
                                            newCategory: categoryTitle,
                                          );
                                        },
                                        child: VendorCard(
                                          companyName: company.companyName,
                                          rating: '3.9 ★',
                                          timeDistance:
                                              '${company.estimatedTime ?? '35-40 mins'} . ${company.distanceKm?.toStringAsFixed(1) ?? '4.2'} km',
                                          category: categoryTitle,
                                          imageUrl:
                                              company.bannerImage != null &&
                                                      company
                                                          .bannerImage!
                                                          .isNotEmpty
                                                  ? company.bannerImage!
                                                  : 'assets/images/demo.png',
                                          isSelected: _selectedCategories
                                              .contains(categoryTitle),
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        }).toList(),
                  );
                },
              ),
              // Selected Categories Section
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Selected Vendors',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4867B7),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GetBuilder<CompanyController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_selectedCategories.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Vendors selected.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _selectedCategories.expand((categoryTitle) {
                          final companies =
                              companiesByCategory[categoryTitle] ?? [];
                          return companies.map((company) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: VendorRect(
                                companyName: company.companyName,
                                rating: '3.9 ★',
                                timeDistance:
                                    '${company.estimatedTime ?? '35-40 mins'} . ${company.distanceKm?.toStringAsFixed(1) ?? '4.2'} km',
                                category: categoryTitle,
                                description:
                                    'Our services include premium photography and video facilities for creative professionals and clients.\nStudio rental (Photography/Video/Graphic)\ncinematic videography\nWhy Choose Us: environment\nExperienced studio team',
                                imageUrl:
                                    company.bannerImage != null &&
                                            company.bannerImage!.isNotEmpty
                                        ? company.bannerImage!
                                        : 'assets/images/demo.png',
                              ),
                            );
                          }).toList();
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VendorCard extends StatelessWidget {
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
      margin: EdgeInsets.only(left: 10),
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border:
            isSelected ? Border.all(color: Color(0xFF2E5CDA), width: 2) : null,
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
                child:
                    imageUrl.startsWith('http')
                        ? Image.network(
                          imageUrl,
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 160,
                              width: 160,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) => Image.asset(
                                'assets/images/demo.png',
                                height: 160,
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                        )
                        : Image.asset(
                          imageUrl,
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover,
                        ),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: Icon(Icons.favorite, size: 19, color: Colors.white),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        timeDistance,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
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

  const VendorRect({
    super.key,
    required this.companyName,
    required this.rating,
    required this.timeDistance,
    required this.category,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 178,
      width: 350,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200] ?? Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
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
                        return Container(
                          width: 150,
                          height: 160,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            'assets/images/vendor_demo.png',
                            width: 150,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                    )
                    : Image.asset(
                      imageUrl ?? 'assets/images/vendor_demo.png',
                      width: 150,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.location_on,
                      size: 15,
                      color: Colors.grey.shade300,
                    ),
                    Text(
                      timeDistance,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                // Description list (simulated as text for now)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          description
                              .split('\n')
                              .map(
                                (line) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          line.trim(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
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
