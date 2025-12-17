import 'package:flutter/material.dart';
import '../model/draw_path.dart';
import '../model/drawing_tool.dart';
import '../model/mascot_state.dart';

class CaveDrawingViewModel extends ChangeNotifier {
  final List<DrawPath> _paths = [];
  DrawPath? _currentPath;

  DrawingTool _selectedTool = DrawingTool.charcoal;
  MascotState _mascotState = MascotState.happy;

  // ===== Bucket drag state =====
  Offset _bucketPosition = const Offset(0, 0);
  bool _isDraggingBucket = false;

  Offset get bucketPosition => _bucketPosition;
  bool get isDraggingBucket => _isDraggingBucket;

  // ===== GETTERS =====
  DrawingTool get selectedTool => _selectedTool;
  MascotState get mascotState => _mascotState;
  List<DrawPath> get paths => _paths;
  bool get canContinue => _paths.isNotEmpty;

  // ================= LIFECYCLE =================

  void onScreenLoaded(Size screenSize) {
    _setMascotState(MascotState.pointing);

    // place bucket near bottom‑right by default
    _bucketPosition = Offset(screenSize.width * 0.65, screenSize.height * 0.82);
  }

  // ================= TOOL SELECTION =================

  void selectTool(DrawingTool tool) {
    _selectedTool = tool;
    notifyListeners();
  }

  // ================= DRAWING =================

  void startDrawing(Offset position) {
    if (_paths.isEmpty) {
      _setMascotState(MascotState.happy);
    }

    final path = Path()..moveTo(position.dx, position.dy);
    _currentPath = DrawPath(path: path, paint: _paintForTool());

    _paths.add(_currentPath!);
    notifyListeners();
  }

  void updateDrawing(Offset position) {
    _currentPath?.path.lineTo(position.dx, position.dy);
    notifyListeners();
  }

  void endDrawing() {
    _currentPath = null;
  }

  // ================= CLEAR =================

  void clear() {
    _paths.clear();
    _setMascotState(MascotState.pointing);
    notifyListeners();
  }

  // ================= BUCKET DRAG =================

  void startBucketDrag() {
    _isDraggingBucket = true;
    notifyListeners();
  }

  void updateBucketDrag(Offset delta, Rect drawingAreaRect) {
    // move bucket by drag delta
    _bucketPosition += delta;
    notifyListeners();

    // if bucket overlaps drawing area -> clear
    final bucketRect = Rect.fromCenter(
      center: _bucketPosition,
      width: 80,
      height: 80,
    );

    if (bucketRect.overlaps(drawingAreaRect) && _paths.isNotEmpty) {
      clear();
    }
  }

  void endBucketDrag() {
    _isDraggingBucket = false;
    notifyListeners();
  }

  // ================= CONTINUE =================

  void onContinue() {
    _setMascotState(MascotState.clapping);
  }

  // ================= INTERNAL =================

  void _setMascotState(MascotState state) {
    _mascotState = state;
    notifyListeners();
  }

  Paint _paintForTool() {
    switch (_selectedTool) {
      case DrawingTool.charcoal:
        return Paint()
          ..color = Colors.black
          ..strokeWidth = 6
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      case DrawingTool.berry:
        return Paint()
          ..color = Colors.purple
          ..strokeWidth = 7
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      case DrawingTool.ochre:
        return Paint()
          ..color = Colors.brown
          ..strokeWidth = 8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
      case DrawingTool.feather:
        return Paint()
          ..color = Colors.brown.withOpacity(0.35)
          ..strokeWidth = 12
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    }
  }
}
