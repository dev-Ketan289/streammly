import 'package:flutter/material.dart';

class CommonPopupDialog extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final String primaryBtnText;
  final VoidCallback onPrimaryPressed;
  final String secondaryBtnText;
  final VoidCallback onSecondaryPressed;

  const CommonPopupDialog({
    super.key,
    required this.imagePath,
    required this.title,
    required this.message,
    required this.primaryBtnText,
    required this.onPrimaryPressed,
    required this.secondaryBtnText,
    required this.onSecondaryPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String message,
    required String primaryBtnText,
    required VoidCallback onPrimaryPressed,
    required String secondaryBtnText,
    required VoidCallback onSecondaryPressed,
  }) {
    return showDialog(
      context: context,
      builder:
          (_) => CommonPopupDialog(
            imagePath: imagePath,
            title: title,
            message: message,
            primaryBtnText: primaryBtnText,
            onPrimaryPressed: onPrimaryPressed,
            secondaryBtnText: secondaryBtnText,
            onSecondaryPressed: onSecondaryPressed,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 100),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog first
                onPrimaryPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2864A6), // Solid blue fill
                foregroundColor: Colors.white, // White text
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                primaryBtnText,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSecondaryPressed();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2864A6)), // Blue border
                foregroundColor: const Color(0xFF225CA7), // Blue text
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                secondaryBtnText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
