import 'dart:async';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/company_controller.dart';
import '../vendor/vendor_description.dart';
import '../vendor/widgets/vendor_info_card.dart';

class CompanyLocatorMapScreen extends StatefulWidget {
  final int categoryId;

  const CompanyLocatorMapScreen({super.key, required this.categoryId});

  @override
  State<CompanyLocatorMapScreen> createState() => _CompanyLocatorMapScreenState();
}

class _CompanyLocatorMapScreenState extends State<CompanyLocatorMapScreen> {
  final CompanyController controller = Get.find<CompanyController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final Set<Marker> _customMarkers = {};
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setCategoryId(widget.categoryId);
      _loadData();
    });
  }

  Future<void> _loadData() async {
    _customMarkers.clear();
    setState(() {});

    final status = await Permission.location.request();
    if (status.isDenied) {
      Get.snackbar("Location Required", "Please allow location access.");
      return;
    } else if (status.isPermanentlyDenied) {
      Get.snackbar("Permission Blocked", "Enable location in app settings.");
      await openAppSettings();
      return;
    }

    // Always use current selected category
    await controller.fetchCompaniesByCategory(controller.selectedCategoryId);
    await _generateCustomMarkers();

    final gMap = await _mapController.future;

    if (controller.userPosition != null) {
      final userLatLng = LatLng(controller.userPosition!.latitude, controller.userPosition!.longitude);
      gMap.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: userLatLng, zoom: 12)));
    } else if (_customMarkers.isNotEmpty) {
      final first = _customMarkers.first.position;
      gMap.animateCamera(CameraUpdate.newLatLngZoom(first, 13));
    }
  }

  Future<void> _generateCustomMarkers() async {
    _customMarkers.clear();
    final usedPositions = <String>{};

    for (int i = 0; i < controller.companies.length; i++) {
      final company = controller.companies[i];
      if (company.latitude == null || company.longitude == null) continue;

      double lat = company.latitude!;
      double lng = company.longitude!;
      String posKey = "$lat-$lng";

      int retry = 0;
      while (usedPositions.contains(posKey)) {
        double offset = 0.00008 * (retry + 1);
        double angle = (retry % 8) * (45 * 3.1416 / 180);
        lat = company.latitude! + offset * Math.sin(angle);
        lng = company.longitude! + offset * Math.cos(angle);
        posKey = "$lat-$lng";
        retry++;
      }

      usedPositions.add(posKey);

      final distanceText =
          company.distanceKm != null ? (company.distanceKm! < 1 ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m" : "${company.distanceKm!.toStringAsFixed(1)} km") : "--";

      final bytes = await _createCustomMarkerBitmap(context, company.companyName, distanceText);

      _customMarkers.add(
        Marker(
          markerId: MarkerId("${company.companyName}-$i"),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.bytes(bytes),
          onTap: () => controller.fetchCompanyById(company.id!),
        ),
      );
    }

    setState(() {});
  }

  Future<Uint8List> _createCustomMarkerBitmap(BuildContext context, String title, String distance) async {
    final key = GlobalKey();
    final markerWidget = Material(type: MaterialType.transparency, child: RepaintBoundary(key: key, child: _buildCustomMarker(title, distance)));

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(builder: (_) => Center(child: markerWidget));
    overlay.insert(entry);
    await Future.delayed(const Duration(milliseconds: 100));

    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.5);
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
        const SizedBox(height: 2),
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
            onMapCreated: (controller) => _mapController.complete(controller),
            markers: _customMarkers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (_) => controller.clearSelectedCompany(),
          ),

          GetBuilder<CompanyController>(
            builder: (_) {
              final showOverlay = controller.selectedCompany != null;
              return IgnorePointer(
                ignoring: true,
                child: AnimatedOpacity(opacity: showOverlay ? 0.2 : 0.0, duration: const Duration(milliseconds: 300), child: Container(color: Colors.indigo)),
              );
            },
          ),

          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: GetBuilder<CategoryController>(
              builder: (_) {
                if (categoryController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton<int>(
                    value: controller.selectedCategoryId,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items: categoryController.categories.map((category) => DropdownMenuItem<int>(value: category.id, child: Center(child: Text(category.title)))).toList(),
                    onChanged: (int? newId) {
                      if (newId != null) {
                        controller.setCategoryId(newId);
                        controller.clearSelectedCompany();
                        _loadData(); // ✅ Reload for new category
                      }
                    },
                  ),
                );
              },
            ),
          ),

          GetBuilder<CompanyController>(
            builder: (_) {
              final company = controller.selectedCompany;
              if (company == null) return const SizedBox();

              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () async {
                    await controller.fetchCompanyById(company.id!);
                    Get.to(() => const VendorDescription());
                  },
                  child: VendorInfoCard(
                    logoImage: company.logo ?? '',
                    companyName: company.companyName,
                    category: company.categoryName ?? '',
                    description: company.description ?? '',
                    rating: company.rating?.toStringAsFixed(1) ?? '3.9',
                    estimatedTime: company.estimatedTime,
                    distanceKm:
                        company.distanceKm != null
                            ? (company.distanceKm! < 1 ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m" : "${company.distanceKm!.toStringAsFixed(1)} km")
                            : null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
