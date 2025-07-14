import 'package:flutter/material.dart';

import 'filter_page.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  bool isGridView = true;
  int selectedIndex = -1;

  final List<Map<String, dynamic>> packages = [
    {
      "title": "Cuteness",
      "type": "HomeShoot",
      "price": 5999,
      "oldPrice": 8999,
      "hours": ["1hr", "2hrs", "3hrs"],
      "highlight": "Today 50% discount on all products in Chapter with online orders",
      "specialOffer": true,
    },
    {
      "title": "Moments",
      "type": "StudioShoot",
      "price": 15999,
      "oldPrice": 19999,
      "hours": ["1hr", "2hrs", "3hrs"],
      "highlight": "",
      "specialOffer": true,
    },
    {
      "title": "Wonders",
      "type": "HomeShoot",
      "price": 13999,
      "oldPrice": null,
      "hours": ["1hr", "2hrs", "3hrs"],
      "highlight": "",
      "specialOffer": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Packages"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => const FilterPage()),
          ),
          IconButton(icon: Icon(isGridView ? Icons.view_list : Icons.grid_view), onPressed: () => setState(() => isGridView = !isGridView)),
        ],
      ),
      body: isGridView ? buildGridView() : buildListView(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.indigo),
          onPressed: () {},
          child: const Text("Let's Continue"),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68),
      itemBuilder: (context, index) {
        final pkg = packages[index];
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.indigo[800] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(2, 4))],
              border: isSelected ? Border.all(color: Colors.indigo, width: 2) : Border.all(color: Colors.grey[300]!),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(pkg["title"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                        const SizedBox(height: 4),
                        Text(pkg["type"], style: TextStyle(fontSize: 14, color: isSelected ? Colors.white70 : Colors.grey)),
                        const SizedBox(height: 12),
                        Text("Just For", style: TextStyle(fontSize: 12, color: isSelected ? Colors.white70 : Colors.black54)),
                        Text("₹${pkg["price"]}/-", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.indigo)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          pkg["hours"]
                              .map<Widget>(
                                (h) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: isSelected ? Colors.indigo[400] : Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                                    child: Text(h, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : Colors.black87)),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.white : Colors.indigo,
                          foregroundColor: isSelected ? Colors.indigo : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {},
                        child: const Text("View More"),
                      ),
                    ),
                  ],
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: const Icon(Icons.check_circle, color: Colors.indigo, size: 20),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        final pkg = packages[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pkg["specialOffer"])
                Container(
                  color: Colors.amber[800],
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: const Text("SPECIAL OFFER", style: TextStyle(color: Colors.white)),
                ),
              ListTile(
                title: Text(pkg["title"], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(pkg["type"]),
                trailing: Text("₹${pkg["price"]}/-", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(pkg["highlight"])),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children:
                      pkg["hours"]
                          .map<Widget>((h) => Padding(padding: const EdgeInsets.only(right: 8), child: Chip(label: Text(h, style: const TextStyle(fontSize: 10)))))
                          .toList(),
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: ElevatedButton(onPressed: () {}, child: const Text("Buy"))),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
