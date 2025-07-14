import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final List<Map<String, String>> transactions = [
      {
        'title': 'Wedding Day Coverage',
        'bookingId': 'PHO-2602',
        'amount': '₹ 20,000',
        'status': 'Completed',
        'tag': 'Final Payment',
        'category': 'Photography',
        'date': '2025-05-19',
      },
      {
        'title': 'Pre-Wedding Shoot',
        'bookingId': 'DEC-5501',
        'amount': '₹ 20,000',
        'status': 'Completed',
        'tag': 'Booking Advance',
        'category': 'Photography',
        'date': '2025-05-19',
      },
      {
        'title': 'Bridal Look',
        'bookingId': 'CAT-8801',
        'amount': '₹ 20,000',
        'status': 'Pending',
        'tag': 'Partial Payment',
        'category': 'Photography',
        'date': '2025-05-19',
      },
      {
        'title': 'Reception Look',
        'bookingId': 'DEC-5501',
        'amount': '₹ 15,000',
        'status': 'Completed',
        'tag': 'Final Payment',
        'category': 'Photography',
        'date': '2025-05-19',
      },
      {
        'title': 'Wedding Dinner',
        'bookingId': 'DEC-5501',
        'amount': '₹ 10,000',
        'status': 'Completed',
        'tag': 'Final Payment',
        'category': 'Photography',
        'date': '2025-05-19',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: theme.primaryColorLight),
        title: Text(
          "Transaction History",
          style: textTheme.titleMedium?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Background white
        elevation: 0,
      ),
      backgroundColor: Colors.white, // Background white
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Category",
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.cardColor, // Slightly grey dropdown
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: const [
                    DropdownMenuItem(
                      value: "All",
                      child: Text("All"),
                    ),
                  ],
                  onChanged: (value) {},
                  value: "All",
                  style: textTheme.bodyMedium,
                  isExpanded: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final txn = transactions[index];
                  final isCompleted = txn['status'] == 'Completed';

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.cardColor, // Slightly grey cards
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    txn['title']!,
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Booking ID: ${txn['bookingId']}',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                txn['status']!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: isCompleted ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              txn['amount']!,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            _chip(
                              theme,
                              DateFormat('d MMM y')
                                  .format(DateTime.parse(txn['date']!)),
                              Colors.grey.shade100,
                              Colors.black54,
                              icon: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _chip(theme, txn['tag']!, Colors.blue.shade50,
                                theme.primaryColor),
                            const Spacer(),
                            _chip(theme, txn['category']!,
                                Colors.grey.shade200, Colors.black87),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chip(ThemeData theme, String label, Color bg, Color color,
      {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                icon,
                size: 14,
                color: color,
              ),
            ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
