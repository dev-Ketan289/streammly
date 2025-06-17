import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/navigation_menu.dart';
import 'package:streammly/views/screens/common/widgets/add_new_address.dart';

class EnterLocationManuallyScreen extends StatelessWidget {
  final controller = Get.put(LocationController());

  EnterLocationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            /// ---------- MAP BACKGROUND ----------
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(controller.rxLat.value, controller.rxLng.value), zoom: 15),
              onMapCreated: (mapController) {
                controller.setMapController(mapController);
              },
              markers: {Marker(markerId: const MarkerId("selected_location"), position: LatLng(controller.rxLat.value, controller.rxLng.value))},
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),

            /// ---------- SEARCH BAR ON TOP ----------
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back + Title
                    Row(
                      children: [
                        IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()),
                        const SizedBox(width: 8),
                        const Text("Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Search Box
                    TextField(
                      onChanged: controller.searchAutocomplete,
                      decoration: InputDecoration(
                        hintText: "Search Location here",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),

                    // Suggestion List (if any)
                    if (controller.suggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 200,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: ListView.builder(
                          itemCount: controller.suggestions.length,
                          itemBuilder: (context, index) {
                            final prediction = controller.suggestions[index];
                            return ListTile(title: Text(prediction.description ?? ''), onTap: () => controller.selectPrediction(prediction));
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// ---------- DRAGGABLE BOTTOM SHEET ----------
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)))),
                        const SizedBox(height: 16),

                        const Text("Detail Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.location_pin, color: Colors.blue)),
                          title: const Text("Home"),
                          subtitle: Obx(() => Text("Lat: ${controller.rxLat.value}, Lng: ${controller.rxLng.value}")),
                        ),

                        const Divider(),
                        const Text("Saved Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.home, color: Colors.blue)),
                          title: const Text("Home"),
                          subtitle: const Text("203/A, Avisha Building, Girgaon, Mumbai"),
                        ),
                        ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.work, color: Colors.blue)),
                          title: const Text("Work"),
                          subtitle: const Text("104, Dinkar Co-Op Society, Mahim, Mumbai"),
                        ),

                        TextButton.icon(
                          onPressed: () => Get.to(() => const AddNewAddressScreen()),
                          icon: const Icon(Icons.add, color: Colors.blue),
                          label: const Text("Add New Address", style: TextStyle(color: Colors.blue)),
                        ),

                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => NavigationMenu()); // or perform save
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: const Text("Confirm Location", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    );
  }
}
