import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../controllers/package_page_controller.dart';
import '../../../models/company/company_location.dart';
import '../../../navigation_menu.dart';
import '../home/widgets/header_banner.dart';
import '../package/get_quote_page.dart';
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
  late CompanyController controller;
  int selectedSubCategoryId = -1;

  @override
  void initState() {
    super.initState();
    controller = Get.find<CompanyController>();
    selectedSubCategoryId = widget.subCategoryId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompanySubCategories(widget.company.id ?? 0);
      controller.fetchSubVerticalCards(
        widget.company.id ?? 0,
        selectedSubCategoryId,
      );
    });
  }

  /// Helper function to resolve image URL
  String resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return url.startsWith('http') ? url :url.replaceFirst(RegExp(r'^/'), '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // bottomNavigationBar: NavigationHelper.buildBottomNav(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: NavigationHelper.buildFloatingButton(),
      body: CustomBackground(
        child: SafeArea(
          child: Column(
            children: [
              /// Header Banner
              HeaderBanner(
                height: screenWidth * 0.7,
                backgroundImage:
                    (widget.company.bannerImage?.isNotEmpty == true)
                        ? resolveImageUrl(widget.company.bannerImage)
                        : 'assets/images/recommended_banner/FocusPointVendor.png',
                overlayColor: primaryColor.withValues(alpha: 0.6),
                overrideTitle: widget.company.companyName,
                overrideSubtitle: widget.company.categoryName,
                specialities: widget.company.specialities,
              ),

              const SizedBox(height: 10),

              /// Category Scroller with selection
              GetBuilder<CompanyController>(
                builder: (_) {
                  final subs = controller.subCategories;

                  if (subs.isEmpty) {
                    return const SizedBox();
                  }

                  return SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: subs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final sub = subs[index];
                        final isSelected = selectedSubCategoryId == sub.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSubCategoryId = sub.id;
                            });
                            controller.fetchSubVerticalCards(
                              widget.company.id ?? 0,
                              sub.id,
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? theme.primaryColor
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          resolveImageUrl(sub.image),
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Image.asset(
                                                "assets/images/category/vendor_category/img.png",
                                                fit: BoxFit.cover,
                                              ),
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xff3367A3,
                                          ).withValues(alpha: 0.5),
                                        ),
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  sub.title,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 12,
                                    color:
                                        isSelected
                                            ? theme.primaryColor
                                            : Colors.black,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              /// Sub-verticals Grid
              Expanded(
                child: GetBuilder<CompanyController>(
                  builder: (controller) {
                    if (controller.isSubVerticalLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final subVerticals = controller.subVerticalCards;

                    if (subVerticals.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "No sub-verticals available.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      itemCount: subVerticals.length,
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
                        final label = item['label'] ?? '';
                        final id = int.tryParse(item['id'] ?? '') ?? 0;

                        return GestureDetector(
                          onTap:
                              () => _showShootOptionsBottomSheet(
                                context,
                                label,
                                id,
                                widget.company.id ?? 0,
                                selectedSubCategoryId,
                              ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 111,
                                width: 111,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      imageUrl.isNotEmpty
                                          ? Image.network(
                                            resolveImageUrl(imageUrl),
                                            fit: BoxFit.fill,
                                            errorBuilder: (_, __, ___) {
                                              return Image.asset(
                                                "assets/images/category/vendor_category/img.png",
                                                fit: BoxFit.fill,
                                              );
                                            },
                                          )
                                          : Image.asset(
                                            "assets/images/category/vendor_category/img.png",
                                            fit: BoxFit.fill,
                                          ),
                                ),
                              ),
                              Text(
                                label,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShootOptionsBottomSheet(
    BuildContext context,
    String shootTitle,
    int subVerticalId,
    int companyId,
    int subCategoryId,
  ) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
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
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildOptionTile(
                theme: theme,
                icon: Assets.svgQuotation,
                label: "Get Quote",
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    () => const GetQuoteScreen(),
                    arguments: {
                      "companyId": companyId,
                      "subCategoryId": subCategoryId,
                      "subVerticalId": subVerticalId,
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildOptionTile(
                theme: theme,
                icon: Assets.svgWallet,
                label: "Packages",
                iconColor: Colors.amber,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(
                    () => PackagesPage(
                      companyId: companyId,
                      subCategoryId: subCategoryId,
                      subVerticalId: subVerticalId,
                    ),
                    binding: BindingsBuilder(() {
                      Get.put(PackagesController());
                    }),
                  );
                },
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  Icon(Icons.info_outline, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "This vendor offers the following facilities",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ), // Replace with your desired color or use a variable if needed
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue[800], // You can match the theme
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Get.to(() => ViewPortfolioPage(companyId: companyId));
                  },
                  child: const Text(
                    "View Portfolio",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required ThemeData theme,
    required String icon,
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
              backgroundColor: iconColor,
              child: SvgPicture.asset(
                icon,
                fit: BoxFit.scaleDown,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: backgroundDark,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _FacilityIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FacilityIcon({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
          radius: 22,
          child: Icon(icon, color: theme.primaryColor, size: 20),
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
