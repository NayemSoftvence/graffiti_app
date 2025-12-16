import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/drawing_controller.dart';
import '../painters/graffiti_painter.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  Color selectedColor = Colors.black;
  double strokeWidth = 6.0;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DrawingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Graffiti'),
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: controller.undo),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: controller.clear,
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          controller.start(details.localPosition, selectedColor, strokeWidth);
        },
        onPanUpdate: (details) {
          controller.update(details.localPosition);
        },
        onPanEnd: (_) {
          controller.end();
        },
        child: CustomPaint(
          painter: GraffitiPainter(controller.paths),
          size: Size.infinite,
        ),
      ),
    );
  }
}
