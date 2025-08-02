import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/theme.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pkg["title"],
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              pkg["type"],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Just For",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                            GetBuilder<PackagesController>(
                                id: 'price_$index',
                                builder: (_) {
                                  final selectedHour = (controller.selectedHours[index]?.isNotEmpty ?? false)
                                      ? controller.selectedHours[index]!.first
                                      : pkg["hours"].first;
                                  final priceMap = pkg["priceMap"] as Map<String, int>;
                                  final updatedPrice = priceMap[selectedHour] ?? pkg["price"];
                                  return Text(
                                    "₹$updatedPrice/-",
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                            const SizedBox(height: 16),
                            Row(
                              children: pkg["hours"].map<Widget>((hour) {
                                return GetBuilder<PackagesController>(
                                    id: 'hours_${index}_$hour',
                                    builder: (_) {
                                      final isSelected = controller.selectedHours[index]?.contains(hour) ?? false;
                                      return Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        child: GestureDetector(
                                          onTap: () => controller.toggleHour(index, hour),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected ? Colors.white : Colors.transparent,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1,
                                              ),
                                            ),
                                            child: Text(
                                              hour,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isSelected ? primaryColor : Colors.white,
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () => controller.switchToListView(),
                                child: const Text(
                                  "View More",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: GetBuilder<PackagesController>(
                            id: 'selected_$index',
                            builder: (_) {
                              final isSelected = controller.isPackageSelected(index);
                              return GestureDetector(
                                onTap: () => controller.togglePackageSelection(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.white : Colors.white54,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: isSelected ? primaryColor : Colors.grey,
                                    size: 16,
                                  ),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Selected Packages",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),

          GetBuilder<PackagesController>(
              id: 'selected_packages_list',
              builder: (_) {
                final selectedIndices = controller.selectedPackageIndices.toList();
                if (selectedIndices.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "No package selected.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: selectedIndices.map((index) {
                    final pkg = controller.packages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: _buildPackageCard(controller, pkg, index, theme),
                    );
                  }).toList(),
                );
              }),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPackageCard(
      PackagesController controller,
      Map<String, dynamic> pkg,
      int index,
      ThemeData theme,
      ) {
    return GetBuilder<PackagesController>(
        id: 'package_card_$index',
        builder: (_) {
          final isSelected = controller.isPackageSelected(index);
          final selectedHour =
          (controller.selectedHours[index]?.isNotEmpty ?? false)
              ? controller.selectedHours[index]!.first
              : pkg["hours"].first;
          final priceMap = pkg["priceMap"] as Map<String, int>;
          final updatedPrice = priceMap[selectedHour] ?? pkg["price"];

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row with Price and Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹$updatedPrice/-",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              pkg["title"] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? primaryColor : Colors.transparent,
                                border: Border.all(color: primaryColor, width: 2),
                              ),
                              child: isSelected
                                  ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              )
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Duration Chips
                    Row(
                      children: pkg["hours"].map<Widget>((hour) {
                        final selected = controller.selectedHours[index]?.contains(hour) ?? false;
                        return GestureDetector(
                          onTap: () => controller.toggleHour(index, hour),
                          child: Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? primaryColor : const Color(0xFFF0F3FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              hour,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : primaryColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE6E6E6),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => controller.switchToListView(),
                          child: const Text(
                            "More Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () => controller.togglePackageSelection(index),
                          child: const Text(
                            "BUY",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Sticky Top Label (e.g. HomeShoot)
              Positioned(
                top: 0,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: Text(
                    pkg["type"] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
