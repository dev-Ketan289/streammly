import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/package/widgets/package%20header.dart';
import 'package:streammly/views/screens/package/widgets/package_bottom_summary.dart';
import 'package:streammly/views/screens/package/widgets/package_card_grid.dart';
import 'package:streammly/views/screens/package/widgets/package_card_list.dart';
import 'package:streammly/views/screens/vendor/filter_page.dart';

import '../../../controllers/package_page_controller.dart';

class PackagesPage extends StatelessWidget {
  final int companyId;
  final int subCategoryId;
  final int subVerticalId;

  const PackagesPage({super.key, required this.companyId, required this.subCategoryId, required this.subVerticalId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PackagesController>();

    // Initialize ONCE in post-frame (to prevent re-execution on rebuilds)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize(companyId: companyId, subCategoryId: subCategoryId, subVerticalId: subVerticalId);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black54), onPressed: () => Get.back()),
        title: const Center(child: Text("Packages", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600))),
        actions: [IconButton(icon: const Icon(Icons.filter_alt, color: Colors.indigo), onPressed: () => Get.bottomSheet(const FilterPage(), isScrollControlled: true))],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            PackagesHeader(controller: controller),
            Expanded(child: controller.isGridView.value ? PackagesGridView(controller: controller) : PackagesListView(controller: controller)),
          ],
        );
      }),
      bottomNavigationBar: PackagesBottomBar(controller: controller),
    );
  }
}
