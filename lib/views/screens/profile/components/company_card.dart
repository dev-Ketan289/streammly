import 'package:flutter/material.dart';
import 'package:streammly/services/custom_image.dart';
import 'package:streammly/services/theme.dart';

class CompanyCard extends StatelessWidget {
  const CompanyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double itemWidth = 180;

    return Container(
      margin: EdgeInsets.all(15),
      padding: const EdgeInsets.all(10),

      width: 150,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF9), width: 2),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withAlpha(15),
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageSection(itemWidth),
          _buildInfoSection(theme, itemWidth),
        ],
      ),
    );
  }

  Widget _buildImageSection(double itemWidth) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
            bottom: Radius.circular(16),
          ),
          child: CustomImage(
            path: Assets.imagesBanner,
            height: 40,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const Positioned(
          top: 8,
          right: 8,
          child: Icon(Icons.favorite, size: 25, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildInfoSection(ThemeData theme, double itemWidth) {
    return Padding(
      padding: EdgeInsets.all(itemWidth * 0.025),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Static Company',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ratingColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  children: [
                    Text(
                      '4.5',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.star, size: 14, color: Color(0xFFF8DE1E)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Cleaning Service',
            style: TextStyle(fontSize: 14, color: Color(0xFF6E6D7A)),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Color(0xFFB8B7C8)),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '2.5 km away',
                  style: TextStyle(fontSize: 13, color: Color(0xFFB8B7C8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
