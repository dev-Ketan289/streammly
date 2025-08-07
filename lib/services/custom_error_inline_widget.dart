import 'package:flutter/material.dart';

class CommonInlineMessage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String message;
  final String btnText;
  final VoidCallback onPressed;

  const CommonInlineMessage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.message,
    required this.btnText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(btnText),
            ),
          ],
        ),
      ),
    );
  }
}
