import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../models/banner/banner_item.dart';

class HeaderBanner extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;
  final bool showSearchBar;
  final Color color;
  final double overlayOpacity;

  const HeaderBanner({super.key, required this.banners, required this.height, this.showSearchBar = true, required this.color, required this.overlayOpacity});

  @override
  State<HeaderBanner> createState() => _HeaderBannerState();
}

class _HeaderBannerState extends State<HeaderBanner> {
  final LocationController locationController = Get.find();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentBanner = widget.banners[currentIndex];

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: Stack(
        children: [
          /// ---------- Background Image with Overlay ----------
          PageView.builder(
            itemCount: widget.banners.length,
            onPageChanged: (index) => setState(() => currentIndex = index),
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage(banner.image), fit: BoxFit.cover)),
                child: Container(color: widget.color.withValues(alpha: widget.overlayOpacity)),
              );
            },
          ),

          /// ---------- Vector image ----------
          if (currentBanner.vectorImage != null) Positioned(right: 16, bottom: 20, child: Image.asset(currentBanner.vectorImage!, height: 140)),

          /// ---------- Top Content ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Location Row with Obx
                Obx(
                  () => Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 25),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Current Location", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                            Text(
                              locationController.selectedAddress.value.isNotEmpty ? locationController.selectedAddress.value : "Fetching address...",
                              style: const TextStyle(color: Colors.white, fontSize: 10),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Search Bar
                Row(
                  children: [
                    const Icon(Icons.menu, color: Colors.white),
                    const SizedBox(width: 8),
                    if (widget.showSearchBar)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "What are you looking for",
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ),
                    if (widget.showSearchBar) const SizedBox(width: 8),
                    const CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.diamond_outlined, color: Colors.amber)),
                  ],
                ),

                const SizedBox(height: 24),

                /// Banner Title & Subtitle
                Text(currentBanner.title, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(currentBanner.subtitle, style: const TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
