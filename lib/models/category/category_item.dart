import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CategoryItem {
  final String label;
  final IconData? icon;
  final String? imagePath;
  final String? iconUrl;
  final VoidCallback? onTap;

  CategoryItem({
    required this.label,
    this.icon,
    this.imagePath,
    this.iconUrl,
    this.onTap,
  });

  // Factory constructor from API JSON
  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      label: json['title'],
      imagePath: json['image'], // FULL URL from API
      iconUrl: json['icon'],
    );
  }
}
