import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controllers/package_page_controller.dart';

class FreeItemsPage extends StatefulWidget {
  final int packageId;
  const FreeItemsPage({super.key, required this.packageId});

  @override
  State<FreeItemsPage> createState() => _FreeItemsPageState();
}

class _FreeItemsPageState extends State<FreeItemsPage> {
  bool _showItems = false;
  int _selectedIndex = -1;

  late final PackagesController packagesController;

  @override
  void initState() {
    super.initState();
    packagesController = Get.find<PackagesController>();
    // Delay fetch call until after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      packagesController.fetchFreeAddOns(widget.packageId);
    });
  }

  void _onAddPressed() {
    final resp = packagesController.freeAddOnResponse;
    if (_selectedIndex != -1 &&
        resp != null &&
        _selectedIndex < resp.addons.length) {
      final selected = resp.addons[_selectedIndex];
      Navigator.pop(context, {
        'id': selected.id,
        'title': selected.productTitle,
        'description': selected.description,
        'image': selected.coverImage,
        'mainTitle': selected.mainTitle,
        'usageType': selected.usageType,
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xffF2F2FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffF2F2FA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Free Items',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xff2864A6),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withAlpha(30), blurRadius: 8),
            ],
          ),
          child: GetBuilder<PackagesController>(
            builder: (controller) {
              final loading = controller.isFetchingFreeAddOns;
              final resp = controller.freeAddOnResponse;
              final addons = resp?.addons ?? [];
              final mainTitle =
                  (resp?.mainTitles.isNotEmpty == true)
                      ? (resp?.mainTitles.first ?? "")
                      : "Free Add-Ons";

              if (loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (addons.isEmpty) {
                return const Center(child: Text("No free add-ons available."));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown toggle
                  GestureDetector(
                    onTap: () => setState(() => _showItems = !_showItems),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          mainTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          _showItems
                              ? Icons.remove_circle_outline
                              : Icons.add_circle_outline,
                          color: const Color(0xff2864A6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_showItems)
                    ...List.generate(addons.length, (index) {
                      final item = addons[index];
                      final selected = _selectedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xffF9F9F9),
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    item.coverImage != null &&
                                            item.coverImage!.isNotEmpty
                                        ? Image.network(
                                          item.coverImage!,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (c, o, e) => Container(
                                                height: 50,
                                                width: 50,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              ),
                                        )
                                        : Container(
                                          height: 50,
                                          width: 50,
                                          color: Colors.grey[200],
                                          child: const Icon(Icons.image),
                                        ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productTitle,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.description ?? "",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Shoot Duration : 1',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed:
                                    () =>
                                        setState(() => _selectedIndex = index),
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      selected
                                          ? theme.primaryColor.withAlpha(30)
                                          : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  selected ? 'SELECTED' : 'SELECT',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        selected
                                            ? theme.primaryColor
                                            : const Color(0xff2864A6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onAddPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2864A6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
