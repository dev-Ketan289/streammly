import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RateExperiencePage extends StatefulWidget {
  const RateExperiencePage({super.key});

  @override
  State<RateExperiencePage> createState() => _RateExperiencePageState();
}

class _RateExperiencePageState extends State<RateExperiencePage> {
  int selectedRating = 4;

  final ratingTexts = {
    1: "Very Bad",
    2: "Bad",
    3: "Average",
    4: "Great",
    5: "Excellent",
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black87),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Rate Your Experience",
          style: textTheme.titleMedium?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white, // Outer Light Grey Background
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // Large Grey Container
              borderRadius: BorderRadius.circular(20),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white, // Inner White Container
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "STREAMMLY",
                            style: GoogleFonts.cinzelDecorative(
                              textStyle: textTheme.headlineMedium?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "How would you rate working at Streammly",
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starIndex = index + 1;
                              return IconButton(
                                icon: Icon(
                                  starIndex <= selectedRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedRating = starIndex;
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            ratingTexts[selectedRating]!,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Share your thoughts (Optional)",
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: "Write a review...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Future: Submit Action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Text(
                                "Submit Review",
                                style: textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your Feedback is anonymous and helps us improve",
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
