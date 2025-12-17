import 'package:flutter/material.dart';
import '../model/draw_path.dart';

class GraffitiPainter extends CustomPainter {
  final List<DrawPath> paths;

  GraffitiPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    for (final drawPath in paths) {
      canvas.drawPath(drawPath.path, drawPath.paint);
    }
  }

  @override
  bool shouldRepaint(covariant GraffitiPainter oldDelegate) {
    return true;
  }
}
