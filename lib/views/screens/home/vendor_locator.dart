import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/company_controller.dart';

class CompanyLocatorMapScreen extends StatefulWidget {
  final int categoryId;

  const CompanyLocatorMapScreen({super.key, required this.categoryId});

  @override
  State<CompanyLocatorMapScreen> createState() => _CompanyLocatorMapScreenState();
}

class _CompanyLocatorMapScreenState extends State<CompanyLocatorMapScreen> {
  final MapController controller = Get.put(MapController());
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    // set the selected category and fetch companies
    controller.selectedCategoryId.value = widget.categoryId;
    controller.fetchCompaniesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            /// Google Map
            GoogleMap(
              initialCameraPosition: const CameraPosition(target: LatLng(19.2189, 72.9805), zoom: 12),
              markers:
                  controller.companies.map((company) {
                    return Marker(
                      markerId: MarkerId(company.companyName),
                      position: LatLng(company.latitude!, company.longitude!),
                      onTap: () => controller.selectCompany(company),
                      infoWindow: InfoWindow(title: company.companyName),
                    );
                  }).toSet(),
            ),

            /// Dropdown for selecting category (Dynamic)
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton<int>(
                    value: controller.selectedCategoryId.value,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items:
                        categoryController.categories.map((category) {
                          return DropdownMenuItem<int>(value: category.id, child: Text(category.title, textAlign: TextAlign.center));
                        }).toList(),
                    onChanged: (int? newId) {
                      if (newId != null) {
                        controller.selectedCategoryId.value = newId;
                        controller.fetchCompaniesByCategory(newId);
                        controller.selectedCompany.value = null;
                      }
                    },
                  ),
                );
              }),
            ),

            /// Info Card when company is selected
            Obx(() {
              final company = controller.selectedCompany.value;
              if (company == null) return const SizedBox();

              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(company.companyName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text("Lat: ${company.latitude}"),
                      Text("Lng: ${company.longitude}"),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
