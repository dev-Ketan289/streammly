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
              color: const Color(0xFFF0F6FF), // Keep original background color as per your design
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
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        "View All",
                        style: GoogleFonts.poppins(
                          textStyle: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            color: theme.colorScheme.onSurfaceVariant,
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
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Date, Time and Photographers
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: theme.iconTheme.color),
                      const SizedBox(width: 6),
                      Text(
                        "15 June, Saturday",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time, size: 16, color: theme.iconTheme.color),
                      const SizedBox(width: 6),
                      Text(
                        "12:30 pm",
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Photographer Text (you didn't want theme here originally)
                  Text(
                    "3 Photographers",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Bottom Right Curved Box with Icons
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: 60,
                width: 140,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, color: theme.colorScheme.onPrimary),
                    const SizedBox(width: 16),
                    Icon(Icons.notifications_none, color: theme.colorScheme.onPrimary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
