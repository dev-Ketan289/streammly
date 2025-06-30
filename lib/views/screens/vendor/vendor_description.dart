import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/views/screens/vendor/vendor_detail.dart';

class VendorDescription extends StatelessWidget {
  const VendorDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CompanyController>(
        builder: (controller) {
          final company = controller.selectedCompany;

          return Stack(
            children: [
              // Background Image
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child:
                    company?.bannerImage != null
                        ? Image.network('http://192.168.1.113:8000/${company!.bannerImage}', fit: BoxFit.fitHeight)
                        : Image.asset('assets/images/newBorn.jpg', fit: BoxFit.fill),
              ),

              // Overlay
              Container(height: double.infinity, width: double.infinity, color: Colors.indigo.withValues(alpha: 0.4)),

              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(company?.companyName ?? 'Vendor', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Spacer(),

                      Row(
                        children: [
                          Text(company?.categoryName ?? 'Service', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),
                          if (company?.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                              child: Text("${company!.rating!.toStringAsFixed(1)} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            company?.distanceKm != null && company!.distanceKm! > 1
                                ? "${company.distanceKm!.toStringAsFixed(1)} km"
                                : "${(company?.distanceKm ?? 0) * 1000 ~/ 1} m",
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Text(
                        (company?.description?.trim().isNotEmpty ?? false)
                            ? company!.description!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
                            : "FocusPoint Studio is a premium photography and videography studio, offering state-of-the-art facilities for creative professionals and clients.",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),

                      const SizedBox(height: 16),
                      if (company?.description == null || company!.description!.trim().isEmpty) ...[
                        const Text("Our Services Include:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text("✅ Studio Rental (Photography / Videography)", style: TextStyle(color: Colors.white)),
                        const Text("✅ Professional Photography Services", style: TextStyle(color: Colors.white)),
                        const Text("✅ Cinematic Videography", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 16),
                        const Text("Why Choose Us:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text("• High-end studio environment", style: TextStyle(color: Colors.white)),
                        const Text("• Latest photography and video equipment", style: TextStyle(color: Colors.white)),
                        const Text("• Experienced creative team", style: TextStyle(color: Colors.white)),
                      ],

                      const SizedBox(height: 20),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          ),
                          onPressed: () {
                            if (company != null) {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: company)));
                            }
                          },
                          child: const Text("Let’s Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
