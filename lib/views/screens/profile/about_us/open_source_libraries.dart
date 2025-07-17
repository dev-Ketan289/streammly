import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../../../controllers/business_setting_controller.dart';

class OpenSourceLibrariesScreen extends StatelessWidget {
  const OpenSourceLibrariesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xff666666))),
        title: Text("Open Source Libraries", style: theme.textTheme.titleMedium?.copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GetBuilder<BusinessSettingController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final content = controller.settings?.openSourceLibraries.trim();

          if (content == null || content.isEmpty || content == 'null') {
            return const Center(child: Text("No data available."));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Html(
              data: content,
              style: {
                "body": Style(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: FontSize(theme.textTheme.bodyMedium?.fontSize ?? 14),
                  fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                ),
              },
            ),
          );
        },
      ),
    );
  }
}
