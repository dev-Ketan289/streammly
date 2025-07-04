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

          if (company == null) {
            return const Center(child: CircularProgressIndicator());
          }

          Widget bannerWidget;
          final bannerUrl = company.bannerImage;
          if (bannerUrl != null && bannerUrl.isNotEmpty && (Uri.tryParse(bannerUrl)?.hasAbsolutePath ?? false)) {
            bannerWidget = Image.network(
              bannerUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/newBorn.jpg', fit: BoxFit.cover);
              },
            );
          } else {
            bannerWidget = Image.asset('assets/images/newBorn.jpg', fit: BoxFit.cover);
          }

          String distanceText =
              company.distanceKm != null
                  ? (company.distanceKm! < 1 ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m" : "${company.distanceKm!.toStringAsFixed(1)} km")
                  : "--";

          return Stack(
            children: [
              SizedBox(height: double.infinity, width: double.infinity, child: bannerWidget),

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
                            Text(company.companyName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Spacer(),

                      // Category + Rating
                      Row(
                        children: [
                          Text(company.categoryName ?? 'Service', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),
                          if (company.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                              child: Text("${company.rating!.toStringAsFixed(1)} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                            ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Distance
                      // Estimated Time + Distance
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.white),
                          const SizedBox(width: 4),
                          Text("${company.estimatedTime ?? "31–36 mins"} • $distanceText", style: const TextStyle(color: Colors.white, fontSize: 14)),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Text(
                        (company.description?.trim().isNotEmpty ?? false)
                            ? company.description!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
                            : "FocusPoint Studio is a premium photography and videography studio...",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),

                      const SizedBox(height: 10),

                      // View More Details Button
                      Center(
                        child: TextButton(
                          onPressed: () => _showMoreDetailsBottomSheet(context, company),
                          child: const Text("View More Details ▼", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Continue Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: company)));
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

  void _showMoreDetailsBottomSheet(BuildContext context, dynamic company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Distance & Time
                Row(
                  children: [
                    Text(
                      "${company.estimatedTime ?? "31–36 mins"} • ${company.distanceKm != null ? "${company.distanceKm!.toStringAsFixed(1)} km" : "--"}",
                      style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Name & Rating
                Row(
                  children: [
                    Expanded(child: Text(company.companyName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                    if (company.rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(6)),
                        child: Text("${company.rating!.toStringAsFixed(1)} ★", style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                  ],
                ),
                Align(alignment: Alignment.centerLeft, child: Text(company.categoryName ?? 'Photographer', style: const TextStyle(color: Colors.black54))),
                const SizedBox(height: 16),

                const Align(alignment: Alignment.centerLeft, child: Text("About", style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 8),
                Text(
                  (company.description?.trim().isNotEmpty ?? false)
                      ? company.description!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
                      : "FocusPoint Studios is a premium photography and videography studio, offering state-of-the-art facilities...",
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 12),

                // Text("Why Choose Us:", style: TextStyle(fontWeight: FontWeight.bold)),
                // const SizedBox(height: 6),
                // const Text("• High-end studio environment"),
                // const Text("• Latest photography and video equipment"),
                // const Text("• Experienced creative team"),
                // const SizedBox(height: 20),
                Text("Opening Hours", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Monday – Friday", style: TextStyle(color: Colors.black87)),
                        SizedBox(height: 4),
                        Row(children: [Icon(Icons.circle, size: 6, color: Colors.teal), SizedBox(width: 6), Text("08:00am - 03:00pm")]),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Saturday – Sunday", style: TextStyle(color: Colors.black87)),
                        SizedBox(height: 4),
                        Row(children: [Icon(Icons.circle, size: 6, color: Colors.teal), SizedBox(width: 6), Text("09:00am - 02:00pm")]),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Align(alignment: Alignment.centerLeft, child: Text("Reviews", style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xfff8f8f8), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const CircleAvatar(backgroundImage: AssetImage('assets/images/user.jpg'), radius: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Jennie Whang", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text("2 days ago", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(children: [Icon(Icons.star, color: Colors.amber, size: 16), Text(" 4.0", style: TextStyle(fontSize: 12))]),
                            SizedBox(height: 6),
                            Text(
                              "The place was clean, great service, staff are friendly. I will certainly recommend to my...",
                              style: TextStyle(fontSize: 13, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: company)));
                    },
                    child: const Text("Let’s Continue", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
