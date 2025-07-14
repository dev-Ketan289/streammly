import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final List<Map<String, String>> invoices = [
      {
        'invoiceId': 'BKEIAP4514578541258442',
        'category': 'Photography, Makeup Artist',
        'date': '2025-12-30',
      },
      {
        'invoiceId': 'BKEIAP4514578541258442',
        'category': 'Photography, Makeup Artist',
        'date': '2025-12-30',
      },
      {
        'invoiceId': 'BKEIAP4514578541258442',
        'category': 'Photography, Makeup Artist',
        'date': '2025-12-30',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: theme.primaryColorLight),
        title: Text(
          "Invoice",
          style: textTheme.titleMedium?.copyWith(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You can download the invoice in PDF or Excel format",
              style: textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Filter by date",
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                          style: textTheme.bodySmall,
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.calendar_today_outlined, size: 16),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: invoices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final invoice = invoices[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child:
                          Icon(Icons.circle, size: 10, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Invoice - ${invoice['invoiceId']}',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${invoice['category']} / ${DateFormat('MMM dd, yyyy').format(DateTime.parse(invoice['date']!))}',
                                style: textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: PDF download logic
                              },
                              icon: const Icon(Icons.picture_as_pdf_outlined,
                                  color: Colors.red),
                              tooltip: "Download PDF",
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Excel download logic
                              },
                              icon: const Icon(Icons.file_copy_outlined,
                                  color: Colors.green),
                              tooltip: "Download Excel",
                            ),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
