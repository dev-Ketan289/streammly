import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration (You can replace AssetImage with your own or use SizedBox for now)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Image.asset(
                'assets/images/coming_soon.png',
                fit: BoxFit.contain,
                // You should provide your vector or raster image asset.
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Coming Soon',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Making the customer journey as smooth as possible!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withValues(
                  alpha: 0.7,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          // Optional: Progress Dots Indicator
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     _dot(theme, isActive: false),
          //     const SizedBox(width: 8),
          //     _dot(theme, isActive: true),
          //     const SizedBox(width: 8),
          //     _dot(theme, isActive: false),
          //   ],
          // ),
          // const SizedBox(height: 32),
          // // Continue Button (route as per your flow)
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 48.0),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: FilledButton(
          //       style: FilledButton.styleFrom(
          //         backgroundColor: theme.colorScheme.primary,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(24),
          //         ),
          //         padding: const EdgeInsets.symmetric(vertical: 16),
          //       ),
          //       onPressed: () {
          //         // Route to home/dashboard/etc.
          //         // Example using GetX: Get.back();
          //         Navigator.of(context).maybePop();
          //       },
          //       child: Text(
          //         'Continue',
          //         style: theme.textTheme.titleMedium?.copyWith(
          //           color: theme.colorScheme.onPrimary,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _dot(ThemeData theme, {bool isActive = false}) {
  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 200),
  //     width: 8,
  //     height: 8,
  //     decoration: BoxDecoration(
  //       color:
  //           isActive
  //               ? theme.colorScheme.primary
  //               : theme.primaryColorLight.withValues(alpha: 0.3),
  //       shape: BoxShape.circle,
  //     ),
  //   );
}
