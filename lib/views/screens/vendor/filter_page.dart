import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder:
          (_, controller) => Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
            padding: const EdgeInsets.all(16),
            child: ListView(
              controller: controller,
              children: [
                const Text("Sort/Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                const Text("Sort", style: TextStyle(fontWeight: FontWeight.bold)),
                ...[
                  "Popularity",
                  "Rating: High to Low",
                  "Cost: High to Low",
                  "Cost: Low to High",
                ].map((label) => ListTile(leading: const Icon(Icons.radio_button_checked_outlined), title: Text(label), onTap: () {})),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo), child: const Text("Done")),
              ],
            ),
          ),
    );
  }
}
