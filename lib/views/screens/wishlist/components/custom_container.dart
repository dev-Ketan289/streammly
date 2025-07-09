import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key, required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(
            Colors.black,
          ), // Text/icon color
          backgroundColor: WidgetStateProperty.resolveWith<Color>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.blue; // Blue background when pressed
            }
            return Colors.white; // Default white background
          }),
          side: WidgetStateProperty.all(
            const BorderSide(color: Color(0xFFF5EEEE), width: 2),
          ),
          fixedSize: WidgetStateProperty.all(const Size(92, 23)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          padding: WidgetStateProperty.all(
            EdgeInsets.zero,
          ), // Remove default padding
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.black, // Consistent text color
            ),
            overflow: TextOverflow.ellipsis, // Prevent text overflow
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
