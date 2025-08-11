import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:streammly/controllers/location_controller.dart';
import 'package:streammly/controllers/promo_slider_controller.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/views/screens/common/widgets/add_new_address.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/company_controller.dart';
import '../../../controllers/home_screen_controller.dart';

class EnterLocationManuallyScreen extends StatelessWidget {
  final controller = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();

  EnterLocationManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: GetBuilder<LocationController>(
        builder: (_) {
          return Stack(
            children: [
              /// ---------- MAP BACKGROUND ----------
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    controller.lat,
                    controller.lng,
                  ),
                  zoom: 15,
                ),
                onMapCreated: (mapController) {
                  controller.setMapController(mapController);
                },
                onTap: (LatLng position) {
                  controller.updateLocation(
                    position.latitude,
                    position.longitude,
                  );
                },
                markers: {
                  Marker(
                    markerId: const MarkerId("selected_location"),
                    position: LatLng(
                      controller.lat,
                      controller.lng,
                    ),
                  ),
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),

              /// ---------- SEARCH BAR ON TOP ----------
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: controller.searchAutocomplete,
                          decoration: InputDecoration(
                            hintText: "Search Location here",
                            prefixIcon: Icon(
                              Icons.search,
                              color: theme.hintColor,
                            ),
                            suffixIcon: searchController.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: theme.hintColor,
                              ),
                              onPressed: () {
                                searchController.clear();
                                controller.clearSuggestions();
                              },
                            )
                                : null,
                            filled: true,
                            fillColor: colorScheme.surface,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      if (controller.suggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 200,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            itemCount: controller.suggestions.length,
                            separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final prediction =
                              controller.suggestions[index];
                              return ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: colorScheme.primary,
                                ),
                                title: Text(
                                  prediction.description ?? '',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                onTap: () {
                                  controller.selectPrediction(prediction);
                                  searchController.text =
                                      prediction.description ?? '';
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
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            "Selected Location",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colorScheme.primary,
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Current Selection",
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        controller.formattedCurrentLocation,
                                        style:
                                        theme.textTheme.bodySmall!.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          const Divider(),

                          Text(
                            "Saved Addresses",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // ✅ DYNAMIC LIST
                          ...controller.savedAddresses.map((saved) {
                            return _buildSavedAddressTile(
                              context,
                              icon: saved.type.icon,
                              title: saved.title,
                              subtitle: saved.address,
                              onTap: () => controller.updateLocation(
                                  saved.lat, saved.lng),
                              onEdit: () {
                                Get.to(() => AddressPage(
                                  mode: AddressPageMode.edit,
                                  existingAddress: AddressModel(
                                    line1: saved.address,
                                    line2: '',
                                    city: '',
                                    state: '',
                                    pincode: '',
                                    isPrimary: false,
                                  ),
                                ))?.then((updated) {
                                  if (updated is AddressModel) {
                                    controller.updateSavedAddress(
                                        saved.id, updated);
                                  }
                                });
                              },
                            );
                          }).toList(),

                          const SizedBox(height: 8),

                          TextButton.icon(
                            onPressed: () {
                              Get.to(() => AddressPage(
                                mode: AddressPageMode.add,
                              ))?.then((updated) {
                                if (updated is AddressModel) {
                                  controller.addSavedAddress(SavedAddress(
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    title: updated.isPrimary
                                        ? "Primary"
                                        : "Custom",
                                    address:
                                    '${updated.line1}, ${updated.line2}, ${updated.city}, ${updated.state}, ${updated.pincode}',
                                    lat: controller.lat,
                                    lng: controller.lng,
                                    type: AddressType.other,
                                  ));
                                }
                              });
                            },
                            icon: Icon(Icons.add, color: colorScheme.primary),
                            label: Text(
                              "Add New Address",
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.saveSelectedLocation();
                                Get.find<HomeController>().fetchSlides();
                                Get.find<HomeController>()
                                    .fetchRecommendedCompanies();
                                Get.find<CategoryController>()
                                    .fetchCategories();
                                Get.find<PromoSliderController>()
                                    .fetchSliders();
                                Get.find<CompanyController>()
                                    .fetchAndCacheCompanyById(1);
                                Get.to(() => NavigationFlow());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                "Confirm Location",
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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
        },
      ),
    );
  }

  Widget _buildSavedAddressTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        VoidCallback? onEdit,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
        ),
        onTap: onTap,
        trailing: onEdit != null
            ? IconButton(
          icon: const Icon(Icons.edit_location_alt, size: 20),
          onPressed: onEdit,
        )
            : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
