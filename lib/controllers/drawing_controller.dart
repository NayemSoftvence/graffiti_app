import 'package:flutter/material.dart';
import '../models/draw_path.dart';

class DrawingController extends ChangeNotifier {
  final List<DrawPath> _paths = [];
  DrawPath? _currentPath;

  List<DrawPath> get paths => _paths;

  void start(Offset position, Color color, double strokeWidth) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(position.dx, position.dy);

    _currentPath = DrawPath(path: path, paint: paint);
    _paths.add(_currentPath!);
    notifyListeners();
  }

  void update(Offset position) {
    _currentPath?.path.lineTo(position.dx, position.dy);
    notifyListeners();
  }

  void end() {
    _currentPath = null;
  }

  void clear() {
    _paths.clear();
    notifyListeners();
  }

  void undo() {
    if (_paths.isNotEmpty) {
      _paths.removeLast();
      notifyListeners();
    }
  }
}
