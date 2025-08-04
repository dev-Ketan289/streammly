import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/category_controller.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/services/theme.dart';

class FilterCompanyListScreen extends StatefulWidget {
  final Function()? onTap;
  const FilterCompanyListScreen({super.key, this.onTap});

  @override
  State<FilterCompanyListScreen> createState() =>
      _FilterCompanyListScreenState();
}

class _FilterCompanyListScreenState extends State<FilterCompanyListScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Filters : ",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: backgroundDark,
                  fontSize: 14,
                ),
              ),
              if (selectedCategory != null)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFEAF1FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedCategory!,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = null;
                            });
                          },
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Add Category heading here
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: GetBuilder<CategoryController>(
                  builder: (categoryController) {
                    if (categoryController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Handle empty categories case
                    if (categoryController.categories.isEmpty) {
                      return const Center(
                        child: Text('No categories available'),
                      );
                    }

                    // Display list of categories
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryController.categories[index];
                        final isSelected = selectedCategory == category.title;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCategory == category.title) {
                                selectedCategory = null;
                                Get.find<CompanyController>().setCategoryId(
                                  0,
                                ); // Clear category ID
                              } else {
                                selectedCategory = category.title;
                                Get.find<CompanyController>().setCategoryId(
                                  category.id,
                                ); // Set category ID
                              }
                            });
                          },
                          child: CustomContainer(
                            isSelected: isSelected,
                            title: category.title,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 30,
                ),
                child: GestureDetector(
                  onTap:
                      selectedCategory == null
                          ? null
                          : () async {
                            log(
                              selectedCategory.toString(),
                              name: "Selected Category",
                            );
                            final companyController =
                                Get.find<CompanyController>();
                            await companyController.fetchCompaniesByCategory(
                              companyController.selectedCategoryId,
                            );
                            if (widget.onTap != null) widget.onTap!();
                          },
                  child: Container(
                    width: 420,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selectedCategory == null
                              ? Colors.grey.shade300
                              : const Color(0xFFEAF1FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      ' Filter',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color:
                            selectedCategory == null
                                ? Colors.grey
                                : primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final bool isSelected;
  final String title;
  const CustomContainer({
    super.key,
    required this.isSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: 390,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? primaryColor : Colors.black,
              ),
              textAlign: TextAlign.start,
            ),
            Icon(
              isSelected ? Icons.circle : Icons.circle_outlined,
              size: 20,
              color: isSelected ? primaryColor : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
