import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingOfferCard extends StatelessWidget {
  const UpcomingOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              color: Color(0xFFE2EDF9), // Adapt background to theme
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Upcoming + View All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Upcoming",
                        style: GoogleFonts.poppins(
                          textStyle: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: theme.colorScheme.primary, // Adapt to theme
                          ),
                        ),
                      ),
                      Text(
                        "View All",
                        style: GoogleFonts.poppins(
                          textStyle: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.colorScheme.primary, // Adapt to theme
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Title
                  Text(
                    "Wedding Photography Special",
                    style: GoogleFonts.playfairDisplay(
                      textStyle: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary, // Adapt to theme
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Date, Time and Photographers
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Date and Time (with icons)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color:
                                    theme.iconTheme.color ??
                                    theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "15 June, Saturday",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color:
                                      theme
                                          .colorScheme
                                          .onSurface, // Adapt to theme
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color:
                                    theme.iconTheme.color ??
                                    theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "12:30 pm",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 12,
                                  color:
                                      theme
                                          .colorScheme
                                          .onSurface, // Adapt to theme
                                ),
                              ),
                              const SizedBox(width: 30),
                            ],
                          ),
                        ],
                      ),
                      // "3 Photographers" centered
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "3 Photographers",
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color:
                                  theme.colorScheme.onSurface, // Adapt to theme
                            ),
                          ),
                        ),
                      ),
                      // The blue icon box is handled by the Positioned widget, so nothing here
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Right Curved Box with Icons
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Container(
            //     height: 60,
            //     width: 140,
            //     decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: const BorderRadius.only(topLeft: Radius.circular(40))),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.favorite_border, color: theme.colorScheme.onPrimary),
            //         const SizedBox(width: 16),
            //         Icon(Icons.notifications_none, color: theme.colorScheme.onPrimary),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
