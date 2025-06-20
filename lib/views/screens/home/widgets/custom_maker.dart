import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerBitmap(String title, String distance) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(recorder);

  final double width = 200;
  final double height = 80;

  final textPainter = TextPainter(textDirection: TextDirection.ltr);

  final paint = Paint()..color = Colors.white;
  final radius = Radius.circular(16);

  // Draw marker background
  canvas.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(0, 20, width, height - 20), topLeft: radius, topRight: radius, bottomLeft: radius, bottomRight: radius), paint);

  // Draw distance badge
  final badgePaint = Paint()..color = Colors.blue;
  final badgeRect = Rect.fromLTWH(width / 2 - 30, 0, 60, 24);
  canvas.drawRRect(RRect.fromRectAndCorners(badgeRect, topLeft: Radius.circular(12), topRight: Radius.circular(12)), badgePaint);

  // Draw distance text
  textPainter.text = TextSpan(text: distance, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold));
  textPainter.layout(minWidth: 0, maxWidth: width);
  textPainter.paint(canvas, Offset(width / 2 - textPainter.width / 2, 4));

  // Draw company name
  textPainter.text = TextSpan(text: title, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600));
  textPainter.layout(minWidth: 0, maxWidth: width - 16);
  textPainter.paint(canvas, Offset(10, 35));

  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  return BitmapDescriptor.bytes(pngBytes);
}
