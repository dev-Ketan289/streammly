import 'package:flutter/material.dart';
import 'package:streammly/views/screens/vendor/vendoer_detail.dart';

class VendorDescription extends StatelessWidget {
  const VendorDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(height: double.infinity, width: double.infinity, child: Image.asset('assets/images/newBorn.jpg', fit: BoxFit.cover)),

          // Overlay
          Container(height: double.infinity, width: double.infinity, color: Colors.indigo.withValues(alpha: 0.6)),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AppBar-like section
                  Center(
                    child: Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        const SizedBox(width: 10),
                        Text("FocusPoint Studio", style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Spacer to push content near bottom
                  const Spacer(),

                  // Vendor Info
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text("Photographer", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                          child: const Text("3.9 ★", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.white),
                      const SizedBox(width: 4),
                      const Text("28-33 mins · 3.6 km", style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "FocusPoint Studio is a premium photography and videography studio, offering state-of-the-art facilities for creative professionals and clients.",
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // Services List
                  const Text("Our Services Include:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text("✅ Studio Rental (Photography / Videography)", style: TextStyle(color: Colors.white)),
                  const Text("✅ Professional Photography Services", style: TextStyle(color: Colors.white)),
                  const Text("✅ Cinematic Videography", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),

                  // Why Choose Us
                  const Text("Why Choose Us:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text("• High-end studio environment", style: TextStyle(color: Colors.white)),
                  const Text("• Latest photography and video equipment", style: TextStyle(color: Colors.white)),
                  const Text("• Experienced creative team", style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 20),

                  // Button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen()));
                      },
                      child: const Text("Let’s Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
