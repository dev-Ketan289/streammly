import 'package:flutter/material.dart';
import '../../../../../models/category/category_item.dart';

class CategoryScroller extends StatelessWidget {
  final String? title;
  final VoidCallback? onSeeAll;
  final List<CategoryItem> categories;

  const CategoryScroller({super.key, this.title, this.onSeeAll, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title!,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (onSeeAll != null)
                  InkWell(
                    onTap: onSeeAll,
                    child: Row(
                      children: [
                        Text(
                          "See all",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          /// Horizontal Scroll List
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
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F6FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: item.imagePath != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(item.imagePath!, fit: BoxFit.cover),
                          )
                              : Icon(item.icon, size: 28, color: theme.colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          item.label,
                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
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
