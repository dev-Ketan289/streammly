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
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
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
          // --- Background image ---
          widget.backgroundImage.startsWith("http")
              ? Image.network(
                widget.backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/recommended_banner/FocusPointVendor.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                },
              )
              : Image.asset(
                widget.backgroundImage,
                fit: BoxFit.fill,
                width: double.infinity,
                height: double.infinity,
              ),

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
              right: 20,
              bottom: 10,
              child: Builder(
                builder: (context) {
                  final double vectorImageHeight = MediaQuery.of(context).size.height * 0.25;
                  return currentSlide!.isSvg
                      ? SvgPicture.network(
                          "https://admin.streammly.com/${currentSlide.vectorImage}",
                          height: vectorImageHeight,
                        )
                      : Image.network(
                          "https://admin.streammly.com/${currentSlide.vectorImage}",
                          height: vectorImageHeight,
                        );
                },
              ),
            ),

          // --- Top Content (location, search, title, subtitle, specialities) ---
          if (widget.showContent)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EnterLocationManuallyScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SizedBox(width: 50,),
                          Icon(
                            Icons.location_on,
                            color: theme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Current Location",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  locationController
                                          .selectedAddress
                                          .value
                                          .isNotEmpty
                                      ? locationController.selectedAddress.value
                                      : "Fetching...",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 8,
                                  ),
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
                          Get.to(
                            () => const ProfilePage(),
                            transition: Transition.leftToRight,
                            duration: const Duration(milliseconds: 800),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          height: 37,
                          width: 302,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: theme.colorScheme.onPrimary,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: Colors.white,
                            ), // Set typed text to white
                            decoration: InputDecoration(
                              hintText: "Searching...",
                              hintStyle: GoogleFonts.openSans(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 12,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: backgroundLight,
                                size: 24,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.surface,
                        child: SvgPicture.asset(Assets.svgDiamondhome),
                      ),
                    ],
                  ),

                  // Title & Subtitle
                  if (title.isNotEmpty || subtitle.isNotEmpty)
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 40,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: GoogleFonts.openSans(
                                fontSize: 29,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                          if (subtitle.isNotEmpty) const SizedBox(height: 6),
                          if (subtitle.isNotEmpty)
                            Container(
                              height: 90,
                              width:168,
                              child: Text(
                                subtitle,
                                style: GoogleFonts.openSans(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.visible,

                                textAlign: TextAlign.left,
                              ),
                            ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // Specialized In + Specialities Section
                  if (widget.specialities != null &&
                      widget.specialities!.isNotEmpty) ...[
                    Text(
                      "Specialized in",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (
                          var i = 0;
                          i <
                              (widget.specialities!.length > 2
                                  ? 2
                                  : widget.specialities!.length);
                          i++
                        )
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.surface.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Text(
                              widget.specialities![i],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (widget.specialities!.length > 2)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.surface.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Text(
                              "+${widget.specialities!.length - 2} more",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
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
