import 'package:flutter/material.dart';

class QuoteSubmittedScreen extends StatelessWidget {
  final String shootType; // e.g., "Baby Shoot / New Born"
  final String submittedDateTime; // e.g., "Sun 20 July 2025, 12:00 PM"

  const QuoteSubmittedScreen({super.key, required this.shootType, required this.submittedDateTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 15),

            Column(
              children: [
                SizedBox(width: 280, height: 280, child: Padding(padding: const EdgeInsets.all(8.0), child: Image.asset("assets/images/Thumb.gif", fit: BoxFit.contain))),
                const SizedBox(height: 24),

                Text(
                  "Quote Request Submitted",
                  style: theme.textTheme.titleMedium?.copyWith(color: const Color(0xFF2864A6), fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  "for ${shootType.trim().isNotEmpty ? shootType : "Selected Shoot"}",
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700, fontWeight: FontWeight.w500, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Text(submittedDateTime, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, color: Colors.black87)),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add navigation logic
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E5CDA), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                  child: const Text("View Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
