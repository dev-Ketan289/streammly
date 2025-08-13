import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyQuotationScreen extends StatelessWidget {
  const MyQuotationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, dynamic> recentQuotation = {
      'title': 'Baby Shoot / New Born',
      'date': 'Sun 20 July 2025, 12:00 PM',
      'steps': [
        {
          'label': 'Pending Vendor Response',
          'desc': 'Vendor and is currently awaiting their response.',
          'isActive': true,
        },
        {
          'label': 'Vendor Responded',
          'desc': 'The vendor has responded with a quotation.',
          'isActive': true,
        },
        {
          'label': 'Quote Under Review',
          'desc': 'Our team is reviewing the quotation received.',
          'isActive': true,
        },
        {
          'label': 'Quote Finalized',
          'desc': 'The quotation has been finalized and sent for confirmation.',
          'isActive': true,
        },
      ],
    };

    final List<Map<String, dynamic>> previousQuotations = [
      {
        'title': 'Toddler Shoot',
        'date': 'Sun 20 July 2025, 12:00 PM',
        'removable': true,
      },
      {
        'title': 'Infant Shoot',
        'date': 'Sun 20 July 2025, 12:00 PM',
        'removable': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'My Quotation',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.primaryColor),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recentQuotation['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recentQuotation['date'] as String,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),

                  // Timeline
                  Column(
                    children: List.generate(
                      (recentQuotation['steps'] as List).length,
                      (index) {
                        final step =
                            (recentQuotation['steps'] as List)[index]
                                as Map<String, dynamic>;
                        return _buildTimelineStep(
                          context,
                          step['label'] as String,
                          step['desc'] as String,
                          index !=
                              (recentQuotation['steps'] as List).length - 1,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: Text(
                        "View Package",
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Previous",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...previousQuotations.map((quote) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Slidable(
                            key: ValueKey(quote['title']),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              extentRatio:
                                  0.25, // controls width of delete button
                              children: [
                                const SizedBox(width: 4),
                                SlidableAction(
                                  onPressed: (context) {
                                    // handle remove
                                  },
                                  backgroundColor: Colors.red.shade100,
                                  foregroundColor: Colors.red,
                                  icon: Icons.delete_outline,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          quote['title'] as String,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          quote['date'] as String,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "View Details",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep(
    BuildContext context,
    String title,
    String desc,
    bool hasLine,
  ) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            if (hasLine) Container(width: 2, height: 48, color: Colors.green),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
