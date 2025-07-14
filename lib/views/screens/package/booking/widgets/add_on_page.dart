import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemSelectionPage extends StatelessWidget {
  final int packageIndex;
  final String type; // "free" or "extra"
  final List<Map<String, dynamic>> items;

  const ItemSelectionPage({
    super.key,
    required this.packageIndex,
    required this.type,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = Rxn<Map<String, dynamic>>();

    return Scaffold(
      appBar: AppBar(title: const Text("Select Items")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("RENTAL GOWNS", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemBuilder: (context, index) {
                final product = items[index];
                return Obx(() {
                  final isSelected = selectedItem.value?['id'] == product['id'];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Image.network(
                        'https://admin.streammly.com/${product['cover_image']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product['title'] ?? ""),
                      subtitle: Text(product['decription'] ?? ""),
                      trailing: TextButton(
                        onPressed: () {
                          selectedItem.value = product;
                        },
                        child: Text(isSelected ? "SELECTED" : "SELECT"),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Colors.green.shade800),
              onPressed: () {
                if (selectedItem.value != null) {
                  Get.back(result: selectedItem.value);
                } else {
                  Get.snackbar("Error", "Please select an item");
                }
              },
              child: const Text("Continue", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
