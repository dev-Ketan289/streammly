import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/navigation_menu.dart';

class EnterLocationManuallyScreen extends StatelessWidget {
  const EnterLocationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FF),
      appBar: AppBar(
        title: const Text("Location"),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Get.back()),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Location here",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
          ),

          // 🗺️ Map Background (just image for now)
          Expanded(
            child: Stack(
              children: [
                Image.asset('assets/images/location_map_bottom.jpg', width: double.infinity, height: double.infinity, fit: BoxFit.fill),
                Positioned.fill(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.35,
                    minChildSize: 0.35,
                    maxChildSize: 0.8,
                    builder:
                        (context, scrollController) => Container(
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                          padding: const EdgeInsets.all(16),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8)))),
                              const SizedBox(height: 16),
                              const Text("Detail Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const ListTile(
                                leading: Icon(Icons.location_pin, color: Colors.blue),
                                title: Text("Home"),
                                subtitle: Text("305/A, Navneet Building, Saivihar Road,\nBhandup (W), Mumbai 400078."),
                              ),
                              const Divider(),
                              const Text("Saved Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const ListTile(
                                leading: Icon(Icons.home, color: Colors.blue),
                                title: Text("Home"),
                                subtitle: Text("203/A, Avisha Building, Vaidya Wadi,\nThakurdwar, Girgaon, Mumbai"),
                              ),
                              const ListTile(
                                leading: Icon(Icons.work, color: Colors.blue),
                                title: Text("Work"),
                                subtitle: Text("104, Hiren Industrial Estate, New Dinkar Co Operative Housing Society,\nMahim, Mumbai."),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => NavigationMenu()));
                                  // Your confirm action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Confirm Location"),
                              ),
                            ],
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
