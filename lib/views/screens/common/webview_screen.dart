import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  String normalizeUrl(String rawUrl) {
    // Ensure the URL has a valid scheme
    if (!rawUrl.startsWith('http://') && !rawUrl.startsWith('https://')) {
      return 'https://$rawUrl';
    }
    return rawUrl;
  }

  @override
  void initState() {
    super.initState();
    final rawUrl = Get.arguments ?? 'https://example.com';
    final fixedUrl = normalizeUrl(rawUrl);

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(fixedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Web View')), body: WebViewWidget(controller: _controller));
  }
}
