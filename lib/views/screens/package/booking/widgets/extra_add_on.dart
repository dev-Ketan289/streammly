import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/services/constants.dart';

import '../../../../../controllers/package_page_controller.dart'; // Update import as needed

class ExtraAddOnsPage extends StatefulWidget {
  final int packageId;
  final int studioId; // Required for price/studio-specific details

  const ExtraAddOnsPage({
    super.key,
    required this.packageId,
    required this.studioId,
  });

  @override
  State<ExtraAddOnsPage> createState() => _ExtraAddOnsPageState();
}

class _ExtraAddOnsPageState extends State<ExtraAddOnsPage> {
  final Set<int> _selectedIndexes = {};

  late PackagesController packagesController;

  bool _showAddOns = true;

  @override
  void initState() {
    super.initState();
    packagesController = Get.find<PackagesController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      packagesController.fetchPaidAddOns(widget.packageId, widget.studioId);
    });
  }

  void _onContinuePressed() {
    final addons = packagesController.paidAddOnResponse?.addons ?? [];
    final selectedAddons = _selectedIndexes.map((i) => addons[i]).toList();

    // Build the result map to return
    final result =
        selectedAddons.map((addon) {
          return {
            'id': addon.id,
            'title': addon.productTitle,
            'description': addon.description,
            'image': addon.coverImage,
            'price': addon.price,
            'mainTitle': addon.mainTitle,
            'usageType': addon.usageType,
          };
        }).toList();

    packagesController.selectedExtraAddons = result;

    Navigator.pop(context, result);
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
          'Extra Add-Ons',
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
              final loading = controller.isFetchingPaidAddOns;
              final resp = controller.paidAddOnResponse;
              final items = resp?.addons ?? [];
              final mainTitle =
                  (resp?.mainTitles.isNotEmpty == true)
                      ? resp!.mainTitles.first
                      : "Extra Add-Ons";

              if (loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (items.isEmpty) {
                return const Center(child: Text("No extra add-ons available."));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showAddOns = !_showAddOns),
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
                          _showAddOns
                              ? Icons.remove_circle_outline
                              : Icons.add_circle_outline,
                          color: const Color(0xff2864A6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_showAddOns)
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final selected = _selectedIndexes.contains(index);

                          // Smart image logic: use as-is if absolute, else prepend base (recommended: get base URL from config/env)
                          Widget imageWidget;
                          if (item.coverImage != null &&
                              item.coverImage!.isNotEmpty) {
                            final uri = Uri.tryParse(item.coverImage!);
                            final url =
                                (uri != null && uri.hasScheme)
                                    ? item.coverImage!
                                    : "${AppConstants.baseUrl}/${item.coverImage!}";
                            imageWidget = Image.network(
                              url,
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (c, o, e) => Container(
                                    height: 50,
                                    width: 50,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  ),
                            );
                          } else {
                            imageWidget = Container(
                              height: 50,
                              width: 50,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image),
                            );
                          }

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
                                    child: imageWidget,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        Text(
                                          'Shoot Duration : 1',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        item.price != null
                                            ? 'Rs ${item.price} /-'
                                            : 'Rs -- /-',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (selected) {
                                              _selectedIndexes.remove(index);
                                            } else {
                                              _selectedIndexes.add(index);
                                            }
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              selected
                                                  ? theme.primaryColor
                                                      .withAlpha(30)
                                                  : null,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          selected ? 'SELECTED' : 'SELECT',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    selected
                                                        ? theme.primaryColor
                                                        : const Color(
                                                          0xff2864A6,
                                                        ),
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2864A6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Let\'s Continue',
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
