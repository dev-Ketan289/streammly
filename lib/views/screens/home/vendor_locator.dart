import 'dart:async';
import 'dart:developer';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/home/company_list_screen.dart';
import 'package:streammly/views/screens/home/filter_company_list_screen.dart';
import 'package:streammly/views/screens/home/widgets/custom_location_appbar.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/company_controller.dart';
import '../vendor/vendor_description.dart';
import '../vendor/widgets/vendor_info_card.dart';

class CompanyLocatorMapScreen extends StatefulWidget {
  final int categoryId;
  final List<int>? allowedCategoryIds;

  const CompanyLocatorMapScreen({
    super.key,
    required this.categoryId,
    this.allowedCategoryIds,
  });

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

  // Cache for marker bitmaps - KEY OPTIMIZATION
  // static final Map<String, Uint8List> _markerCache = {};
  static final Map<String, Uint8List> _fallbackMarkerCache = {};

  // Track which markers have network images loading
  final Set<int> _loadingNetworkImages = {};

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

    // STAGE 1: Show markers instantly with fallback icons
    await _generateInstantMarkers();

    final gMap = await _mapController.future;

    // In _loadData method - replace the camera animation part
    if (controller.userPosition != null) {
      final userLatLng = LatLng(
        controller.userPosition!.latitude,
        controller.userPosition!.longitude,
      );
      gMap.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: userLatLng, zoom: 14), // BETTER initial zoom
        ),
      );
    } else if (_customMarkers.isNotEmpty) {
      final first = _customMarkers.first.position;
      gMap.animateCamera(
        CameraUpdate.newLatLngZoom(first, 14),
      ); // BETTER initial zoom
    }

    // Show slider if there are companies
    if (controller.companies.isNotEmpty) {
      setState(() {
        _showSlider = true;
        _currentPageIndex = 0;
      });

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    } else {
      setState(() {
        _showSlider = false;
      });
    }

    // STAGE 2: Load network images in background
    _loadNetworkImagesInBackground();
  }

  // STAGE 1: Generate markers instantly with fallback icons
  Future<void> _generateInstantMarkers() async {
    _customMarkers.clear();
    final usedPositions = <String>{};

    const batchSize = 15; // Larger batches for faster processing
    final batches = <List<int>>[];

    for (int i = 0; i < controller.companies.length; i += batchSize) {
      final end = Math.min(i + batchSize, controller.companies.length);
      batches.add(List.generate(end - i, (index) => i + index));
    }

    // Process all batches in parallel for maximum speed
    await Future.wait(
      batches.map((batch) => _processFallbackBatch(batch, usedPositions)),
    );

    setState(() {}); // Show all markers instantly
  }

  // Process batch with fallback markers only
  Future<void> _processFallbackBatch(
    List<int> indices,
    Set<String> usedPositions,
  ) async {
    final futures = indices.map(
      (i) => _createInstantFallbackMarker(i, usedPositions),
    );
    final markers = await Future.wait(futures);

    _customMarkers.addAll(
      markers.where((marker) => marker != null).cast<Marker>(),
    );
  }

  // Create instant fallback marker
  Future<Marker?> _createInstantFallbackMarker(
    int i,
    Set<String> usedPositions,
  ) async {
    final company = controller.companies[i];

    if (company.latitude == null || company.longitude == null) return null;

    final adjustedPos = _getAdjustedPosition(
      company.latitude!,
      company.longitude!,
      usedPositions,
    );

    final distanceText =
        company.distanceKm != null
            ? (company.distanceKm! < 1
                ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m"
                : "${company.distanceKm!.toStringAsFixed(1)} km")
            : "--";

    // Use cached fallback or create new one
    final bytes = await _getCachedFallbackMarker(distanceText);

    return Marker(
      markerId: MarkerId("${company.companyName}-$i"),
      position: LatLng(adjustedPos['lat']!, adjustedPos['lng']!),
      icon: BitmapDescriptor.bytes(bytes),
      onTap: () => _onMarkerTapped(i),
    );
  }

  // Get cached fallback marker (super fast)
  Future<Uint8List> _getCachedFallbackMarker(String distance) async {
    final cacheKey = "fallback-$distance";

    if (_fallbackMarkerCache.containsKey(cacheKey)) {
      return _fallbackMarkerCache[cacheKey]!;
    }

    final bytes = await _createFallbackMarkerBitmap(distance);
    _fallbackMarkerCache[cacheKey] = bytes;
    return bytes;
  }

  // Create optimized fallback marker with distance badge
  // Create optimized fallback marker with distance badge
  Future<Uint8List> _createFallbackMarkerBitmap(String distance) async {
    const size = Size(120, 120); // INCREASED SIZE for better quality
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw distance badge - larger
    final badgePaint = Paint()..color = Colors.blueAccent;
    final badgeRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(30, 8, 60, 24), // LARGER badge
      const Radius.circular(12),
    );
    canvas.drawRRect(badgeRect, badgePaint);

    // Draw distance text - larger
    final textPainter = TextPainter(
      text: TextSpan(
        text: distance,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14, // INCREASED font size
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(38, 14)); // Adjusted position

    // Draw main circle with shadow - larger
    final shadowPaint =
        Paint()
          ..color = Colors.black26
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(const Offset(60, 70), 28, shadowPaint); // LARGER circle

    final circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(60, 70), 25, circlePaint); // LARGER circle

    // Draw border
    final borderPaint =
        Paint()
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2; // Thicker border
    canvas.drawCircle(const Offset(60, 70), 25, borderPaint);

    // Draw business icon - larger
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(Icons.business.codePoint),
        style: TextStyle(
          fontFamily: Icons.business.fontFamily,
          fontSize: 28, // INCREASED icon size
          color: Colors.grey.shade600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(canvas, const Offset(46, 56)); // Adjusted position

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (size.width * 2).toInt(), // DOUBLE pixel density for sharp rendering
      (size.height * 2).toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  // Create marker with network image - enhanced quality
  Future<Uint8List> _createNetworkMarkerBitmap(
    String title,
    String distance,
    String logoUrl,
  ) async {
    const size = Size(120, 120); // INCREASED SIZE
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw distance badge - larger
    final badgePaint = Paint()..color = Colors.blueAccent;
    final badgeRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(30, 8, 60, 24), // LARGER badge
      const Radius.circular(12),
    );
    canvas.drawRRect(badgeRect, badgePaint);

    // Draw distance text - larger
    final textPainter = TextPainter(
      text: TextSpan(
        text: distance,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14, // INCREASED font size
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(38, 14)); // Adjusted position

    // Draw main circle with shadow - larger
    final shadowPaint =
        Paint()
          ..color = Colors.black26
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(const Offset(60, 70), 28, shadowPaint); // LARGER circle

    final circlePaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(60, 70), 25, circlePaint); // LARGER circle

    // Draw border
    final borderPaint =
        Paint()
          ..color = Colors.grey.shade300
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(const Offset(60, 70), 25, borderPaint);

    // Load and draw network image - larger area
    try {
      final networkImage = NetworkImage(logoUrl);
      final imageStream = networkImage.resolve(const ImageConfiguration());
      final completer = Completer<ui.Image>();

      imageStream.addListener(
        ImageStreamListener((ImageInfo info, bool _) {
          if (!completer.isCompleted) {
            completer.complete(info.image);
          }
        }),
      );

      final loadedImage = await completer.future;

      // Draw the loaded image in circle - larger destination
      final srcRect = Rect.fromLTWH(
        0,
        0,
        loadedImage.width.toDouble(),
        loadedImage.height.toDouble(),
      );
      final destRect = const Rect.fromLTWH(37, 47, 46, 46); // LARGER image area

      canvas.save();
      canvas.clipPath(Path()..addOval(destRect));
      canvas.drawImageRect(loadedImage, srcRect, destRect, Paint());
      canvas.restore();
    } catch (e) {
      // Fallback to business icon if image fails - larger
      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.business.codePoint),
          style: TextStyle(
            fontFamily: Icons.business.fontFamily,
            fontSize: 28, // INCREASED icon size
            color: Colors.grey.shade600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(canvas, const Offset(46, 56)); // Adjusted position
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (size.width * 2).toInt(), // DOUBLE pixel density for sharp rendering
      (size.height * 2).toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  // STAGE 2: Load network images in background
  void _loadNetworkImagesInBackground() {
    // Small delay to ensure markers are rendered first
    Timer(const Duration(milliseconds: 100), () async {
      const batchSize = 5; // Smaller batches for network loading

      for (int i = 0; i < controller.companies.length; i += batchSize) {
        final end = Math.min(i + batchSize, controller.companies.length);
        final batch = List.generate(end - i, (index) => i + index);

        // Process batch
        await _loadNetworkImageBatch(batch);

        // Small delay between batches to prevent overwhelming the network
        await Future.delayed(const Duration(milliseconds: 50));
      }
    });
  }

  // Load network images for a batch
  Future<void> _loadNetworkImageBatch(List<int> indices) async {
    final futures = indices.map(_loadSingleNetworkImage);
    await Future.wait(futures);
  }

  // Load single network image and update marker
  Future<void> _loadSingleNetworkImage(int index) async {
    final company = controller.companies[index];
    final logoUrl = company.company?.logo;

    // Skip if no logo URL or already loading
    if (logoUrl == null ||
        logoUrl.isEmpty ||
        _loadingNetworkImages.contains(index)) {
      return;
    }

    _loadingNetworkImages.add(index);

    try {
      final distanceText =
          company.distanceKm != null
              ? (company.distanceKm! < 1
                  ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m"
                  : "${company.distanceKm!.toStringAsFixed(1)} km")
              : "--";

      final bytes = await _createNetworkMarkerBitmap(
        company.companyName,
        distanceText,
        logoUrl,
      ).timeout(const Duration(seconds: 2)); // Reasonable timeout

      // Update the marker with network image
      await _updateMarkerWithNetworkImage(index, bytes);
    } catch (e) {
      // Keep fallback marker if network loading fails
      log('Failed to load network image for ${company.companyName}: $e');
    } finally {
      _loadingNetworkImages.remove(index);
    }
  }

  // Update specific marker with network image
  Future<void> _updateMarkerWithNetworkImage(int index, Uint8List bytes) async {
    final company = controller.companies[index];
    final markerId = MarkerId("${company.companyName}-$index");

    // Find existing marker
    final existingMarker = _customMarkers.cast<Marker?>().firstWhere(
      (marker) => marker?.markerId == markerId,
      orElse: () => null,
    );

    if (existingMarker != null) {
      // Remove old marker and add updated one
      _customMarkers.remove(existingMarker);
      _customMarkers.add(
        existingMarker.copyWith(iconParam: BitmapDescriptor.bytes(bytes)),
      );

      // Update UI - but only if mounted
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Position adjustment logic (unchanged)
  Map<String, double> _getAdjustedPosition(
    double lat,
    double lng,
    Set<String> usedPositions,
  ) {
    String posKey = "$lat-$lng";
    double adjustedLat = lat;
    double adjustedLng = lng;

    int retry = 0;
    while (usedPositions.contains(posKey) && retry < 8) {
      double offset = 0.00008 * (retry + 1);
      double angle = (retry % 8) * (45 * 3.1416 / 180);
      adjustedLat = lat + offset * Math.sin(angle);
      adjustedLng = lng + offset * Math.cos(angle);
      posKey = "$adjustedLat-$adjustedLng";
      retry++;
    }

    usedPositions.add(posKey);
    return {'lat': adjustedLat, 'lng': adjustedLng};
  }

  // Your existing methods remain unchanged
  void _onMarkerTapped(int index) {
    if (index < controller.companies.length) {
      final company = controller.companies[index];
      controller.fetchCompanyById(company.id);

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
      controller.fetchCompanyById(company.companyId);

      // Find the marker corresponding to this company
      final marker = _customMarkers.firstWhere(
        (m) => m.markerId.value.startsWith("${company.companyName}-$pageIndex"),
        orElse:
            () => Marker(
              markerId: MarkerId("${company.companyName}-$pageIndex"),
              position: LatLng(company.latitude ?? 0, company.longitude ?? 0),
            ),
      );

      // Animate map to the marker's position
      if (marker.position.latitude != 0 && marker.position.longitude != 0) {
        _mapController.future.then((mapController) {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              marker.position, // Use the marker's adjusted position
              19, // Adjusted zoom level for better visibility
            ),
          );
        });
      }
    }
  }

  bool isSearchSelected = false;
  bool isFilterSelected = false;
  bool isVendorSelected = false;

  String get subtitle {
    if (isVendorSelected) return ' vendors';
    if (isFilterSelected) return ' filter';
    if (isSearchSelected) return ' search';
    return ' services';
  }

  void toggleSelection(String type) {
    setState(() {
      isSearchSelected = type == 'search' ? !isSearchSelected : false;
      isFilterSelected = type == 'filter' ? !isFilterSelected : false;
      isVendorSelected = type == 'vendor' ? !isVendorSelected : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomLocAppBar(
        onVendorTap: () => toggleSelection('vendor'),
        onFilterTap: () => toggleSelection('filter'),
        onSearchTap: () => toggleSelection('search'),
        isSearchSelected: isSearchSelected,
        isFilterSelected: isFilterSelected,
        isVendorSelected: isVendorSelected,
        subtitle: subtitle,
        companyCount: controller.companies.length,
      ),
      body: Builder(
        builder: (context) {
          if (isVendorSelected) {
            log(widget.categoryId.toString(), name: "Category ID");
            return CompanyListScreen(categoryId: widget.categoryId);
          } else if (isFilterSelected) {
            return FilterCompanyListScreen(
              onTap: () {
                setState(() {
                  isFilterSelected = false;
                });
                _loadData();
              },
            );
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(19.2189, 72.9805),
                  zoom: 12,
                ),
                onMapCreated:
                    (controller) => _mapController.complete(controller),
                markers: _customMarkers,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
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
                      child: Container(color: primaryColor),
                    ),
                  );
                },
              ),

              // Company Slider (unchanged)
              if (_showSlider)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenHeight = MediaQuery.of(context).size.height;
                      final sliderHeight = screenHeight * 0.28;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: sliderHeight.clamp(180.0, 320.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
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
                                      final company =
                                          controller.companies[index];
                                      return Container(
                                        child: GestureDetector(
                                          onTap: () async {
                                            await controller.fetchCompanyById(
                                              company.companyId,
                                            );
                                            final mainState =
                                                context
                                                    .findAncestorStateOfType<
                                                      NavigationFlowState
                                                    >();
                                            mainState?.pushToCurrentTab(
                                              VendorDescription(
                                                company: company,
                                                companyId: company.companyId,
                                              ),
                                              hideBottomBar: true,
                                            );
                                          },
                                          child: VendorInfoCard(
                                            logoImage:
                                                company.company?.logo ?? '',
                                            companyName:
                                                company.company?.companyName ??
                                                '',
                                            category:
                                                categoryController.categories
                                                    .firstWhere(
                                                      (cat) =>
                                                          cat.id ==
                                                          controller
                                                              .selectedCategoryId,
                                                    )
                                                    .title,
                                            description:
                                                company.company?.description ??
                                                '',
                                            rating:
                                                company.company?.rating != null
                                                    ? company.company!.rating!
                                                        .toStringAsFixed(1)
                                                    : company.rating != null
                                                    ? company.rating!
                                                        .toStringAsFixed(1)
                                                    : '3.9',
                                            estimatedTime:
                                                company.estimatedTime,
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
          );
        },
      ),
    );
  }
}
