import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streammly/services/theme.dart';

class CustomErrorWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  const CustomErrorWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imagePath, height: 120, fit: BoxFit.contain),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      primaryButtonText,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (secondaryButtonText != null && onSecondaryPressed != null)
                  TextButton(
                    onPressed: onSecondaryPressed,
                    child: Text(
                      secondaryButtonText!,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
