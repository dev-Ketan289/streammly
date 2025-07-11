import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/package_page_controller.dart';

class PackagesGridView extends StatelessWidget {
  final PackagesController controller;
  const PackagesGridView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          SizedBox(
            width: 340,
            height: 340,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.8),
              itemCount: controller.packages.length,
              itemBuilder: (context, index) {
                final pkg = controller.packages[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A6CF7),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pkg["title"], style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                            Text(pkg["type"], style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 20),
                            const Text("Just For", style: TextStyle(fontSize: 11, color: Colors.white70)),
                            Obx(() {
                              final selectedHour = (controller.selectedHours[index]?.isNotEmpty ?? false)
                                  ? controller.selectedHours[index]!.first
                                  : pkg["hours"].first;
                              final priceMap = pkg["priceMap"] as Map<String, int>;
                              final updatedPrice = priceMap[selectedHour] ?? pkg["price"];
                              return Text("₹$updatedPrice/-",
                                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white));
                            }),
                            const SizedBox(height: 16),
                            Row(
                              children: pkg["hours"].map<Widget>((hour) {
                                return Obx(() {
                                  final isSelected = controller.selectedHours[index]?.contains(hour) ?? false;
                                  return Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () => controller.toggleHour(index, hour),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.white : Colors.transparent,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.white, width: 1),
                                        ),
                                        child: Text(
                                          hour,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isSelected ? const Color(0xFF4A6CF7) : Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                onPressed: () => controller.switchToListView(),
                                child: const Text("View More", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Obx(() {
                          final isSelected = controller.isPackageSelected(index);
                          return GestureDetector(
                            onTap: () => controller.togglePackageSelection(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : Colors.white54,
                              ),
                              child: Icon(Icons.check, color: isSelected ? const Color(0xFF4A6CF7) : Colors.grey, size: 16),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildCategorySection(controller, "HomeShoot", theme),
          const SizedBox(height: 20),
          _buildCategorySection(controller, "StudioShoot", theme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCategorySection(PackagesController controller, String category, ThemeData theme) {
    final categoryPackages = controller.packages.where((pkg) => pkg["type"] == category).toList();
    if (categoryPackages.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
          const SizedBox(height: 12),
          ...categoryPackages.map((pkg) {
            final index = controller.packages.indexOf(pkg);
            return _buildPackageCard(controller, pkg, index, theme);
          }),
        ],
      ),
    );
  }

  Widget _buildPackageCard(PackagesController controller, Map<String, dynamic> pkg, int index, ThemeData theme) {
    return Obx(() {
      final isSelected = controller.isPackageSelected(index);
      final selectedHour = (controller.selectedHours[index]?.isNotEmpty ?? false)
          ? controller.selectedHours[index]!.first
          : pkg["hours"].first;
      final priceMap = pkg["priceMap"] as Map<String, int>;
      final updatedPrice = priceMap[selectedHour] ?? pkg["price"];

      return GestureDetector(
        onTap: () => controller.togglePackageSelection(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0xFF4A6CF7), width: 2) : null,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("₹$updatedPrice/-", style: theme.textTheme.titleLarge?.copyWith(color: const Color(0xFF4A6CF7), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(pkg["type"], style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pkg["title"], style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF4A6CF7), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: pkg["hours"].map<Widget>((hour) {
                        return Obx(() {
                          final selected = controller.selectedHours[index]?.contains(hour) ?? false;
                          return GestureDetector(
                            onTap: () => controller.toggleHour(index, hour),
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFF4A6CF7) : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: selected ? const Color(0xFF4A6CF7) : Colors.grey.shade300),
                              ),
                              child: Text(
                                hour,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: selected ? Colors.white : Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        });
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("More Details", style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A6CF7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            controller.togglePackageSelection(index);
                          },
                          child: const Text("BUY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF4A6CF7) : Colors.transparent,
                  border: Border.all(color: isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade300, width: 2),
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
