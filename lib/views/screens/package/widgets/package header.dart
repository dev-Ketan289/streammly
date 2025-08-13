import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/controllers/company_controller.dart';

import '../../../../controllers/package_page_controller.dart';

class PackagesHeader extends StatelessWidget {
  final PackagesController controller;
  const PackagesHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Resolve names for selected sub-vertical and subcategory
    String verticalName = '';
    String subCategoryName = '';

    try {
      final companyController = Get.find<CompanyController>();
      // Sub-vertical name from cards list
      final vertical = companyController.subVerticalCards.firstWhere(
        (m) {
          final idStr = m['id'] ?? '';
          final id = int.tryParse(idStr) ?? -1;
          return id == controller.subVerticalId;
        },
        orElse: () => const {},
      );
      if (vertical.isNotEmpty) {
        subCategoryName = vertical['label'] ?? '';
      }

      // Subcategory name from list
      final maybeSub = companyController.subCategories.where(
        (s) => s.id == controller.subCategoryId,
      );
      if (maybeSub.isNotEmpty) {
        verticalName = maybeSub.first.title;
      }
    } catch (_) {}

    final String headerTitle = [verticalName, subCategoryName]
        .where((e) => e.trim().isNotEmpty)
        .join(' / ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                headerTitle.isNotEmpty ? headerTitle : "Packages",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          GetBuilder<PackagesController>(
            id: 'grid_toggle', // optional, only if you want to optimize updates
            builder:
                (controller) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.grid_view,
                        color:
                            controller.isGridView
                                ? primaryColor
                                : theme.disabledColor,
                        size: 20,
                      ),
                      onPressed: () => controller.setGridView(true),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.view_list,
                        color:
                            !controller.isGridView
                                ? primaryColor
                                : theme.disabledColor,
                        size: 20,
                      ),
                      onPressed: () => controller.setGridView(false),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }
}
