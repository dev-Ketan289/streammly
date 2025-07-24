import 'package:flutter/material.dart';

class FreeItemsPage extends StatefulWidget {
  const FreeItemsPage({super.key});

  @override
  State<FreeItemsPage> createState() => _FreeItemsPageState();
}

class _FreeItemsPageState extends State<FreeItemsPage> {
  bool _showItems = false;
  int _selectedIndex = -1;

  final mainTitle = 'Toddler Live Setup';
  final titles = ['The Old After Party', 'The Heist', 'The Pink Candy'];
  final descriptions = ['This Theme is available for Studio Only', 'This Theme is available for Studio Only', 'The Pink Candy - Only for studio'];
  final images = [
    'assets/images/booking_images/Frame 2118060031.png',
    'assets/images/booking_images/Frame 2118060031 (1).png',
    'assets/images/booking_images/Frame 2118060031 (2).png',
  ];

  void _onAddPressed() {
    if (_selectedIndex != -1) {
      Navigator.pop(context, {'title': titles[_selectedIndex], 'description': descriptions[_selectedIndex], 'image': images[_selectedIndex]});
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
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context), color: Colors.black),
        centerTitle: true,
        title: Text('Free Items', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xff2864A6))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withAlpha(30), blurRadius: 8)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Main Title Dropdown Toggle =====
              GestureDetector(
                onTap: () => setState(() => _showItems = !_showItems),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mainTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    Icon(_showItems ? Icons.remove_circle_outline : Icons.add_circle_outline, color: const Color(0xff2864A6)),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ===== Product List Items =====
              if (_showItems)
                ...List.generate(titles.length, (index) {
                  final selected = _selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xffF9F9F9), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(images[index], height: 50, width: 50, fit: BoxFit.cover)),
                          const SizedBox(width: 12),

                          // ===== Product Info =====
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(titles[index], style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(descriptions[index], style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                const Text('Shoot Duration : 1', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // ===== Select Button =====
                          TextButton(
                            onPressed: () => setState(() => _selectedIndex = index),
                            style: TextButton.styleFrom(
                              backgroundColor: selected ? theme.primaryColor.withAlpha(30) : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text(
                              selected ? 'SELECTED' : 'SELECT',
                              style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: selected ? theme.primaryColor : const Color(0xff2864A6)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 12),

              // ===== Add Button =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onAddPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2864A6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
