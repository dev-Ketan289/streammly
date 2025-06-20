import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final Set<Marker> _customMarkers = {};

  @override
  void initState() {
    super.initState();
    controller.selectedCategoryId.value = widget.categoryId;
    _loadData();
  }

  Future<void> _loadData() async {
    // ✅ Clear previous markers before loading new ones
    _customMarkers.clear();
    setState(() {}); // Refresh UI to clear the map before adding new markers

    await controller.fetchCompaniesByCategory(controller.selectedCategoryId.value);
    await _generateCustomMarkers();
  }

  Future<void> _generateCustomMarkers() async {
    _customMarkers.clear();

    for (var company in controller.companies) {
      final distanceText =
          company.distanceKm != null ? (company.distanceKm! < 1 ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m" : "${company.distanceKm!.toStringAsFixed(1)} km") : "--";

      final bytes = await _createCustomMarkerBitmap(context, company.companyName, distanceText);

      _customMarkers.add(
        Marker(
          markerId: MarkerId(company.companyName),
          position: LatLng(company.latitude!, company.longitude!),
          icon: BitmapDescriptor.bytes(bytes),
          onTap: () => controller.selectCompany(company),
        ),
      );
    }

    setState(() {}); // Update UI with new markers
  }

  Future<Uint8List> _createCustomMarkerBitmap(BuildContext context, String title, String distance) async {
    final key = GlobalKey();

    final widget = Material(type: MaterialType.transparency, child: RepaintBoundary(key: key, child: _buildCustomMarker(title, distance)));

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(builder: (_) => Center(child: widget));
    overlay.insert(entry);
    await Future.delayed(const Duration(milliseconds: 100));

    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    entry.remove();
    return pngBytes;
  }

  Widget _buildCustomMarker(String title, String distance) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
          child: Text(distance, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(minWidth: 80),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]),
          child: Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(target: LatLng(19.2189, 72.9805), zoom: 12),
            markers: _customMarkers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),

          /// Category Dropdown
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
                        return DropdownMenuItem<int>(value: category.id, child: Center(child: Text(category.title, textAlign: TextAlign.center)));
                      }).toList(),
                  onChanged: (int? newId) {
                    if (newId != null) {
                      controller.selectedCategoryId.value = newId;
                      controller.selectedCompany.value = null;
                      _loadData(); // Reload with new category
                    }
                  },
                ),
              );
            }),
          ),

          /// Info Card
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
                    if (company.distanceKm != null)
                      Text(
                        company.distanceKm! < 1 ? "Distance: ${(company.distanceKm! * 1000).toStringAsFixed(0)} meters" : "Distance: ${company.distanceKm!.toStringAsFixed(2)} km",
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
