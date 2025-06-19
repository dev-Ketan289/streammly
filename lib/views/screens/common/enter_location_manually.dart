import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/navigation_menu.dart';
import 'package:streammly/views/screens/common/widgets/add_new_address.dart';

class EnterLocationManuallyScreen extends StatelessWidget {
  final controller = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();

  EnterLocationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            /// ---------- MAP BACKGROUND ----------
            Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(controller.rxLat.value, controller.rxLng.value), zoom: 15),
                onMapCreated: (mapController) {
                  controller.setMapController(mapController);
                },
                onTap: (LatLng position) {
                  controller.updateLocation(position.latitude, position.longitude);
                },
                markers: {Marker(markerId: const MarkerId("selected_location"), position: LatLng(controller.rxLat.value, controller.rxLng.value))},
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),

            /// ---------- SEARCH BAR ON TOP ----------
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))]),
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

                    if (controller.suggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
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

            /// ---------- DRAGGABLE BOTTOM SHEET ----------
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)))),
                        const SizedBox(height: 16),

                        const Text("Selected Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.location_pin, color: Colors.white, size: 20)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Current Selection", style: TextStyle(fontWeight: FontWeight.w500)),
                                    Obx(() => Text(controller.formattedCurrentLocation, style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(),

                        const Text("Saved Addresses", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        _buildSavedAddressTile(
                          icon: Icons.home,
                          title: "Home",
                          subtitle: "203/A, Avisha Building, Girgaon, Mumbai",
                          onTap: () {
                            controller.updateLocation(18.9547, 72.8156);
                          },
                        ),

                        _buildSavedAddressTile(
                          icon: Icons.work,
                          title: "Work",
                          subtitle: "104, Dinkar Co-Op Society, Mahim, Mumbai",
                          onTap: () {
                            controller.updateLocation(19.0330, 72.8397);
                          },
                        ),

                        const SizedBox(height: 8),

                        TextButton.icon(
                          onPressed: () => Get.to(() => const AddNewAddressScreen()),
                          icon: const Icon(Icons.add, color: Colors.blue),
                          label: const Text("Add New Address", style: TextStyle(color: Colors.blue)),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.saveSelectedLocation();
                              Get.to(() => NavigationMenu());
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 2),
                            child: const Text("Confirm Location", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          ),
                        ),

                        const SizedBox(height: 16),
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

  Widget _buildSavedAddressTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.1), child: Icon(icon, color: Colors.blue, size: 20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
