import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/views/screens/vendor/package_page.dart';

import '../../../models/banner/header_banner_item.dart';
import '../../../navigation_menu.dart';
import '../home/widgets/header_banner.dart';

class VendorGroup extends StatelessWidget {
  VendorGroup({super.key});

  final List<Map<String, String>> shootOptions = [
    {"image": "assets/images/category/vendor_category/img.png", "label": "New Born Shoot"},
    {"image": "assets/images/category/vendor_category/img.png", "label": "Toddler Shoot"},
    {"image": "assets/images/category/vendor_category/img.png", "label": "Infant Shoot"},
    {"image": "assets/images/category/vendor_category/img.png", "label": "Milestone"},
    {"image": "assets/images/category/vendor_category/img.png", "label": "Pre Schooler"},
  ];

  void _showShootOptionsBottomSheet(BuildContext context, String shootTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Sheet handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
              ),
              // Title
              Align(alignment: Alignment.centerLeft, child: Text(shootTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              const SizedBox(height: 16),

              // Get Quote & Packages
              _buildOptionTile(
                icon: Icons.request_quote,
                label: "Get Quote",
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const PackagesPage());
                  // TODO: Navigate or show quote page
                },
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                icon: Icons.card_giftcard,
                label: "Packages",
                iconColor: Colors.amber,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const PackagesPage());
                },
              ),

              const SizedBox(height: 24),

              // Info section
              Row(
                children: const [
                  Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text("This vendor offers the following facilities", style: TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),

              // Facilities icons row
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: const [
                  _FacilityIcon(label: "New Born\nWrapper", icon: Icons.child_friendly),
                  _FacilityIcon(label: "Sanitize\nEquipments", icon: Icons.cleaning_services),
                  _FacilityIcon(label: "Clean\nAccessories", icon: Icons.backpack),
                  _FacilityIcon(label: "Clean\nCloths", icon: Icons.local_laundry_service),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FD),
      bottomNavigationBar: NavigationHelper.buildBottomNav(), // Use the helper method
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderBanner(
                banners: [
                  BannerItem(
                    image: "assets/images/recommended_banner/FocusPointVendor.png",
                    title: "Photography",
                    subtitle: "Capture your moments perfectly.",
                  ),
                ],
                height: 280,
                location: "Mahim",
                address: "MTNL Telephone Colony, VSNL Colony",
                color: Colors.indigo.withValues(alpha: 0.4), overlayOpacity: 0.7,
              ),
              const SizedBox(height: 10),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: shootOptions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 per row
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65, // Adjust to fit height
                ),
                itemBuilder: (context, index) {
                  final item = shootOptions[index];
                  return GestureDetector(
                    onTap: () => _showShootOptionsBottomSheet(context, item['label'] ?? ''),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(item['image']!, fit: BoxFit.cover))),
                        const SizedBox(height: 8),
                        Text(item['label']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 14), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildOptionTile({required IconData icon, required String label, required VoidCallback onTap, Color iconColor = Colors.blue}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: iconColor.withOpacity(0.1), child: Icon(icon, color: iconColor)),
          const SizedBox(width: 16),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          const Icon(Icons.chevron_right),
        ],
      ),
    ),
  );
}

class _FacilityIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FacilityIcon({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Colors.indigo.withOpacity(0.1), radius: 22, child: Icon(icon, color: Colors.indigo, size: 20)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
      ],
    );
  }
}
