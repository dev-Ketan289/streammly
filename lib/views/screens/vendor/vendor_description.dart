import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:streammly/controllers/company_controller.dart';
import 'package:streammly/services/theme.dart';
import 'package:streammly/views/screens/vendor/vendoer_detail.dart';

class VendorDescription extends StatelessWidget {
  const VendorDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.05;

    return Scaffold(
      body: GetBuilder<CompanyController>(
        builder: (controller) {
          final company = controller.selectedCompany;

          if (company == null) {
            return const Center(child: CircularProgressIndicator());
          }

          Widget bannerWidget;
          final bannerUrl = company.descriptionBackgroundImage;

          if (bannerUrl != null &&
              bannerUrl.isNotEmpty &&
              (Uri.tryParse(bannerUrl)?.hasAbsolutePath ?? false)) {
            bannerWidget = Image.network(
              bannerUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/newBorn.jpg',
                  fit: BoxFit.cover,
                );
              },
            );
          } else {
            bannerWidget = Image.asset(
              'assets/images/newBorn.jpg',
              fit: BoxFit.cover,
            );
          }


          String distanceText =
              company.distanceKm != null
                  ? (company.distanceKm! < 1
                      ? "${(company.distanceKm! * 1000).toStringAsFixed(0)} m"
                      : "${company.distanceKm!.toStringAsFixed(1)} km")
                  : "--";

          return Stack(
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
                                  company.companyName,
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
                              company.categoryName ?? 'Service',
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
                              "${company.estimatedTime ?? "31–36 mins"} • $distanceText",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (company.rating != null)
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
                                    "${company.rating!.toStringAsFixed(1)} ",
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
                        (company.description?.trim().isNotEmpty ?? false)
                            ? company.description!.replaceAll(
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
                              () =>
                                  _showMoreDetailsBottomSheet(context, company),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "View More Details ",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => VendorDetailScreen(company: company),
                              ),
                            );
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
          );
        },
      ),
    );
  }

  void _showMoreDetailsBottomSheet(BuildContext context, dynamic company) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
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
                      company.companyName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    if (company.rating != null)
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
                              "${company.rating!.toStringAsFixed(1)} ",
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
                    company.categoryName ?? 'Photographer',
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
                  (company.description?.trim().isNotEmpty ?? false)
                      ? company.description!.replaceAll(
                        RegExp(r'<[^>]*>|&[^;]+;'),
                        '',
                      )
                      : "FocusPoint Studios is a premium photography and videography studio, offering state-of-the-art facilities...",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Icon(Icons.circle, size: 6, color: Colors.teal),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Monday – Friday"),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 12),
                            Text(
                              "08:00am - 03:00pm",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(width: 20),
                    Center(
                      child: Icon(Icons.circle, size: 6, color: Colors.teal),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Saturday – Sunday"),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(width: 12),
                            Text(
                              "08:00am - 03:00pm",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: const [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Monday – Friday"),
                //         SizedBox(height: 4),
                //         Row(children: [Icon(Icons.circle, size: 6, color: Colors.teal), SizedBox(width: 6), Text("08:00am - 03:00pm")]),
                //       ],
                //     ),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Saturday – Sunday"),
                //         SizedBox(height: 4),
                //         Row(children: [Icon(Icons.circle, size: 6, color: Colors.teal), SizedBox(width: 6), Text("09:00am - 02:00pm")]),
                //       ],
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VendorDetailScreen(company: company),
                        ),
                      );
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
