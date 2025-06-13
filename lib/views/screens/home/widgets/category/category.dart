import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:streammly/navigation_menu.dart';
import '../../../common/images/rounded_image.dart';

class CategoryListScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {"title": "Venue", "desc": "Banquet Hall, Rooftop Venue, Beach Venue", "results": "10", "rating": "3.9", "image": "assets/images/category/venue.png"},
    {"title": "Media Company", "desc": "Photographer, Videographer, Corporate Photographer", "results": "8", "rating": "3.9", "image": "assets/images/category/media.png"},
    {
      "title": "Event Organiser",
      "desc": "Wedding Planner, Birthday Party Organizer, Music Concert Organizer",
      "results": "10",
      "rating": "3.9",
      "image": "assets/images/category/DJ.png",
    },
    {"title": "Makeup Artist", "desc": "Hairstyle & Makeup (9 yrs of experience)", "results": "10", "rating": "3.9", "image": "assets/images/category/makeupArtsist.png"},
  ];

  CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      bottomNavigationBar: NavigationHelper.buildBottomNav(), // Use the helper method
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: const Text("Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Heart Icon
                Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TRoundedImage(
                          imageUrl: cat["image"]!,
                          height: 100,
                          width: 380,
                          fit: BoxFit.contain,
                          borderRadius: 16,
                          isNetworkImage: false, // or true if using network image
                        ),
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                        child: const Icon(Icons.bookmark, size: 25, color: Colors.red),
                      ),
                    ),
                  ],
                ),

                // Text Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(cat["title"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(right: 16, bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                            child: Text("${cat["rating"]} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(cat["desc"]!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text("Showing ${cat["results"]} results", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ),

                // Rating
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildSimpleBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xffF1F6FB),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, 'Home', () => Get.back()),
          _navItem(Icons.shop, 'Shop', () => _showComingSoon('Shop')),
          _navItem(Icons.shopping_bag, 'Cart', () => _showComingSoon('Cart')),
          _navItem(Icons.calendar_today, 'Bookings', () => _showComingSoon('Bookings')),
          _navItem(Icons.more_horiz, 'More', () => _showComingSoon('More')),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    Get.snackbar(
      'Coming Soon',
      '$feature feature will be available soon!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

