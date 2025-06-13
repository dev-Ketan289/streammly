import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/views/screens/home/widgets/category/category.dart';
import 'package:streammly/views/screens/home/widgets/category/category_scroller.dart';
import 'package:streammly/views/screens/home/widgets/header_banner.dart';
import 'package:streammly/views/screens/home/widgets/promo_slider.dart';

import '../../../controllers/home_screen_controller.dart';
import '../../../models/category/category_item.dart';
import '../vendor/vendor_description.dart';

class HomeScreen extends StatelessWidget {
  final List<String> promoSlider = ["assets/images/category/media.png"];
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderBanner(backgroundImage: "assets/images/banner.png", height: 370, color: Colors.white.withValues(alpha: 0.2)),
              const SizedBox(height: 24),
              _buildUpcomingCard(),
              const SizedBox(height: 24),
              CategoryScroller(
                title: "Categories",
                onSeeAll: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryListScreen()));
                },
                categories: [
                  CategoryItem(label: "Venue", icon: Icons.place, onTap: () {}),
                  CategoryItem(label: "Photographer", icon: Icons.linked_camera_outlined, onTap: () {}),
                  CategoryItem(label: "Event", icon: Icons.event, onTap: () {}),
                  CategoryItem(label: "Makeup", icon: Icons.brush_sharp, onTap: () {}),
                  CategoryItem(label: "Catering", icon: Icons.local_dining, onTap: () {}),
                ],
              ),
              const SizedBox(height: 24),
              _buildFilterHeader(),
              const SizedBox(height: 24),
              _buildRecommendedList(context),
              const SizedBox(height: 24),
              _buildVendorsList(context),
              SizedBox(height: 26),
              PromoSlider(),

              // You can add more widgets below for category, offers, explore etc.
            ],
          ),
        ),
      ),
    );
  }

  //-Header

  //Upcoming Slider
  Widget _buildUpcomingCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFFF0F6FF), // Light blue background
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Upcoming + View All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upcoming", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                      Text("View All", style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text("Wedding Photography Special", style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87)),

                  const SizedBox(height: 20),

                  // Date, Time and Photographers
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      const Text("15 June, Saturday", style: TextStyle(fontSize: 12, color: Colors.black87)),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      const Text("12:30 pm", style: TextStyle(fontSize: 12, color: Colors.black87)),
                      const Spacer(),
                      const Text("3 Photographers", style: TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 60), // For bottom corner design
                ],
              ),
            ),

            // Bottom Right Curved Box with Icons
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 60,
                width: 140,
                decoration: const BoxDecoration(color: Color(0xFF2356C8), borderRadius: BorderRadius.only(topLeft: Radius.circular(40))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.favorite_border, color: Colors.white), SizedBox(width: 16), Icon(Icons.notifications_none, color: Colors.white)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Recommended header
  Widget _buildFilterHeader() {
    final filters = ['Wishlist', 'Recommended', 'Bundles'];
    final selectedIndex = 1.obs; // Default to 'Recommended'

    final icons = [Icons.favorite, Icons.recommend, Icons.card_giftcard];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // Expanded to prevent overflow
          Expanded(
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(40)),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: List.generate(filters.length, (index) {
                      final isSelected = selectedIndex.value == index;

                      return GestureDetector(
                        onTap: () => selectedIndex.value = index,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(color: isSelected ? Colors.blue : Colors.transparent, borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              Icon(icons[index], size: 16, color: isSelected ? Colors.white : Colors.black54),
                              const SizedBox(width: 4),
                              Text(filters[index], style: TextStyle(fontSize: 13, color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              // TODO: Navigate to full list
            },
            child: Row(
              children: const [
                Text("See all", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 13)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Recommended List
  Widget _buildRecommendedList(BuildContext context) {
    final vendors = [
      {"image": "assets/images/recommended_banner/flavor.png", "name": "Flavor Theory", "type": "Food & Caterers", "time": "35-40 mins", "distance": "4.2 km", "rating": "3.9"},
      {
        "image": "assets/images/recommended_banner/focuspoint.png",
        "name": "FocusPoint Studio",
        "type": "Photographer",
        "time": "28-33 mins",
        "distance": "3.6 km",
        "rating": "3.9",
      },
      {"image": "assets/images/recommended_banner/velvet.png", "name": "Velvet Parlour", "type": "Makeup Artist", "time": "42-48 mins", "distance": "5.1 km", "rating": "3.9"},
    ];

    return SizedBox(
      height: 270,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final vendor = vendors[index];

          return InkWell(
            onTap: () {
              // Navigate to vendor details
            },
            child: Container(
              width: 160, // Use a fixed width that's reasonable for all screen sizes
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 9, offset: const Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(vendor["image"]!, height: 120, width: double.infinity, fit: BoxFit.cover),
                      ),
                      Positioned(top: 8, right: 8, child: Icon(Icons.favorite, size: 20, color: Colors.white)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(vendor["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                              child: Text("${vendor["rating"]} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(vendor["type"]!, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(vendor["time"]!, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(child: Text(vendor["distance"]!, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //Explore us Section
  Widget _buildVendorsList(BuildContext context) {
    final vendors = [
      {
        "image": "assets/images/recommended_banner/FocusPointVendor.png",
        "name": "FocusPoint Studios",
        "type": "Photographer",
        "time": "31–36 mins",
        "distance": "4.0 km",
        "rating": "3.9",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Explore Us !!!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              InkWell(
                onTap: () {
                  // TODO: Navigate to map screen
                },
                child: Row(
                  children: const [
                    Text("View Map", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                    SizedBox(width: 4),
                    Icon(Icons.map_outlined, color: Colors.blue, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          itemCount: vendors.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final vendor = vendors[index];
            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                // ✅ Navigate to detailed screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VendorDescription(), // Replace with your screen
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Image with Favorite Icon
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                          child: Image.asset(vendor["image"]!, height: 150, width: double.infinity, fit: BoxFit.cover),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(backgroundColor: Colors.white, radius: 14, child: const Icon(Icons.favorite_border, size: 16, color: Colors.red)),
                        ),
                      ],
                    ),

                    // Text Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(vendor["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 2),
                                Text(vendor["type"]!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(vendor["time"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(vendor["distance"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue.shade700, borderRadius: BorderRadius.circular(8)),
                            child: Text("${vendor["rating"]} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
