import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingOfferCard extends StatelessWidget {
  const UpcomingOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                      const Text("15 June, Saturday", style: TextStyle(fontSize: 12, color: Colors.black87), overflow: TextOverflow.ellipsis),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      const Text("12:30 pm", style: TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // const Spacer(),
                  const Text("3 Photographers", style: TextStyle(fontSize: 12, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis), // For bottom corner design
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
}
