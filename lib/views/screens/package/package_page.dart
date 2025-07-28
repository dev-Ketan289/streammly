import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/package/widgets/package%20header.dart';
import 'package:streammly/views/screens/package/widgets/package_bottom_summary.dart';
import 'package:streammly/views/screens/package/widgets/package_card_grid.dart';
import 'package:streammly/views/screens/package/widgets/package_card_list.dart';
import 'package:streammly/views/screens/vendor/filter_page.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/package_page_controller.dart';

class PackagesPage extends StatelessWidget {
  final int companyId;
  final int subCategoryId;
  final int subVerticalId;
  final int studioId;

  const PackagesPage({super.key, required this.companyId, required this.subCategoryId, required this.subVerticalId, required this.studioId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PackagesController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialize(companyId: companyId, subCategoryId: subCategoryId, subVerticalId: subVerticalId, studioId: studioId);
    });

    return CustomBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black54), onPressed: () => Get.back()),
          title: Center(child: Text("Packages", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryColor, fontWeight: FontWeight.w600))),
          actions: [IconButton(icon: Icon(Icons.filter_alt, color: primaryColor), onPressed: () => Get.bottomSheet(const FilterPage(), isScrollControlled: true))],
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
        bottomNavigationBar: PackagesBottomBar(controller: controller, companyLocations: []),
      ),
    );
  }
}
