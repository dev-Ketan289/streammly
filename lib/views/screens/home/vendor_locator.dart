import 'dart:async';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streammly/services/route_helper.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/company_controller.dart';
import '../vendor/vendor_description.dart';
import '../vendor/widgets/vendor_info_card.dart';

class CompanyLocatorMapScreen extends StatefulWidget {
  final int categoryId;

  const CompanyLocatorMapScreen({super.key, required this.categoryId});

  @override
  State<CompanyLocatorMapScreen> createState() =>
      _CompanyLocatorMapScreenState();
}

class _CompanyLocatorMapScreenState extends State<CompanyLocatorMapScreen> {
  final CompanyController controller = Get.find<CompanyController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  final Set<Marker> _customMarkers = {};
  final Completer<GoogleMapController> _mapController = Completer();

  // Slider state variables
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  bool _showSlider = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setCategoryId(widget.categoryId);
      _loadData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      final userLatLng = LatLng(
        controller.userPosition!.latitude,
        controller.userPosition!.longitude,
      );
      gMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLatLng, zoom: 12),
        ),
      );
    } else if (_customMarkers.isNotEmpty) {
      final first = _customMarkers.first.position;
      gMap.animateCamera(CameraUpdate.newLatLngZoom(first, 13));
    }

    // Show slider if there are companies
    if (controller.companies.isNotEmpty) {
      setState(() {
        _showSlider = true;
        _currentPageIndex = 0;
      });

      // Reset page controller to first page
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    } else {
      setState(() {
        _showSlider = false;
      });
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
          company.distanceKm != null
              ? (company.distanceKm! < 1
                  ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m"
                  : "${company.distanceKm!.toStringAsFixed(1)} km")
              : "--";

      final bytes = await _createCustomMarkerBitmap(
        context,
        company.companyName,
        distanceText,
        company.logo,
      );

      _customMarkers.add(
        Marker(
          markerId: MarkerId("${company.companyName}-$i"),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.bytes(bytes),
          onTap: () => _onMarkerTapped(i),
        ),
      );
    }

    setState(() {});
  }

  void _onMarkerTapped(int index) {
    if (index < controller.companies.length) {
      final company = controller.companies[index];
      controller.fetchCompanyById(company.id!);

      // Animate to the corresponding page in the slider
      if (_showSlider && _pageController.hasClients) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      _currentPageIndex = pageIndex;
    });

    // Select the company and animate map to marker
    if (pageIndex < controller.companies.length) {
      final company = controller.companies[pageIndex];
      controller.fetchCompanyById(company.id!);

      // Animate map to the selected marker
      if (company.latitude != null && company.longitude != null) {
        _mapController.future.then((mapController) {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(company.latitude!, company.longitude!),
              15,
            ),
          );
        });
      }
    }
  }

  Future<Uint8List> _createCustomMarkerBitmap(
    BuildContext context,
    String title,
    String distance,
    String? logoUrl,
  ) async {
    final key = GlobalKey();
    final completer = Completer<void>();

    final markerWidget = Material(
      type: MaterialType.transparency,
      child: RepaintBoundary(
        key: key,
        child: _buildCustomMarker(title, distance, logoUrl, completer),
      ),
    );

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(builder: (_) => Center(child: markerWidget));
    overlay.insert(entry);

    // Wait for the widget to be properly rendered
    await Future.delayed(const Duration(milliseconds: 50));

    // Wait for image loading if there's a logo URL
    if (logoUrl != null && logoUrl.isNotEmpty) {
      await completer.future.timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
      );
    } else {
      // Ensure completer is completed for cases without logo
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    // Additional delay to ensure rendering is complete
    await Future.delayed(const Duration(milliseconds: 100));

    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.5);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    entry.remove();
    return pngBytes;
  }

  Widget _buildCustomMarker(
    String title,
    String distance,
    String? logoUrl,
    Completer<void> completer,
  ) {
    // Complete the completer immediately if no logo URL
    if (logoUrl == null || logoUrl.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            distance,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child:
                logoUrl != null && logoUrl.isNotEmpty
                    ? Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      frameBuilder: (
                        context,
                        child,
                        frame,
                        wasSynchronouslyLoaded,
                      ) {
                        if (frame != null && !completer.isCompleted) {
                          completer.complete();
                        }
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        if (!completer.isCompleted) {
                          completer.complete();
                        }
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.business,
                            color: Colors.grey[600],
                            size: 24,
                          ),
                        );
                      },
                    )
                    : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.business,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
          ),
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
            initialCameraPosition: const CameraPosition(
              target: LatLng(19.2189, 72.9805),
              zoom: 12,
            ),
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
                child: AnimatedOpacity(
                  opacity: showOverlay ? 0.2 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(color: Colors.indigo),
                ),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<int>(
                    value: controller.selectedCategoryId,
                    isExpanded: true,
                    underline: const SizedBox(),
                    items:
                        categoryController.categories
                            .map(
                              (category) => DropdownMenuItem<int>(
                                value: category.id,
                                child: Center(child: Text(category.title)),
                              ),
                            )
                            .toList(),
                    onChanged: (int? newId) {
                      if (newId != null) {
                        controller.setCategoryId(newId);
                        controller.clearSelectedCompany();
                        setState(() {
                          _showSlider = false;
                          _currentPageIndex = 0;
                        });
                        _loadData(); // ✅ Reload for new category
                      }
                    },
                  ),
                );
              },
            ),
          ),

          // Company Slider
          if (_showSlider)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final sliderHeight =
                      screenHeight * 0.28; // 28% of screen height, responsive
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: sliderHeight.clamp(
                      180.0,
                      320.0,
                    ), // min 180, max 320
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Page indicator
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.companies.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: _currentPageIndex == index ? 12 : 8,
                                height: _currentPageIndex == index ? 12 : 8,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _currentPageIndex == index
                                          ? Colors.blue
                                          : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Company cards slider
                        Expanded(
                          child: GetBuilder<CompanyController>(
                            builder: (_) {
                              if (controller.companies.isEmpty) {
                                return const SizedBox();
                              }

                              return PageView.builder(
                                controller: _pageController,
                                onPageChanged: _onPageChanged,
                                itemCount: controller.companies.length,
                                itemBuilder: (context, index) {
                                  final company = controller.companies[index];
                                  return Container(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await controller.fetchCompanyById(
                                          company.id!,
                                        );
                                        Get.to(() => const VendorDescription());
                                      },
                                      child: VendorInfoCard(
                                        logoImage: company.logo ?? '',
                                        companyName: company.companyName,
                                        category:
                                            categoryController.categories
                                                .firstWhere(
                                                  (cat) =>
                                                      cat.id ==
                                                      controller
                                                          .selectedCategoryId,
                                                )
                                                .title,
                                        description: company.description ?? '',
                                        rating:
                                            company.rating?.toStringAsFixed(
                                              1,
                                            ) ??
                                            '3.9',
                                        estimatedTime: company.estimatedTime,
                                        distanceKm:
                                            company.distanceKm != null
                                                ? (company.distanceKm! < 1
                                                    ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m"
                                                    : "${company.distanceKm!.toStringAsFixed(1)} km")
                                                : null,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
