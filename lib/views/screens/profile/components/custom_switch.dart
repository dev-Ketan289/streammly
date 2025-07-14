import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 35,
        height: 20,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          

          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: value
                ? [primaryColor, primaryColor]
                : [Color(0xFFB0B0B0), Color(0xFFD3D3D3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
         
          
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: RadialGradient(
                    colors: [Colors.white, Color(0xFFE0E0E0)],
                    center: Alignment.topLeft,
                    radius: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
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
