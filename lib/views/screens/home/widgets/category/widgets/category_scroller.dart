import 'package:flutter/material.dart';
import 'package:streammly/services/custom_image.dart';
import 'package:streammly/services/theme.dart';

import '../../../../../../models/category/category_item.dart';

class CategoryScroller extends StatelessWidget {
  final String? title;
  final VoidCallback? onSeeAll;
  final List<CategoryItem> categories;

  const CategoryScroller({
    super.key,
    this.title,
    this.onSeeAll,
    required this.categories,
  });

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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: backgroundDark,
                  ),
                ),
                if (onSeeAll != null)
                  InkWell(
                    onTap: onSeeAll,
                    child: Row(
                      children: [
                        Text(
                          "See all",
                          style: TextStyle(color: primaryColor, fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: primaryColor,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // ✅ Updated: Increased height to accommodate text wrapping
          SizedBox(
            height: 110, // Increased from 90 to 110
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = categories[index];
                return SizedBox(
                  width: 70, // ✅ Fixed width for consistent layout
                  child: Column(
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
                            child:
                                item.imagePath != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CustomImage(
                                        path: item.imagePath!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Icon(
                                      item.icon,
                                      size: 28,
                                      color: Colors.blue,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // ✅ Updated: Better text wrapping
                      Container(
                        height: 36, // Fixed height for text area
                        child: Text(
                          item.label,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            fontSize: 10, // Increased from 9 to 10
                            fontWeight: FontWeight.w600, // Slightly lighter
                            color: const Color(0xff575861),
                            height: 1.2, // Line height for better readability
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 3, // Allow up to 3 lines
                          overflow:
                              TextOverflow
                                  .ellipsis, // Fallback for very long text
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
