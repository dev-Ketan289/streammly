import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Use flutter_svg for SVG images
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/controllers/company_specialities_controller.dart';
import 'package:streammly/generated/assets.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/custom_image.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/widgets/custom_doodle.dart';

import '../../../models/company/company_location.dart';
import '../home/widgets/header_banner.dart';
import '../package/get_quote_page.dart';
import '../package/package_page.dart';

class VendorGroup extends StatefulWidget {
  final CompanyLocation studio;
  final int subCategoryId;

  const VendorGroup({super.key, required this.studio, required this.subCategoryId});

  @override
  State<VendorGroup> createState() => _VendorGroupState();
}

class _VendorGroupState extends State<VendorGroup> {
  late CompanyController controller;
  late CompanySpecialitiesController specialitiesController;
  int selectedSubCategoryId = -1;
  List<String> splitWords(String title) {
    return title.trim().split(RegExp(r'\s+')).take(3).toList();
  }

  @override
  void initState() {
    super.initState();
    controller = Get.find<CompanyController>();
    selectedSubCategoryId = widget.subCategoryId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompanySubCategories(widget.studio.companyId);
      controller.fetchSubVerticalCards(widget.studio.companyId, selectedSubCategoryId);
      controller.fetchSpecialized(widget.studio.companyId);
    });
  }

  String resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return url.startsWith('http') ? url : url.replaceFirst(RegExp(r'^/'), '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    log(selectedSubCategoryId.toString(), name: "selectedsubcate");
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: CustomBackground(
        child: SafeArea(
          child: Column(
            children: [
              GetBuilder<CompanyController>(
                builder: (controller) {
                  final specialized = controller.specialized;
                  return HeaderBanner(
                    height: screenWidth * 0.7,
                    backgroundImage:
                        (widget.studio.company?.bannerImage?.isNotEmpty == true)
                            ? resolveImageUrl(widget.studio.company?.bannerImage)
                            : 'assets/images/recommended_banner/FocusPointVendor.png',
                    overlayColor: primaryColor.withValues(alpha: 0.6),
                    overrideTitle: widget.studio.company?.companyName,
                    overrideSubtitle: widget.studio.categoryName,
                    specialized: specialized,
                  );
                },
              ),

              const SizedBox(height: 10),

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
                            controller.fetchSubVerticalCards(widget.studio.id, sub.id);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: isSelected ? theme.primaryColor : Colors.transparent, width: 2),
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
                                          errorBuilder: (_, __, ___) => Image.asset("assets/images/category/vendor_category/img.png", fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(color: const Color(0xff3367A3).withValues(alpha: 0.5)),
                                        child: const Icon(Icons.check, color: Colors.white, size: 24),
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
                                    color: isSelected ? theme.primaryColor : Colors.black,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

              Expanded(
                child: GetBuilder<CompanyController>(
                  builder: (controller) {
                    if (controller.isSubVerticalLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final subVerticals = controller.subVerticalCards;

                    if (subVerticals.isEmpty) {
                      return const Padding(padding: EdgeInsets.all(16), child: Text("No sub-verticals available.", style: TextStyle(color: Colors.grey)));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: subVerticals.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.65),
                      itemBuilder: (context, index) {
                        final item = subVerticals[index];
                        final imageUrl = item['image'] ?? '';
                        final label = item['label'] ?? '';
                        final id = int.tryParse(item['id'] ?? '') ?? 0;

                        return GestureDetector(
                          onTap: () => _showShootOptionsBottomSheet(context, label, id, widget.studio.companyId, selectedSubCategoryId),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                height: 111,
                                width: 111,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      imageUrl.isNotEmpty
                                          ? Image.network(
                                            resolveImageUrl(imageUrl),
                                            fit: BoxFit.fill,
                                            errorBuilder: (_, __, ___) {
                                              return Image.asset("assets/images/category/vendor_category/img.png", fit: BoxFit.fill);
                                            },
                                          )
                                          : Image.asset("assets/images/category/vendor_category/img.png", fit: BoxFit.fill),
                                ),
                              ),
                              Text(label, textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: primaryColor)),
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

  void _showShootOptionsBottomSheet(BuildContext context, String shootTitle, int subVerticalId, int companyId, int subCategoryId) {
    final theme = Theme.of(context);
    specialitiesController = Get.find<CompanySpecialitiesController>();
    specialitiesController.getCompanySpecialities(subCategoryId.toString());
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(shootTitle, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor)),
                ),
                const SizedBox(height: 10),
                _buildOptionTile(
                  theme: theme,
                  icon: Assets.svgQuotation,
                  label: "Get Quote",
                  onTap: () {
                    Navigator.pop(context);
                    print('[Get Quote] companyId: $companyId | subCategoryId: $subCategoryId | subVerticalId: $subVerticalId');

                    final selectedSubCategory = controller.subCategories.firstWhereOrNull((element) => element.id == subCategoryId);
                    final subCategoryTitle = selectedSubCategory?.title ?? '';

                    final mainState = context.findAncestorStateOfType<NavigationFlowState>();
                    mainState?.pushToCurrentTab(
                      GetQuoteScreen(
                        companyId: companyId,
                        subCategoryId: subCategoryId,
                        subVerticalId: subVerticalId,
                        subCategoryTitle: subCategoryTitle,
                        subVerticalTitle: shootTitle,
                      ),
                      hideBottomBar: true,
                    );
                    // Get.to(
                    //   () => const GetQuoteScreen(),
                    //   arguments: {
                    //     "companyId": companyId,
                    //     "subCategoryId": subCategoryId,
                    //     "subVerticalId": subVerticalId,
                    //     "subCategoryTitle": subCategoryTitle,
                    //     "subVerticalTitle": shootTitle,
                    //   },
                    // );
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
                    log('[Packages] companyId: ${widget.studio.companyId} | subCategoryId: $subCategoryId | subVerticalId: $subVerticalId | studioId: ${widget.studio.id}');

                    final mainState = context.findAncestorStateOfType<NavigationFlowState>();
                    mainState?.pushToCurrentTab(
                      PackagesPage(
                        companyId: widget.studio.companyId,
                        subCategoryId: subCategoryId,
                        subVerticalId: subVerticalId,
                        studioId: widget.studio.id,
                        companyLocation: widget.studio,
                      ),
                      hideBottomBar: true,
                    );

                    // Get.to(
                    //   () => PackagesPage(
                    //     companyId: companyId,
                    //     subCategoryId: subCategoryId,
                    //     subVerticalId: subVerticalId,
                    //     studioId: widget.company.id,
                    //   ),
                    //   binding: BindingsBuilder(() {
                    //     Get.put(PackagesController());
                    //   }),
                    // );
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: const [
                    Icon(Icons.info_outline, size: 18, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("This vendor offers the following facilities", style: TextStyle(color: Colors.black, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                GetBuilder<CompanySpecialitiesController>(
                  builder: (specialitiesController) {
                    if (specialitiesController.isLoading) {
                      return SizedBox.shrink();
                    }

                    return Wrap(
             
                      children: List.generate(specialitiesController.specialities.length, (index) {
                        final specialities = specialitiesController.specialities[index];

                        return Row(
                     
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: 21,
                              height: 21,
                              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                              child: CustomImage(path: specialities.image ?? ''),
                            ),
                            SizedBox(width: 11),
                            Text(specialities.title ?? '', style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 9)),
                            SizedBox(width: 6,)
                          ],
                        );
                      }),
                    );

                  },
                ),

                // Wrap(
                //   spacing: 16,
                //   runSpacing: 12,
                //   alignment: WrapAlignment.center,
                //   children: () {
                //     final maxToShow = 3;
                //     final specs = widget.studio.specialities;
                //     final total = specs.length;
                //     final shown = specs.take(maxToShow).toList();
                //     final remaining = total - maxToShow;
                //     print("Specialities List: ${widget.studio.specialities}");

                //     List<Widget> widgets = [];

                //     for (int i = 0; i < shown.length; i++) {
                //       final title = shown[i];
                //       final imageUrl = resolveImageUrl(widget.studio.getSpecialityImage(title));
                //       final isSvg = (imageUrl.isNotEmpty && imageUrl.toLowerCase().endsWith('.svg'));
                //       final words = splitWords(title);

                //       widgets.add(
                //         Column(
                //           children: [
                //             CircleAvatar(
                //               backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                //               radius: 22,
                //               child:
                //                   (imageUrl.isNotEmpty)
                //                       ? (isSvg
                //                           ? SvgPicture.network(
                //                             imageUrl,
                //                             width: 24,
                //                             height: 24,
                //                             placeholderBuilder: (context) => Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                //                           )
                //                           : ClipRRect(
                //                             borderRadius: BorderRadius.circular(20),
                //                             child: Image.network(
                //                               imageUrl,
                //                               width: 24,
                //                               height: 24,
                //                               fit: BoxFit.cover,
                //                               errorBuilder: (context, error, stackTrace) => Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                //                             ),
                //                           ))
                //                       : Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                //             ),
                //             const SizedBox(height: 4),
                //             Column(children: words.map((word) => Text(word, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center)).toList()),
                //           ],
                //         ),
                //       );
                //     }

                //     if (remaining > 0) {
                //       widgets.add(
                //         Column(
                //           children: [
                //             CircleAvatar(
                //               backgroundColor: Colors.black.withValues(alpha: 0.1),
                //               radius: 22,
                //               child: Center(
                //                 child: Text(
                //                   '+$remaining',
                //                   style: const TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     fontSize: 14,
                //                     color: Colors.black, // Black color for +N
                //                   ),
                //                   textAlign: TextAlign.center,
                //                 ),
                //               ),
                //             ),
                //             const SizedBox(height: 4),
                //             const Text('more', style: TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                //           ],
                //         ),
                //       );
                //     }

                //     return widgets;
                //   }(),
                // ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      // Get.to(() => ViewPortfolioPage(companyId: companyId));
                    },
                    child: const Text("View Portfolio", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({required ThemeData theme, required String icon, required String label, required VoidCallback onTap, Color iconColor = Colors.blue}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: iconColor, child: SvgPicture.asset(icon, fit: BoxFit.scaleDown, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn))),
            const SizedBox(width: 16),
            Expanded(child: Text(label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 14, color: backgroundDark))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// class _FacilityIconDynamic extends StatelessWidget {
//   final String label;
//   final String? imageUrl;
//   final IconData fallbackIcon;
//
//   const _FacilityIconDynamic({required this.label, required this.imageUrl, this.fallbackIcon = Icons.star});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isSvg = (imageUrl != null && imageUrl!.toLowerCase().endsWith('.svg'));
//     return Column(
//       children: [
//         CircleAvatar(
//           backgroundColor: theme.primaryColor.withOpacity(0.1),
//           radius: 22,
//           child:
//               (imageUrl != null && imageUrl!.isNotEmpty)
//                   ? (isSvg
//                       ? SvgPicture.network(imageUrl!, width: 24, height: 24, placeholderBuilder: (context) => Icon(fallbackIcon, color: theme.primaryColor, size: 20))
//                       : ClipRRect(
//                         borderRadius: BorderRadius.circular(20),
//                         child: Image.network(
//                           imageUrl!,
//                           width: 24,
//                           height: 24,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: theme.primaryColor, size: 20),
//                         ),
//                       ))
//                   : Icon(fallbackIcon, color: theme.primaryColor, size: 20),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
//       ],
//     );
//   }
// }
