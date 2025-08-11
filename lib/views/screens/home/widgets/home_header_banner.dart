import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/views/screens/common/enter_location_manually.dart';
import 'package:streammly/views/screens/home/widgets/category/search_screen.dart';
import 'package:streammly/views/screens/profile/drawer.dart';

import '../../../../controllers/location_controller.dart';
// Import your own assets and controllers as needed

import '../../../../models/banner/banner_item.dart';

class HomeHeaderBanner extends StatefulWidget {
  final List<BannerSlideItem>? slides;
  const HomeHeaderBanner({super.key, this.slides});

  @override
  State<HomeHeaderBanner> createState() => _HomeHeaderBannerState();
}

class _HomeHeaderBannerState extends State<HomeHeaderBanner> {
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
        if (!mounted) return;
        try {
          if (pageController.hasClients) {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        } catch (e) {
          // Optionally log or ignore
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Location Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Obx(
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
                    Icon(
                      Icons.location_on,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Location",
                            style: GoogleFonts.openSans(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            locationController.selectedAddress.value.isNotEmpty
                                ? locationController.selectedAddress.value
                                : "Fetching...",
                            style: GoogleFonts.openSans(
                              color: theme.colorScheme.primary,
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Bar Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                // Menu
                IconButton(
                  icon: SvgPicture.asset(
                    Assets.svgMenu,
                    colorFilter: ColorFilter.mode(Colors.blue, BlendMode.srcIn),
                  ),
                  onPressed: () {
                    Get.to(
                      () => const ProfilePage(),
                      transition: Transition.leftToRight,
                      duration: const Duration(milliseconds: 450),
                    );
                  },
                ),
                const SizedBox(width: 4),
                // Search field
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final mainState =
                          context
                              .findAncestorStateOfType<NavigationFlowState>();
                      mainState?.pushToCurrentTab(
                        SearchScreen(),
                        hideBottomBar: false,
                      );
                    },
                    child: Container(
                      height: 37,
                      padding: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFE2EDF9), // Adapt background to theme
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: theme.colorScheme.onSurface.withAlpha(60),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.search),
                          SizedBox(width: 5),

                          Text(
                            "What are you looking for",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                            // decoration: InputDecoration(
                            //   hintText: "Searching",
                            //   hintStyle: GoogleFonts.openSans(
                            //     color: theme.colorScheme.onSurface.withValues(
                            //       alpha: 0.6,
                            //     ),
                            //     fontSize: 13,
                            //   ),
                            //   prefixIcon: Icon(
                            //     Icons.search,
                            //     color: theme.colorScheme.primary,
                            //     size: 23,
                            //   ),
                            //   border: InputBorder.none,
                            //   isDense: true,
                            //   contentPadding: const EdgeInsets.symmetric(
                            //     horizontal: 10,
                            //     vertical: 10,
                            //   ),
                            // ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // "Diamond" icon
                CircleAvatar(
                  radius: 16,
                  backgroundColor: theme.colorScheme.surface,
                  child: SvgPicture.asset(Assets.svgDiamondhome),
                ),
              ],
            ),
          ),
          // Banner slider section
          if (loopedSlides.isNotEmpty)
            Column(
              children: [
                // Slider with banners
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: PageView.builder(
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
                      final item = loopedSlides[index];
                      final screenWidth = MediaQuery.of(context).size.width;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SizedBox(
                          height: 180, // or larger if needed for your image
                          child: Stack(
                            clipBehavior: Clip.none, // allow overflow
                            children: [
                              // The Card (lower in z-order)
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 164, // less than Stack max height
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Text(
                                                item.title,
                                                style:
                                                    GoogleFonts.dmSerifDisplay(
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            if (item.description.isNotEmpty)
                                              Text(
                                                item.description,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 11,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      SizedBox(width: screenWidth * 0.3),
                                    ],
                                  ),
                                ),
                              ),

                              // The image placed ABOVE the card, touching the bottom edge
                              Positioned(
                                right: 10,
                                bottom: 0,
                                child: SizedBox(
                                  height: 203,
                                  width: 163, // bigger than card to float above
                                  child:
                                      item.vectorImage.isNotEmpty
                                          ? (item.isSvg
                                              ? SvgPicture.network(
                                                item.vectorImage,
                                                fit: BoxFit.contain,
                                              )
                                              : Image.network(
                                                item.vectorImage,
                                                fit: BoxFit.contain,
                                              ))
                                          : const SizedBox.shrink(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // ⬅️ Arrow + Dots + Arrow ➡️
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.arrow_back_ios,
                    //     color: Colors.black87,
                    //     size: 18,
                    //   ),
                    //   onPressed: () {
                    //     if (pageController.hasClients) {
                    //       pageController.previousPage(
                    //         duration: const Duration(milliseconds: 300),
                    //         curve: Curves.easeInOut,
                    //       );
                    //     }
                    //   },
                    // ),
                    const SizedBox(width: 8),

                    Row(
                      children: List.generate(widget.slides!.length, (index) {
                        final isActive = index == (currentIndex - 1);
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 10 : 6,
                          height: isActive ? 10 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isActive
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withValues(
                                      alpha: 0.3,
                                    ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(width: 8),

                    // IconButton(
                    //   icon: const Icon(
                    //     Icons.arrow_forward_ios,
                    //     color: Colors.black87,
                    //     size: 18,
                    //   ),
                    //   onPressed: () {
                    //     if (pageController.hasClients) {
                    //       pageController.nextPage(
                    //         duration: const Duration(milliseconds: 300),
                    //         curve: Curves.easeInOut,
                    //       );
                    //     }
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
