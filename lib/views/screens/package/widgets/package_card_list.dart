import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/theme.dart';

import '../../../../controllers/package_page_controller.dart';

class PackagesListView extends StatelessWidget {
  final PackagesController controller;
  const PackagesListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.packages.length,
      itemBuilder: (context, index) {
        final pkg = controller.packages[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Obx(() {
            final isExpanded = controller.expandedStates[index] ?? false;
            final isSelected = controller.isPackageSelected(index);
            final selectedHour =
                (controller.selectedHours[index]?.isNotEmpty ?? false)
                    ? controller.selectedHours[index]!.first
                    : pkg["hours"].first;
            final priceMap = pkg["priceMap"] as Map<String, int>;
            final updatedPrice = priceMap[selectedHour] ?? pkg["price"];

            return GestureDetector(
              onTap: () => controller.togglePackageSelection(index),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isSelected
                          ? Border.all(color: primaryColor, width: 2)
                          : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (pkg["specialOffer"] == true)
                        Container(
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xffC59732),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: const RotatedBox(
                            quarterTurns: 3,
                            child: Center(
                              child: Text(
                                "SPECIAL OFFER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pkg["title"] ?? '',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          pkg["type"] ?? '',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap:
                                        () => controller.togglePackageSelection(
                                          index,
                                        ),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color:
                                            isSelected
                                                ? primaryColor
                                                : Colors.transparent,
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? primaryColor
                                                  : Colors.grey.shade300,
                                          width: 2,
                                        ),
                                      ),
                                      child:
                                          isSelected
                                              ? const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              )
                                              : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Just For",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (pkg["oldPrice"] != null) ...[
                                    Text(
                                      "Rs. ${pkg["oldPrice"]}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    "Rs. $updatedPrice/-",
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                children:
                                    (pkg["hours"] as List).map<Widget>((h) {
                                      final selected =
                                          controller.selectedHours[index]
                                              ?.contains(h) ??
                                          false;
                                      return GestureDetector(
                                        onTap:
                                            () =>
                                                controller.toggleHour(index, h),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                selected
                                                    ? primaryColor
                                                    : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color:
                                                  selected
                                                      ? primaryColor
                                                      : Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Text(
                                            h,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color:
                                                  selected
                                                      ? Colors.white
                                                      : Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                              if ((pkg["highlight"] ?? '').isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  pkg["highlight"],
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                              if (((pkg["shortDescription"] ?? '').isNotEmpty ||
                                      (pkg["fullDescription"] ?? '')
                                          .isNotEmpty) &&
                                  !isExpanded) ...[
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => controller.toggleExpanded(index),
                                  child: Text(
                                    "Read More",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: const Color(0xff383434),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                              if (((pkg["shortDescription"] ?? '').isNotEmpty ||
                                      (pkg["fullDescription"] ?? '')
                                          .isNotEmpty) &&
                                  isExpanded) ...[
                                const SizedBox(height: 8),
                                // if ((pkg["highlight"] ?? '').isNotEmpty)
                                //   Text(
                                //     pkg["highlight"],
                                //     style: theme.textTheme.bodyMedium?.copyWith(
                                //       fontWeight: FontWeight.w600,
                                //       color: Colors.black87,
                                //     ),
                                //   ),
                                // if ((pkg["highlight"] ?? '').isNotEmpty &&
                                //     ((pkg["shortDescription"] ?? '')
                                //             .isNotEmpty ||
                                //         (pkg["fullDescription"] ?? '')
                                //             .isNotEmpty))
                                const SizedBox(height: 8),
                                Builder(
                                  builder: (context) {
                                    final fullDesc =
                                        pkg["fullDescription"] ??
                                        pkg["shortDescription"] ??
                                        '';
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (fullDesc.isNotEmpty)
                                          Text(
                                            fullDesc,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: Colors.grey,
                                                  height: 1.4,
                                                ),
                                          ),
                                        GestureDetector(
                                          onTap:
                                              () => controller.toggleExpanded(
                                                index,
                                              ),
                                          child: Text(
                                            "Read Less",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color(0xff383434),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
