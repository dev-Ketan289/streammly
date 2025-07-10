import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/package_page_controller.dart';

class PackagesHeader extends StatelessWidget {
  final PackagesController controller;
  const PackagesHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Baby Shoot / New Born",
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF4A6CF7)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.grid_view, color: controller.isGridView.value ? const Color(0xFF4A6CF7) : theme.disabledColor, size: 20),
                  onPressed: () => controller.setGridView(true),
                ),
                IconButton(
                  icon: Icon(Icons.view_list, color: !controller.isGridView.value ? const Color(0xFF4A6CF7) : theme.disabledColor, size: 20),
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
