import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/vendor/filter_page.dart';

import '../../../controllers/package_page_controller.dart';
import 'booking/booking_form.dart';

class PackagesPage extends StatelessWidget {
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PackagesController());

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black54), onPressed: () => Get.back()),
        title: Center(child: const Text("Packages", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600))),
        actions: [IconButton(icon: const Icon(Icons.filter_alt, color: Colors.indigo), onPressed: () => Get.bottomSheet(const FilterPage(), isScrollControlled: true))],
      ),
      body: Column(
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Center(
                    child: Text("Baby Shoot / New Born", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF4A6CF7)), overflow: TextOverflow.ellipsis),
                  ),
                ),
                Obx(
                  () => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.grid_view, color: controller.isGridView.value ? const Color(0xFF4A6CF7) : Colors.grey, size: 20),
                        onPressed: () => controller.setGridView(true),
                      ),
                      IconButton(
                        icon: Icon(Icons.view_list, color: !controller.isGridView.value ? const Color(0xFF4A6CF7) : Colors.grey, size: 20),
                        onPressed: () => controller.setGridView(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Obx(() => controller.isGridView.value ? _buildGridView(controller) : _buildListView(controller))),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF5F6FA),
        child: Obx(() {
          final selectedPackages = controller.getSelectedPackagesForBilling();
          final selectedCount = controller.getSelectedPackageCount();
          final totalPrice = controller.getTotalPrice();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show selected packages summary
              if (selectedPackages.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF4A6CF7), width: 1)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Selected Packages: $selectedCount", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4A6CF7))),
                          Text("Total: ₹$totalPrice/-", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A6CF7))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Show package names in a compact way
                      Wrap(
                        spacing: 4,
                        children:
                            selectedPackages
                                .map(
                                  (pkg) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFF4A6CF7).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                                    child: Text(
                                      "${pkg['title']} (${pkg['selectedHours'].join(', ')})",
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  ),
                ),
              ],

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: selectedPackages.isEmpty ? Colors.grey : const Color(0xFF4A6CF7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed:
                    selectedPackages.isEmpty
                        ? null
                        : () {
                          // Navigate to booking form with selected packages
                          final selectedPackages = controller.getSelectedPackagesForBilling();
                          if (selectedPackages.isNotEmpty) {
                            print("Proceeding to booking form with: $selectedPackages");
                            // Get.toNamed('/booking-form', arguments: selectedPackages);
                            // // Or if using direct navigation:
                            Get.to(() => BookingPage(), arguments: selectedPackages);
                          }
                        },
                child: Text(
                  selectedPackages.isEmpty ? "Select packages to continue" : "Let's Continue (${selectedPackages.length} packages)",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildGridView(PackagesController controller) {
    return Column(
      children: [
        // Top horizontal scrollable cards section
        SizedBox(
          width: 340,
          height: 340,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8),
            itemCount: controller.packages.length,
            onPageChanged: (index) {
              controller.togglePackageSelection(index);
            },
            itemBuilder: (context, index) {
              final pkg = controller.packages[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A6CF7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and type
                          Text(pkg["title"], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(pkg["type"], style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 20),

                          // Price section
                          const Text("Just For", style: TextStyle(fontSize: 11, color: Colors.white70)),
                          Text("₹${pkg["price"]}/-", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 16),

                          // Selectable hours
                          Row(
                            children:
                                pkg["hours"].map<Widget>((hour) {
                                  return Obx(
                                    () => Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: GestureDetector(
                                        onTap: () => controller.toggleHour(index, hour),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: (controller.selectedHours[index]?.contains(hour) ?? false) ? Colors.white : Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.white, width: 1),
                                          ),
                                          child: Text(
                                            hour,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: (controller.selectedHours[index]?.contains(hour) ?? false) ? const Color(0xFF4A6CF7) : Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          const Spacer(),

                          // View More button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: const Color(0xFFFFFFFF),
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

                    // Check icon - show only for selected package
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: controller.isPackageSelected(index) ? Colors.white : Colors.white54),
                          child: Icon(Icons.check, color: controller.isPackageSelected(index) ? const Color(0xFF4A6CF7) : Colors.grey, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // Bottom categorized package sections
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // HomeShoot Section
                _buildCategorySection(controller, "HomeShoot"),

                const SizedBox(height: 20),

                // StudioShoot Section
                _buildCategorySection(controller, "StudioShoot"),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(PackagesController controller, String category) {
    final categoryPackages = controller.packages.where((pkg) => pkg["type"] == category).toList();

    if (categoryPackages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 12),
        ...categoryPackages.map((pkg) {
          final index = controller.packages.indexOf(pkg);
          return _buildPackageCard(controller, pkg, index);
        }),
      ],
    );
  }

  Widget _buildPackageCard(PackagesController controller, Map<String, dynamic> pkg, int index) {
    return Obx(() {
      final isSelected = controller.isPackageSelected(index);

      return GestureDetector(
        onTap: () => controller.togglePackageSelection(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0xFF4A6CF7), width: 2) : null,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              // Price section
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("₹${pkg["price"]}/-", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF4A6CF7) : const Color(0xFF4A6CF7))),
                    const SizedBox(height: 4),
                    Text(pkg["type"], style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              // Title and hours section
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pkg["title"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isSelected ? const Color(0xFF4A6CF7) : const Color(0xFF4A6CF7))),
                    const SizedBox(height: 8),
                    Row(
                      children:
                          pkg["hours"].map<Widget>((hour) {
                            return Obx(
                              () => GestureDetector(
                                onTap: () => controller.toggleHour(index, hour),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (controller.selectedHours[index]?.contains(hour) ?? false) ? const Color(0xFF4A6CF7) : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: (controller.selectedHours[index]?.contains(hour) ?? false) ? const Color(0xFF4A6CF7) : Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    hour,
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: (controller.selectedHours[index]?.contains(hour) ?? false) ? Colors.white : Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
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
                            // Select this package and proceed to billing
                            controller.togglePackageSelection(index);
                            final selectedPackage = controller.isPackageSelected(index);
                            if (selectedPackage != null) {
                              print("Quick buy for: $selectedPackage");
                              // Navigate directly to billing
                              // Get.toNamed('/billing', arguments: selectedPackage);
                            }
                          },
                          child: const Text("BUY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selection indicator
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

  Widget _buildListView(PackagesController controller) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.packages.length,
      itemBuilder: (context, index) {
        final pkg = controller.packages[index];

        return Obx(() {
          final isExpanded = controller.expandedStates[index] ?? false;
          final isSelected = controller.isPackageSelected(index);

          return GestureDetector(
            onTap: () => controller.togglePackageSelection(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: const Color(0xFF4A6CF7), width: 2) : null,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Special Offer Banner - Vertical on left
                    if (pkg["specialOffer"])
                      Container(
                        width: 40,
                        decoration: const BoxDecoration(color: Color(0xFFE67E22), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
                        child: const RotatedBox(
                          quarterTurns: 3,
                          child: Center(child: Text("SPECIAL OFFER", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5))),
                        ),
                      ),

                    // Main content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with checkbox
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(pkg["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                                      const SizedBox(height: 4),
                                      Text(pkg["type"], style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
                                      color: controller.isPackageSelected(index) ? const Color(0xFF4A6CF7) : Colors.transparent,
                                      border: Border.all(color: controller.isPackageSelected(index) ? const Color(0xFF4A6CF7) : Colors.grey.shade300, width: 2),
                                    ),
                                    child: controller.isPackageSelected(index) ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Price
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

                            // Selectable Hours
                            Wrap(
                              spacing: 8,
                              children:
                                  pkg["hours"]
                                      .map<Widget>(
                                        (h) => GestureDetector(
                                          onTap: () => controller.toggleHour(index, h),
                                          child: Obx(
                                            () => Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: (controller.selectedHours[index]?.contains(h) ?? false) ? const Color(0xFF4A6CF7) : Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: (controller.selectedHours[index]?.contains(h) ?? false) ? const Color(0xFF4A6CF7) : Colors.grey.shade300),
                                              ),
                                              child: Text(
                                                h,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: (controller.selectedHours[index]?.contains(h) ?? false) ? Colors.white : Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),

                            // Highlight text
                            if (pkg["highlight"].isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(pkg["highlight"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                            ],

                            // Expandable Description
                            if (pkg["shortDescription"].isNotEmpty || pkg["fullDescription"].isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(isExpanded ? pkg["fullDescription"] : pkg["shortDescription"], style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.4)),
                              if (pkg["fullDescription"].isNotEmpty && pkg["fullDescription"] != pkg["shortDescription"]) ...[
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () => controller.toggleExpanded(index),
                                  child: Text(isExpanded ? "Read Less" : "Read More", style: const TextStyle(fontSize: 12, color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500)),
                                ),
                              ],
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
        });
      },
    );
  }
}
