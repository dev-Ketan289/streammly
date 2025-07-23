import 'package:flutter/material.dart';

class ScallopDivider extends StatelessWidget {
  final double height;
  final double radius;
  final int count;

  const ScallopDivider({
    this.height = 24,
    this.radius = 12,
    this.count = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          count,
          (index) => Container(
            margin: EdgeInsets.all(2),
            width: radius * 2,
            height: radius * 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
