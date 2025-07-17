import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class BusinessInfoScreen extends StatelessWidget {
  final String title;
  final String htmlContent;

  const BusinessInfoScreen({super.key, required this.title, required this.htmlContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: SingleChildScrollView(padding: const EdgeInsets.all(16.0), child: Html(data: htmlContent)));
  }
}
