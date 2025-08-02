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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Filters",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 14,
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
                    return const Center(child: Text('No categories available'));
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
                            selectedCategory = category.title;
                          });
                          // Get.find<CompanyController>().setCategoryId(
                          //   category.id,
                          // );
                          // log(widget.onTap.toString());
                          // log(widget.onTap == null ? "null" : "not null");
                          // widget.onTap?.call();
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
          ],
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
