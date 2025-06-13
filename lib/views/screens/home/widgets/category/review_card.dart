import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String name;
  final String dateTime;
  final String review;
  final double rating;

  const ReviewCard({super.key, required this.name, required this.dateTime, required this.review, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(radius: 20, backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(height: 8),

          // Rating stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return const Icon(Icons.star, color: Colors.orange, size: 16);
            }),
          ),

          const SizedBox(height: 8),

          // Name & Date
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(dateTime, style: const TextStyle(fontSize: 11, color: Colors.grey)),

          const SizedBox(height: 8),

          // Review text
          Text(review, style: const TextStyle(fontSize: 13), textAlign: TextAlign.center, maxLines: 3, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
