import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedSort = "Rating: High to Low";

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder:
          (_, controller) => Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.close, size: 24, color: Colors.black)),
                      const SizedBox(width: 16),
                      const Text("Sort/Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSort = null;
                          });
                        },
                        child: const Text("Clear all", style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),

                // Content - Two column layout
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Categories
                      Container(
                        width: 120,
                        color: Colors.grey.shade50,
                        child: Column(
                          children: [
                            _buildCategoryItem("Sort", true),
                            _buildCategoryItem("Offers", false),
                            _buildCategoryItem("Gender", false),
                            _buildCategoryItem("Timing", false),
                          ],
                        ),
                      ),

                      // Right side - Options
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: ListView(
                            controller: controller,
                            padding: const EdgeInsets.all(16),
                            children: [
                              _buildSortOption("Popularity"),
                              const SizedBox(height: 8),
                              _buildSortOption("Rating: High to Low"),
                              const SizedBox(height: 8),
                              _buildSortOption("Cost: High to Low"),
                              const SizedBox(height: 8),
                              _buildSortOption("Cost: Low to High"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Done Button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Done", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildCategoryItem(String title, bool isActive) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: isActive ? Colors.white : Colors.grey.shade50, border: isActive ? const Border(right: BorderSide(color: Colors.blue, width: 3)) : null),
      child: Row(
        children: [
          if (title == "Gender") const Icon(Icons.person, size: 16, color: Colors.blue),
          if (title == "Gender") const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400, color: isActive ? Colors.black : Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildSortOption(String title) {
    bool isSelected = selectedSort == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSort = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked, color: isSelected ? Colors.purple : Colors.grey.shade400, size: 20),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: isSelected ? Colors.purple : Colors.black)),
          ],
        ),
      ),
    );
  }
}
