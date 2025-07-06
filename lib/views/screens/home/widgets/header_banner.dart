import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/views/screens/profile/drawer.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../models/banner/banner_item.dart';

class HeaderBanner extends StatefulWidget {
  final List<BannerSlideItem>? slides;
  final double height;
  final String backgroundImage;
  final Color overlayColor;
  final String? overrideTitle;
  final String? overrideSubtitle;
  final bool showContent;

  /// Specialities
  final List<String>? specialities;

  const HeaderBanner({
    super.key,
    this.slides,
    required this.height,
    required this.backgroundImage,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.3),
    this.overrideTitle,
    this.overrideSubtitle,
    this.showContent = true,
    this.specialities,
  });

  @override
  State<HeaderBanner> createState() => _HeaderBannerState();
}

class _HeaderBannerState extends State<HeaderBanner> {
  late PageController pageController;
  final LocationController locationController = Get.find();
  int currentIndex = 1;
  Timer? autoScrollTimer;

  List<BannerSlideItem> get loopedSlides {
    if (widget.slides == null || widget.slides!.isEmpty) return [];
    final realSlides = widget.slides!;
    return [realSlides.last, ...realSlides, realSlides.first];
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1);

    if (loopedSlides.isNotEmpty) {
      autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (pageController.hasClients) {
          pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
        }
      });
    }
  }

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSlides = loopedSlides.isNotEmpty;
    final currentSlide = hasSlides ? loopedSlides[currentIndex] : null;
    final title = widget.overrideTitle ?? currentSlide?.title ?? '';
    final subtitle = widget.overrideSubtitle ?? currentSlide?.description ?? '';

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // --- Background image ---
          widget.backgroundImage.startsWith("http")
              ? Image.network(
                widget.backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/recommended_banner/FocusPointVendor.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity);
                },
              )
              : Image.asset(widget.backgroundImage, fit: BoxFit.cover, width: double.infinity, height: double.infinity),

          // --- Overlay ---
          Container(color: widget.overlayColor),

          // --- Carousel effect ---
          if (hasSlides)
            PageView.builder(
              controller: pageController,
              itemCount: loopedSlides.length,
              onPageChanged: (index) {
                final total = loopedSlides.length;
                if (index == total - 1) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    pageController.jumpToPage(1);
                  });
                  setState(() => currentIndex = 1);
                } else if (index == 0) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    pageController.jumpToPage(total - 2);
                  });
                  setState(() => currentIndex = total - 2);
                } else {
                  setState(() => currentIndex = index);
                }
              },
              itemBuilder: (_, index) {
                return const SizedBox.expand();
              },
            ),

          // --- Vector image ---
          if (currentSlide?.vectorImage != null)
            Positioned(
              right: 16,
              bottom: 20,
              child:
                  currentSlide!.isSvg
                      ? SvgPicture.network("http://192.168.1.113:8000/${currentSlide.vectorImage}", height: 140)
                      : Image.network("http://192.168.1.113:8000/${currentSlide.vectorImage}", height: 140),
            ),

          // --- Top Content (location, search, title, subtitle, specialities) ---
          if (widget.showContent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Current Location", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(
                                locationController.selectedAddress.value.isNotEmpty ? locationController.selectedAddress.value : "Fetching...",
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Get.to(() => const ProfilePage(), transition: Transition.leftToRight, duration: const Duration(milliseconds: 800));
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "What are you looking for?",
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(radius: 16, backgroundColor: Colors.white, child: Icon(Icons.diamond_outlined, color: Colors.amber)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Title & Subtitle
                  if (title.isNotEmpty) Text(title, style: GoogleFonts.openSans(fontSize: 29, fontWeight: FontWeight.w700, color: Colors.white)),
                  if (subtitle.isNotEmpty) const SizedBox(height: 6),
                  if (subtitle.isNotEmpty) Text(subtitle, style: GoogleFonts.openSans(color: Colors.white, fontSize: 16), maxLines: 4, overflow: TextOverflow.clip),

                  const SizedBox(height: 12),

                  // Specialized In + Specialities Section
                  if (widget.specialities != null && widget.specialities!.isNotEmpty) ...[
                    const Text("Specialized in", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children:
                          widget.specialities!
                              .map(
                                (speciality) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(speciality, style: const TextStyle(color: Colors.indigo, fontSize: 12)),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
