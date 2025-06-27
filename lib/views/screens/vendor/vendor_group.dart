import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:streammly/views/screens/package/get_quote_page.dart';

import '../../../models/company/company_location.dart';
import '../../../navigation_menu.dart';
import '../home/widgets/header_banner.dart';
import '../package/package_page.dart';

class VendorGroup extends StatefulWidget {
  final CompanyLocation company;
  final int subCategoryId;

  const VendorGroup({
    super.key,
    required this.company,
    required this.subCategoryId,
  });

  @override
  State<VendorGroup> createState() => _VendorGroupState();
}

class _VendorGroupState extends State<VendorGroup> {
  List<Map<String, String>> subVerticals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubVerticals();
  }

  Future<void> fetchSubVerticals() async {
    try {
      final url = Uri.parse(
        "http://192.168.1.10:8000/api/v1/basic/getsubvertical",
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "company_id": widget.company.id,
          "sub_category_id": widget.subCategoryId,
        }),
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);

        if (jsonBody['success'] == true && jsonBody['data'] is List) {
          final List data = jsonBody['data'];

          subVerticals =
              data.map<Map<String, String>>((item) {
                final rawPath = item["image"]?.toString() ?? "";
                final cleanedPath = rawPath.replaceFirst(RegExp(r'^/+'), '');
                final imageUrl =
                    cleanedPath.isNotEmpty
                        ? "http://192.168.1.10:8000/$cleanedPath"
                        : "";

                print("📸 SubVertical image: $imageUrl");

                return {
                  "image": imageUrl,
                  "label": item["title"] ?? "Untitled",
                };
              }).toList();
        } else {
          subVerticals = [];
          Get.snackbar("No Data", "No sub-verticals found.");
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch sub-verticals: ${response.statusCode}",
        );
      }
    } catch (e) {
      Get.snackbar("Exception", "Something went wrong: $e");
    }

    setState(() => isLoading = false);
  }

  void _showShootOptionsBottomSheet(BuildContext context, String shootTitle) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  shootTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildOptionTile(
                icon: Icons.request_quote,
                label: "Get Quote",
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const GetQuotePage());
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
              Row(
                children: const [
                  Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "This vendor offers the following facilities",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: const [
                  _FacilityIcon(
                    label: "New Born\nWrapper",
                    icon: Icons.child_friendly,
                  ),
                  _FacilityIcon(
                    label: "Sanitize\nEquipments",
                    icon: Icons.cleaning_services,
                  ),
                  _FacilityIcon(
                    label: "Clean\nAccessories",
                    icon: Icons.backpack,
                  ),
                  _FacilityIcon(
                    label: "Clean\nCloths",
                    icon: Icons.local_laundry_service,
                  ),
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
      bottomNavigationBar: NavigationHelper.buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: NavigationHelper.buildFloatingButton(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderBanner(
                height: 280,
                backgroundImage:
                    widget.company.bannerImage != null &&
                            widget.company.bannerImage!.isNotEmpty
                        ? 'http://192.168.1.10:8000/${widget.company.bannerImage}'
                        : 'assets/images/recommended_banner/FocusPointVendor.png',
                overlayColor: Colors.indigo.withOpacity(0.6),
                overrideTitle: widget.company.companyName,
                overrideSubtitle: widget.company.categoryName,
              ),
              const SizedBox(height: 10),
              isLoading
                  ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : subVerticals.isEmpty
                  ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "No sub-verticals available.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                  : GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: subVerticals.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                    itemBuilder: (context, index) {
                      final item = subVerticals[index];
                      final imageUrl = item['image'] ?? '';

                      return GestureDetector(
                        onTap:
                            () => _showShootOptionsBottomSheet(
                              context,
                              item['label'] ?? '',
                            ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child:
                                    imageUrl.isNotEmpty
                                        ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Image.asset(
                                              "assets/images/category/vendor_category/img.png",
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        )
                                        : Image.asset(
                                          "assets/images/category/vendor_category/img.png",
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['label'] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
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

Widget _buildOptionTile({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  Color iconColor = Colors.blue,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
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
        CircleAvatar(
          backgroundColor: Colors.indigo.withOpacity(0.1),
          radius: 22,
          child: Icon(icon, color: Colors.indigo, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
