import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class CustomLocAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onVendorTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onSearchTap;
  final bool isSearchSelected;
  final bool isFilterSelected;
  final bool isVendorSelected;
  final String subtitle;
  final int companyCount; // New parameter
  const CustomLocAppBar({
    super.key,
    this.onVendorTap,
    this.onFilterTap,
    this.onSearchTap,
    this.isSearchSelected = false,
    this.isFilterSelected = false,
    this.isVendorSelected = false,
    this.subtitle = '',
    required this.companyCount ,
  });

  @override
  Size get preferredSize => const Size.fromHeight(145);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and subtitle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find Vendors',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Discover near by',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Icons
                  Row(
                    children: [
                      IconButton(
                        onPressed: onSearchTap,
                        icon: Icon(
                          isSearchSelected
                              ? Icons.search_rounded
                              : Icons.search,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: onFilterTap,
                        icon: Icon(
                          isFilterSelected ? Icons.tune_rounded : Icons.tune,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: onVendorTap,
                        icon: Icon(
                          isVendorSelected
                              ? Icons.location_on_sharp
                              : Icons.list,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Vendors found pill
              Center(
                child: Container(
                  width: 420,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$companyCount vendors found',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildIconButton(IconData icon) {
  //   return Container(
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF1F1F1),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: IconButton(
  //       icon: Icon(icon, size: 18, color: Colors.black),
  //       onPressed: () {},
  //     ),
  //   );
  // }
}
