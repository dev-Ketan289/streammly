import 'package:flutter/material.dart';
import 'package:streammly/generated/assets.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final BoxFit imageFit;

  const CustomBackground({
    super.key,
    required this.child,
    this.backgroundColor = const Color.fromARGB(255, 238, 244, 255),
    this.imageFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen background image
        Positioned.fill(
          child: Container(
            color: backgroundColor,
            child: Image.asset(
              Assets.imagesDoodle, // Your image path here
              fit: imageFit,
            ),
          ),
        ),
        // Foreground content
        child,
      ],
    );
  }
}
