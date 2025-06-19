import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/category_controller.dart';
import '../../../../../navigation_menu.dart';
import '../../../common/images/rounded_image.dart';
import '../../vendor_locator.dart';

class CategoryListScreen extends StatelessWidget {
  final CategoryController controller = Get.put(CategoryController());

  CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      bottomNavigationBar: NavigationHelper.buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: const Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.categories.isEmpty) {
          return const Center(child: Text("No categories found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => CompanyLocatorMapScreen(categoryId: cat.id));
              },

              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TRoundedImage(imageUrl: "${controller.baseUrl}${cat.image}", height: 100, width: 380, fit: BoxFit.cover, borderRadius: 16, isNetworkImage: true),
                          ),
                        ),
                        const Positioned(top: 10, right: 10, child: Icon(Icons.bookmark, size: 25, color: Colors.red)),
                      ],
                    ),

                    // Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cat.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(cat.shortDescription ?? "No description available", style: const TextStyle(fontSize: 13, color: Colors.grey)),
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
    );
  }
}
