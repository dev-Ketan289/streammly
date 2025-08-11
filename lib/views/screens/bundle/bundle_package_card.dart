import 'package:flutter/material.dart';

class BundlePackageCard extends StatelessWidget {
  final String vendorId;
  final String companyName;
  final Map<String, dynamic> package;
  final bool isSelected;
  final String selectedHour;
  final VoidCallback onPackageTap;
  final void Function(String hour) onHourTap;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const BundlePackageCard({
    super.key,
    required this.vendorId,
    required this.companyName,
    required this.package,
    required this.isSelected,
    required this.selectedHour,
    required this.onPackageTap,
    required this.onHourTap,
    required this.isExpanded,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceMap = package["priceMap"] as Map<String, dynamic>? ?? {};
    final updatedPrice = priceMap[selectedHour] ?? package["price"];
    final hours = package["hours"] as List<dynamic>? ?? [];
    final shortDesc = package["shortDescription"] ?? '';
    final fullDesc = package["fullDescription"] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: isSelected ? Border.all(color: const Color(0xFF4A6CF7), width: 2) : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (package["specialOffer"] == true)
              Builder(
                builder: (context) {
                  Color resolveRibbonColor(String rawType) {
                    final t = rawType.toLowerCase().trim();
                    if ( t.contains('offer')) {
                      return const Color(0xffC59732); // gold
                    }
                    if (t.contains('premium')) {
                      return const Color(0xFF6A1B9A); // purple
                    }
                    if (t.contains('standard')) {
                      return const Color(0xFF4A6CF7); // blue used in bundle card
                    }
                    return const Color(0xffC59732);
                  }

                  final String typeText = (package["package_type"] ?? package["type"] ?? '').toString();
                  String resolveLabel(String rawType) {
                    final t = rawType.toLowerCase().trim();
                    if ( t.contains('standard')) {
                      return 'BASIC';
                    }
                    return rawType.toUpperCase();
                  }
                  final Color ribbonColor = resolveRibbonColor(typeText);

                  return Container(
                    width: 36,
                    decoration: BoxDecoration(
                      color: ribbonColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    ),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Center(
                        child: Text(
                          resolveLabel(typeText),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(package["title"] ?? '', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87)),
                              const SizedBox(height: 4),
                              Text(package["type"] ?? '', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onPackageTap,
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

                    /// Price Row
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text("Just For", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(width: 8),
                        if (package["oldPrice"] != null) ...[
                          Text("₹${package["oldPrice"]}", style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                          const SizedBox(width: 8),
                        ],
                        Text("₹$updatedPrice/-", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF4A6CF7))),
                      ],
                    ),

                    const SizedBox(height: 10),

                    /// Hour Selection
                    Wrap(
                      spacing: 8,
                      children:
                          hours.map<Widget>((h) {
                            final selected = selectedHour == h;
                            return GestureDetector(
                              onTap: () => onHourTap(h),
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

                    /// Highlight
                    if ((package["highlight"] ?? '').toString().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(package["highlight"], style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Colors.black87)),
                    ],

                    /// Description with Read More / Less
                    if (shortDesc.isNotEmpty || fullDesc.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(isExpanded ? fullDesc : shortDesc, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700], height: 1.4)),
                      if (shortDesc != fullDesc && fullDesc.isNotEmpty)
                        GestureDetector(
                          onTap: onExpandToggle,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(isExpanded ? "Read Less" : "Read More", style: const TextStyle(fontSize: 12, color: Color(0xFF4A6CF7), fontWeight: FontWeight.w500)),
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
    );
  }
}
