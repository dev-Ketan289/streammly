import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streammly/controllers/location_controller.dart';

class VendorLocator extends StatelessWidget {
  final controller = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();

  VendorLocator({super.key});

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
              onTap: (LatLng position) {
                // Allow users to tap on map to select location
                controller.updateLocation(position.latitude, position.longitude);
              },
              markers: {
                Marker(
                  markerId: const MarkerId("selected_location"),
                  position: LatLng(controller.rxLat.value, controller.rxLng.value),
                  draggable: true,
                  onDragEnd: (LatLng position) {
                    controller.updateLocation(position.latitude, position.longitude);
                  },
                ),
              },
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
                    // Row(
                    //   children: [
                    //     IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Get.back()),
                    //     const SizedBox(width: 8),
                    //     const Text("Select Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    //   ],
                    // ),
                    // const SizedBox(height: 8),

                    // Search Box with improved design
                    Container(
                      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: TextField(
                        controller: searchController,
                        onChanged: controller.searchAutocomplete,
                        decoration: InputDecoration(
                          hintText: "Search Location here",
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon:
                              searchController.text.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      searchController.clear();
                                      controller.clearSuggestions();
                                    },
                                  )
                                  : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),

                    // Suggestion List with improved styling
                    if (controller.suggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: ListView.separated(
                          itemCount: controller.suggestions.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final prediction = controller.suggestions[index];
                            return ListTile(
                              leading: const Icon(Icons.location_on, color: Colors.blue),
                              title: Text(prediction.description ?? '', style: const TextStyle(fontSize: 14)),
                              onTap: () {
                                controller.selectPrediction(prediction);
                                searchController.text = prediction.description ?? '';
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
