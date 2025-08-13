
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_business_settings_controller.dart';
import 'package:streammly/navigation_flow.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/vendor/vendoer_detail.dart';

import '../../../data/repository/company_business_settings_repo.dart';
import '../../../models/company/company_location.dart';

class VendorDescription extends StatefulWidget {
  final CompanyLocation company;
  final int companyId;
  const VendorDescription({
    super.key,
    required this.company,
    required this.companyId,
  });

  @override
  State<VendorDescription> createState() => _VendorDescriptionState();
}

class _VendorDescriptionState extends State<VendorDescription> {
  late CompanyBusinessSettingsController companyBusinessSettings;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<CompanyBusinessSettingsController>()) {
      // Register it with its required repo if not already registered
      if (!Get.isRegistered<CompanyBusinessSettingsRepo>()) {
        Get.lazyPut(() => CompanyBusinessSettingsRepo(apiClient: Get.find()));
      }
      Get.lazyPut(() => CompanyBusinessSettingsController(
        companyBusinessSettingsRepo: Get.find(),
      ));
    }
    companyBusinessSettings = Get.find<CompanyBusinessSettingsController>();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;

    // Use the company parameter directly (do NOT use GetBuilder or controller.selectedCompany)
    Widget bannerWidget;
    final bannerUrl = widget.company.company?.descriptionBackgroundImage;

    if (bannerUrl != null &&
        bannerUrl.isNotEmpty &&
        (Uri.tryParse(bannerUrl)?.hasAbsolutePath ?? false)) {
      bannerWidget = Image.network(
        bannerUrl,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/newBorn.jpg', fit: BoxFit.cover);
        },
      );
    } else {
      bannerWidget = Image.asset(
        'assets/images/newBorn.jpg',
        fit: BoxFit.cover,
      );
    }

    String distanceText =
        widget.company.distanceKm != null
            ? (widget.company.distanceKm! < 1
                ? "${(widget.company.distanceKm! * 1000).toStringAsFixed(0)} m"
                : "${widget.company.distanceKm!.toStringAsFixed(1)} km")
            : "--";

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: bannerWidget,
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: primaryColor.withValues(alpha: 0.4),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: screenWidth * 0.05,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Center(
                            child: Text(
                              widget.company.company?.companyName ??
                                  '', // Use brand/company name
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Spacer(),

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.company.categoryName ?? '',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "${widget.company.estimatedTime ?? "31–36 mins"} • $distanceText",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (widget.company.company?.rating != null)
                        Container(
                          margin: const EdgeInsets.only(left: 140),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ratingColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "${widget.company.company!.rating!.toStringAsFixed(1)} ",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.star,
                                color: Color(0xffFFD700),
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Text(
                    (widget.company.company?.description?.trim().isNotEmpty ??
                            false)
                        ? widget.company.company!.description!.replaceAll(
                          RegExp(r'<[^>]*>|&[^;]+;'),
                          '',
                        )
                        : "FocusPoint Studio is a premium photography and videography studio...",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Center(
                    child: TextButton(
                      onPressed:
                          () => _showMoreDetailsBottomSheet(
                            context,
                            widget.company,
                            widget.companyId,
                          ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "View More Details ",
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 50),
                        backgroundColor: Colors.transparent,
                        side: BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final mainState =
                            context
                                .findAncestorStateOfType<NavigationFlowState>();
                        mainState?.pushToCurrentTab(
                          VendorDetailScreen(studio: widget.company),
                        );
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => VendorDetailScreen(company: company)));
                      },
                      child: Text(
                        "Let’s Continue",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void _showMoreDetailsBottomSheet(
    BuildContext context,
    CompanyLocation company,
    int companyId,
    
  ) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final controller =
        Get.find<
          CompanyBusinessSettingsController
        >(); // Use the existing controller

    // Ensure data is fetched for the specific companyId when the bottom sheet opens
    if (controller.settings == null ||
        controller.settings!.companyId != companyId.toString()) {
      controller.fetchCompanyBusinessSettings(companyId.toString());
    }
    log(companyId.toString(), name: 'companyid');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.08,
            20,
            screenWidth * 0.08,
            30,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "${company.estimatedTime ?? "31–36 mins"} • ${company.distanceKm != null ? "${company.distanceKm!.toStringAsFixed(1)} km" : "--"}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Text(
                      company.company?.companyName ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    if (company.company?.rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ratingColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${company.company!.rating!.toStringAsFixed(1)} ",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xffFFD700),
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    company.categoryName ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "About",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (company.company?.description?.trim().isNotEmpty ?? false)
                      ? company.company!.description!.replaceAll(
                        RegExp(r'<[^>]*>|&[^;]+;'),
                        '',
                      )
                      : "FocusPoint Studios is a premium photography and videography studio, offering state-of-the-art facilities...",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),

                // Opening hours placeholder: replace with real data if needed
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Opening Hours",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                GetBuilder<CompanyBusinessSettingsController>(
                  builder: (companyBusinessSettingsController) {
                    if (companyBusinessSettingsController.isLoading ) {
                      companyBusinessSettingsController.dayTimeSlots.isEmpty;
                      return SizedBox.shrink();
                    }
                    if(companyBusinessSettingsController.dayTimeSlots.isEmpty){
                      companyBusinessSettingsController.dayTimeSlots.clear();
                      return Text("No Opening Hours Data");
                    }
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final days = [
                              "Monday",
                              "Tuesday",
                              "Wednesday",
                              "Thursday",
                              "Friday",
                              "Saturday",
                              "Sunday",
                            ];
                            final day = days[index];
                            final timeSlot =
                                controller.dayTimeSlots[day] ?? "Closed";
                            final isClosed = timeSlot == 'Closed';
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Blue bullet point
                                  Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.only(
                                      top: 6.0,
                                      right: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF156778),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  // Day
                                  Expanded(
                                    child: Text(
                                      day,
                                      style: TextStyle(fontSize: 14,color: Colors.grey),
                                    ),
                                  ),
                                  // Time slot or "Closed"
                                  Expanded(
                                    child: Text(
                                      timeSlot,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isClosed
                                                ? Colors.red
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                      ],
                    );
                  },
                  
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reviews",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xfff8f8f8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/user.jpg'),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Jennie Whang",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "2 days ago",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Text(" 4.0", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "The place was clean, great service, staff are friendly. I will certainly recommend to my...",
                              style: TextStyle(fontSize: 13),
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
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      final mainState =
                          context
                              .findAncestorStateOfType<NavigationFlowState>();
                      mainState?.pushToCurrentTab(
                        VendorDetailScreen(studio: company),
                        hideBottomBar: false,
                      );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => VendorDetailScreen(company: company),
                      //   ),
                      // );
                    },
                    child: const Text(
                      "Let’s Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
