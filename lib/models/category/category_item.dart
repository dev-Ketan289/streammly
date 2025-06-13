import 'package:flutter/cupertino.dart';

class CategoryItem {
  final String label;
  final IconData? icon;
  final String? imagePath;
  final VoidCallback? onTap;

  CategoryItem({required this.label, this.icon, this.imagePath, this.onTap});
}
