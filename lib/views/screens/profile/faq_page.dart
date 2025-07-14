import 'package:flutter/material.dart';
import 'package:streammly/services/theme.dart';

class FaqItem {
  final String question;
  final String answer;
  bool isExpanded;
  FaqItem({required this.question, required this.answer, this.isExpanded = false});
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final List<FaqItem> _faqs = [
    FaqItem(
      question: 'What is the most popular online shopping store?',
      answer: 'Morbi adipiscing gravida dolor dui tincidunt libero. Duis malesuada massa libero nec accumsan nunc gravida.',
    ),
    FaqItem(
      question: 'Why online shopping is popular nowadays?',
      answer: 'Online shopping is convenient and offers a wide variety of products.',
    ),
    FaqItem(
      question: 'Is one of the largest online shopping website in the world?',
      answer: 'Yes, there are several large online shopping websites globally.',
    ),
    FaqItem(
      question: 'Which is the biggest online shopping in India?',
      answer: 'Flipkart and Amazon are among the biggest in India.',
    ),
    FaqItem(
      question: 'What are the benefits of a personal shopper?',
      answer: 'Personal shoppers help you find the best products for your needs.',
    ),
    FaqItem(
      question: 'Is one of the largest online shopping website in the world?',
      answer: 'Yes, it is among the largest.',
    ),
    FaqItem(
      question: 'Which is the biggest online shopping in India?',
      answer: 'Flipkart and Amazon are among the biggest.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xff666666)),
        ),
        title: Text("FAQ's", style: TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(color: backgroundDark, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: _faqs.length,
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemBuilder: (context, index) {
                  final item = _faqs[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            item.question,
                            style:CustomTheme.light.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                          ),
                          trailing: Icon(
                            item.isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: backgroundDark,
                          ),
                          onTap: () {
                            setState(() {
                              item.isExpanded = !item.isExpanded;
                            });
                          },
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        if (item.isExpanded)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.answer,
                                style: TextStyle(
                                  color: Color(0xff8D8D8D),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFF8F8F8),
    );
  }
}

