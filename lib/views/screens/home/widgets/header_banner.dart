import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/common/enter_location_manually.dart';
import 'package:streammly/views/screens/profile/drawer.dart';

import '../../../../controllers/location_controller.dart';
import '../../../../models/banner/banner_item.dart';
import '../../../../models/company/specialized_in.dart';

class HeaderBanner extends StatefulWidget {
  final List<BannerSlideItem>? slides;
  final double height;
  final String backgroundImage;
  final Color overlayColor;
  final String? overrideTitle;
  final String? overrideSubtitle;
  final bool showContent;
  final List<SpecializedItem>? specialized;

  const HeaderBanner({
    super.key,
    this.slides,
    required this.height,
    required this.backgroundImage,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.3),
    this.overrideTitle,
    this.overrideSubtitle,
    this.showContent = true,
    this.specialized,
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
    // If you really want to debug, add print here:
    // print("HeaderBanner build, specialized: ${widget.specialized?.map((e) => e.title).toList()}");

    final theme = Theme.of(context);
    final hasSlides = loopedSlides.isNotEmpty;
    final currentSlide = hasSlides ? loopedSlides[currentIndex] : null;
    final title = widget.overrideTitle ?? currentSlide?.title ?? '';
    final subtitle = widget.overrideSubtitle ?? currentSlide?.description ?? '';

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Stack(
        children: [
          // Background
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

          // Overlay
          Container(color: widget.overlayColor),

          // Carousel
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

          // Vector image
          if (currentSlide?.vectorImage != null)
            Positioned(
              right: 20,
              bottom: 10,
              child: Builder(
                builder: (context) {
                  final double vectorImageHeight = MediaQuery.of(context).size.height * 0.25;
                  return currentSlide!.isSvg
                      ? SvgPicture.network(currentSlide.vectorImage, height: vectorImageHeight)
                      : Image.network(currentSlide.vectorImage, height: vectorImageHeight);
                },
              ),
            ),

          // Content
          if (widget.showContent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Row
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => EnterLocationManuallyScreen()));
                      },
                      child: Row(
                        children: [
                          const SizedBox(width: 50),
                          Icon(Icons.location_on, color: theme.colorScheme.onPrimary, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Current Location", style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
                                Text(
                                  locationController.selectedAddress.value.isNotEmpty ? locationController.selectedAddress.value : "Fetching...",
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary, fontSize: 8),
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Search Bar
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(Assets.svgMenu),
                        onPressed: () {
                          Get.to(() => const ProfilePage(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 2000),);
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          height: 37,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: theme.colorScheme.onPrimary, width: 1),
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: GoogleFonts.openSans(color: theme.colorScheme.onPrimary, fontSize: 12),
                              prefixIcon: Icon(Icons.search, color: backgroundLight, size: 24),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(radius: 16, backgroundColor: theme.colorScheme.surface, child: SvgPicture.asset(Assets.svgDiamondhome)),
                    ],
                  ),

                  // Scrollable Content
                  const SizedBox(height: 5),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Subtitle
                          if (title.isNotEmpty || subtitle.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (title.isNotEmpty)
                                    Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 29, fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimary)),
                                  if (subtitle.isNotEmpty) const SizedBox(height: 6),
                                  if (subtitle.isNotEmpty)
                                    SizedBox(
                                      height: 35,
                                      width: 168,
                                      child: Text(
                                        subtitle,
                                        style: GoogleFonts.dmSerifDisplay(color: theme.colorScheme.onPrimary, fontSize: 12),
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                ],
                              ),
                            ),

                          // Specialities Section
                          // Specialized In Section
                          if (widget.specialized != null && widget.specialized!.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                "Specialized in",
                                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (int i = 0; i < (widget.specialized!.length > 2 ? 2 : widget.specialized!.length); i++)
                                    Chip(
                                      backgroundColor: theme.colorScheme.surface,
                                      side: BorderSide(color: theme.colorScheme.surface.withAlpha(100)),
                                      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                      label: Text(widget.specialized![i].title, style: theme.textTheme.bodySmall?.copyWith(color: Colors.indigo, fontSize: 12)),
                                    ),
                                  if (widget.specialized!.length > 2)
                                    Chip(
                                      backgroundColor: theme.colorScheme.surface,
                                      side: BorderSide(color: theme.colorScheme.surface.withAlpha(100)),
                                      label: Text("+${widget.specialized!.length - 2} more", style: theme.textTheme.bodySmall?.copyWith(color: Colors.indigo, fontSize: 12)),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
