import 'package:flutter/material.dart';

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
      // bottomNavigationBar: NavigationMenu(),
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
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and Heart Icon
                Stack(
                  children: [
                    TRoundedImage(
                      imageUrl: cat["image"]!,
                      height: 100,
                      width: 500,
                      fit: BoxFit.fill,
                      borderRadius: 16,
                      isNetworkImage: false, // or true if using network image
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.bookmark, size: 18, color: Colors.red),
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
}
