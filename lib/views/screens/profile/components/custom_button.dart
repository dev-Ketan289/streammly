import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:streammly/services/theme.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  
  // Icon options
  final String? svgPath;
  final String? imagePath;
  final IconData? iconData;
  final Color? iconColor;
  final double? iconSize;
  
  final VoidCallback? onTap;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    this.width = 31,
    this.height = 31,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 2,
    
    // Icon parameters
    this.svgPath,
    this.imagePath,
    this.iconData,
    this.iconColor,
    this.iconSize = 15,
    
    this.onTap,
    this.child,
    this.padding,
  });

  Widget _buildIcon() {
    if (child != null) return child!;
    
    if (svgPath != null) {
      return SvgPicture.asset(
        svgPath!,
        height: iconSize,
        width: iconSize,
        fit: BoxFit.scaleDown,
        colorFilter: iconColor != null 
          ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
          : null,
      );
    }
    
    if (imagePath != null) {
      return Image.asset(
        imagePath!,
        height: iconSize,
        width: iconSize,
        fit: BoxFit.contain,
      );
    }
    
    if (iconData != null) {
      return Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      );
    }
    
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor,
          shape: BoxShape.circle,
          border: borderColor != null 
            ? Border.all(color: borderColor!, width: borderWidth!)
            : null,
        ),
        child: _buildIcon(),
      ),
    );
  }
}