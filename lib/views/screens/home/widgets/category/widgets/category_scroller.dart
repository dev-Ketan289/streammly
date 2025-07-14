import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

import '../../../../../../models/category/category_item.dart';

class CategoryScroller extends StatelessWidget {
  final String? title;
  final VoidCallback? onSeeAll;
  final List<CategoryItem> categories;

  const CategoryScroller({super.key, this.title, this.onSeeAll, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title!, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                if (onSeeAll != null)
                  InkWell(
                    onTap: onSeeAll,
                    child: Row(
                      children:  [
                        Text("See all", style: TextStyle(color: primaryColor, fontSize: 13)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14, color: primaryColor),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = categories[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: item.onTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Ink(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(color: const Color(0xFFF0F6FF), borderRadius: BorderRadius.circular(16)),
                          child:
                              item.imagePath != null
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(item.imagePath!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey)),
                                  )
                                  : Icon(item.icon, size: 28, color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(item.label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xff575861)), textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
