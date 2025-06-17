import 'package:flutter/material.dart';

class SectionExpandTile extends StatelessWidget {
  final String title;
  final Widget content;
  final bool initiallyExpanded;

  const SectionExpandTile({super.key, required this.title, required this.content, this.initiallyExpanded = false});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      initiallyExpanded: initiallyExpanded,
      children: [content],
    );
  }
}
