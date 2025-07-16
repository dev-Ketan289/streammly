import 'package:flutter/material.dart';

class ExtraAddOnsPage extends StatefulWidget {
  const ExtraAddOnsPage({super.key});

  @override
  State<ExtraAddOnsPage> createState() => _ExtraAddOnsPageState();
}

class _ExtraAddOnsPageState extends State<ExtraAddOnsPage> {
  final List<Map<String, dynamic>> cakeSmashAddOns = [
    {'title': 'Readymade Cake Smash Shoot', 'description': 'Length / Time\n1 Hr', 'price': '3600', 'duration': 1, 'image': null},
    {'title': 'Premium Cake Smash Shoot', 'description': 'Length / Time\n1 Hr', 'price': '6000', 'duration': 1, 'image': null},
  ];

  final List<Map<String, dynamic>> toddlerSetupAddOns = [
    {
      'title': 'The Old After Party',
      'description': 'This Theme is available for Studio Only',
      'price': '0',
      'duration': 1,
      'image': 'assets/images/booking_images/Frame 2118060031.png',
    },
    {'title': 'The Heist', 'description': 'This Theme is available for Studio Only', 'price': '0', 'duration': 1, 'image': 'assets/images/booking_images/Frame 2118060031 (1).png'},
    {'title': 'The Pink Candy', 'description': 'The Pink Candy - Only for studio', 'price': '0', 'duration': 1, 'image': 'assets/images/booking_images/Frame 2118060031 (2).png'},
  ];

  final Set<int> _selectedCake = {};
  final Set<int> _selectedToddler = {};

  bool _showCakeSmash = false;
  bool _showToddlerSetup = false;

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
        title: Text('Extra Add-Ons', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xff2864A6))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.grey.withAlpha(30), blurRadius: 8)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdownSection(
                title: 'Cake Smash Packages',
                show: _showCakeSmash,
                onToggle: () => setState(() => _showCakeSmash = !_showCakeSmash),
                items: cakeSmashAddOns,
                selectedIndexes: _selectedCake,
                theme: theme,
              ),
              const SizedBox(height: 20),
              _buildDropdownSection(
                title: 'Toddler Live Setup',
                show: _showToddlerSetup,
                onToggle: () => setState(() => _showToddlerSetup = !_showToddlerSetup),
                items: toddlerSetupAddOns,
                selectedIndexes: _selectedToddler,
                theme: theme,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final selected = [..._selectedCake.map((i) => cakeSmashAddOns[i]), ..._selectedToddler.map((i) => toddlerSetupAddOns[i])];
                    Navigator.pop(context, selected);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2864A6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Let\'s Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownSection({
    required String title,
    required bool show,
    required VoidCallback onToggle,
    required List<Map<String, dynamic>> items,
    required Set<int> selectedIndexes,
    required ThemeData theme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              Icon(show ? Icons.remove_circle_outline : Icons.add_circle_outline, color: const Color(0xff2864A6)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (show)
          ...List.generate(items.length, (index) {
            final item = items[index];
            final selected = selectedIndexes.contains(index);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xffF9F9F9), border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    if (item['image'] != null)
                      ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.asset(item['image'], height: 50, width: 50, fit: BoxFit.cover))
                    else
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'], style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(item['description'], style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('Shoot Duration : ${item['duration']}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Rs ${item['price']}/-', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              if (selected) {
                                selectedIndexes.remove(index);
                              } else {
                                selectedIndexes.add(index);
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: selected ? theme.primaryColor.withAlpha(30) : null,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Text(
                            selected ? 'SELECTED' : 'SELECT',
                            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: selected ? theme.primaryColor : const Color(0xff2864A6)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
