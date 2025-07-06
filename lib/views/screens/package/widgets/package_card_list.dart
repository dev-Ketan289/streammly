import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/package_page_controller.dart';

class PackagesListView extends StatelessWidget {
  final PackagesController controller;
  const PackagesListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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

            return GestureDetector(
              onTap: () => controller.togglePackageSelection(index),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected ? Border.all(color: const Color(0xFF4A6CF7), width: 2) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (pkg["specialOffer"] == true)
                        Container(
                          width: 40,
                          decoration: const BoxDecoration(color: Color(0xFFE67E22), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
                          child: const RotatedBox(
                            quarterTurns: 3,
                            child: Center(child: Text("SPECIAL OFFER", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5))),
                          ),
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE + TYPE
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(pkg["title"] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                        const SizedBox(height: 4),
                                        Text(pkg["type"] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => controller.togglePackageSelection(index),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? const Color(0xFF4A6CF7) : Colors.transparent,
                                        border: Border.all(color: isSelected ? const Color(0xFF4A6CF7) : Colors.grey.shade300, width: 2),
                                      ),
                                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// PRICE
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text("Just For", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  const SizedBox(width: 8),
                                  if (pkg["oldPrice"] != null) ...[
                                    Text("Rs. ${pkg["oldPrice"]}", style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                    const SizedBox(width: 8),
                                  ],
                                  Text("Rs. ${pkg["price"]}/-", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A6CF7))),
                                ],
                              ),

                              const SizedBox(height: 12),

                              /// HOURS
                              Wrap(
                                spacing: 8,
                                children:
                                    (pkg["hours"] as List).map<Widget>((h) {
                                      final selected = controller.selectedHours[index]?.contains(h) ?? false;
                                      return GestureDetector(
                                        onTap: () => controller.toggleHour(index, h),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: selected ? const Color(0xFF4A6CF7) : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: selected ? const Color(0xFF4A6CF7) : Colors.grey.shade300),
                                          ),
                                          child: Text(h, style: TextStyle(fontSize: 12, color: selected ? Colors.white : Colors.black54, fontWeight: FontWeight.w500)),
                                        ),
                                      );
                                    }).toList(),
                              ),

                              /// HIGHLIGHT
                              if ((pkg["highlight"] ?? '').isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(pkg["fullDescription"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                              ],

                              /// SHORT / FULL DESCRIPTION
                              if ((pkg["shortDescription"] ?? '').isNotEmpty || (pkg["fullDescription"] ?? '').isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  isExpanded ? pkg["fullDescription"] ?? '' : pkg["shortDescription"] ?? '',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                                ),
                                if ((pkg["fullDescription"] ?? '') != (pkg["shortDescription"] ?? ''))
                                  GestureDetector(
                                    onTap: () => controller.toggleExpanded(index),
                                    child: Text(
                                      isExpanded ? "Read Less" : "Read More",
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500),
                                    ),
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
