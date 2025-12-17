import 'package:flutter/material.dart';
import '../model/draw_path.dart';

class CaveWallPainter extends CustomPainter {
  final List<DrawPath> paths;

  CaveWallPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {
    // No background; stone_wall.png is visible beneath
    for (final drawPath in paths) {
      canvas.drawPath(drawPath.path, drawPath.paint);
    }
  }

  @override
  bool shouldRepaint(covariant CaveWallPainter oldDelegate) => true;
}
