import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../viewmodel/cave_drawing_vm.dart';
import '../painter/cave_wall_painter.dart';
import '../model/drawing_tool.dart';
import 'tool_button.dart';
import 'mascot_widget.dart';

class CaveDrawingScreen extends StatefulWidget {
  const CaveDrawingScreen({super.key});

  @override
  State<CaveDrawingScreen> createState() => _CaveDrawingScreenState();
}

class _CaveDrawingScreenState extends State<CaveDrawingScreen> {
  late Rect _drawingAreaRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      context.read<CaveDrawingViewModel>().onScreenLoaded(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CaveDrawingViewModel>();
    final size = MediaQuery.of(context).size;

    // === Drawing area aligned to slab; using BoxFit.cover logic ===
    const double designW = 375.0;
    const double designH = 812.0;
    const double slabTopY_design = 230.0; // Top Y in design coordinates
    const double slabBottomY_design =
        582.0; // Bottom Y in design coordinates (812 - 230)

    final double screenW = size.width;
    final double screenH = size.height;
    final double screenAspect = screenW / screenH;
    const double designAspect = designW / designH;

    double scale;
    double offsetY;

    if (screenAspect > designAspect) {
      // Screen is wider than design (e.g. 16:9 vs 9:19.5) -> Scale by width
      scale = screenW / designW;
      // Image is vertically centered, so offset is (screenH - scaledH) / 2
      offsetY = (screenH - designH * scale) / 2;
    } else {
      // Screen is taller/narrower -> Scale by height
      scale = screenH / designH;
      offsetY =
          0; // Usually 0 if matching height, or calculated if BoxFit.cover behavior implies horizontal cropping
      // For BoxFit.cover, if screen is taller, we scale by height.
      // Actually, if screen is *taller* (aspect < designAspect), scale = screenH / designH.
      // Then width is scaled, and centered horizontally. Vertical offset is 0.
    }

    // Calculate final top/bottom in screen coordinates
    // We want the drawing rect top/bottom to match the visual slab
    final double drawingTop = offsetY + (slabTopY_design * scale);
    final double drawingBottomPos = offsetY + (slabBottomY_design * scale);
    // Positioned takes 'bottom' as distance from bottom, so:
    final double drawingBottom = screenH - drawingBottomPos;

    final double drawingLeft = 90.w;
    // originalDrawingRight is used for the logical Rect to match the touch area.
    final double originalDrawingRight = size.width.w - 135.w;

    _drawingAreaRect = Rect.fromLTRB(
      drawingLeft,
      drawingTop,
      originalDrawingRight,
      drawingBottomPos, // Rect uses (left, top, right, bottom_coordinate)
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/stone_wall.png',
              fit: BoxFit.cover,
            ),
          ),

          // Title
          Positioned(
            top: 40.h,
            left: 20.w,
            right: 20.w,
            child: Text(
              "Let’s Scribble Like\nthe First Artists!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                color: Colors.brown.shade900,
                shadows: const [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),

          // Drawing area
          Positioned(
            top: drawingTop,
            left: drawingLeft,
            right:
                drawingLeft, // Keeping original horizontal margins to avoid regression
            bottom: drawingBottom,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.r),
              child: GestureDetector(
                onPanStart: (d) => vm.startDrawing(d.localPosition),
                onPanUpdate: (d) => vm.updateDrawing(d.localPosition),
                onPanEnd: (_) => vm.endDrawing(),
                child: CustomPaint(
                  painter: CaveWallPainter(vm.paths),
                  size: Size.infinite,
                ),
              ),
            ),
          ),

          // LEFT tools
          Positioned(
            left: 0.w,
            top: 35.h,
            bottom: 0,
            child: SizedBox(
              width: 80.w,
              height: 812.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 270.h,
                    child: ToolButton(
                      tool: DrawingTool.charcoal,
                      selectedTool: vm.selectedTool,
                      onTap: () => vm.selectTool(DrawingTool.charcoal),
                      icon: Image.asset(
                        'assets/icons/charcoal.png',
                        width: 56.w,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 380.h,
                    child: ToolButton(
                      tool: DrawingTool.berry,
                      selectedTool: vm.selectedTool,
                      onTap: () => vm.selectTool(DrawingTool.berry),
                      icon: Image.asset('assets/icons/berry.png', width: 56.w),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT tools
          Positioned(
            right: 0.w,
            top: 40.h,
            bottom: 0,
            child: SizedBox(
              width: 80.w,
              height: 812.h,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 270.h,
                    child: ToolButton(
                      tool: DrawingTool.ochre,
                      selectedTool: vm.selectedTool,
                      onTap: () => vm.selectTool(DrawingTool.ochre),
                      icon: Image.asset('assets/icons/rock.png', width: 56.w),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 380.h,
                    child: ToolButton(
                      tool: DrawingTool.feather,
                      selectedTool: vm.selectedTool,
                      onTap: () => vm.selectTool(DrawingTool.feather),
                      icon: Image.asset(
                        'assets/icons/feather.png',
                        width: 56.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Mascot on the right side
          Positioned(
            right: -30.w,
            bottom: 100.h,
            child: SizedBox(
              width: 150.w,
              height: 150.w,
              child: const MascotWidget(),
            ),
          ),

          // Continue button
          Positioned(
            bottom: 70.h,
            left: 70.w,
            right: 70.w,
            child: GestureDetector(
              onTap: vm.canContinue ? vm.onContinue : null,
              child: Image.asset(
                vm.canContinue
                    ? 'assets/buttons/continue_active.png'
                    : 'assets/buttons/continue_disabled.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Replay Sounds (left bottom)
          Positioned(
            bottom: 32.h,
            left: 10.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 72.w,
                  height: 72.w,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    splashRadius: 40.r,
                    icon: Image.asset(
                      'assets/icons/speaker.png',
                      fit: BoxFit.contain,
                    ),
                    onPressed: () {
                      // hook audio later
                    },
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Replay Sounds",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),

          // Draggable Clear Wall bucket
          Positioned(
            left: vm.bucketPosition.dx - 40.w,
            top: vm.bucketPosition.dy - 40.w,
            child: GestureDetector(
              onPanStart: (_) => vm.startBucketDrag(),
              onPanUpdate: (details) {
                vm.updateBucketDrag(details.delta, _drawingAreaRect);
              },
              onPanEnd: (_) => vm.endBucketDrag(),
              child: SizedBox(
                width: 80.w,
                height: 80.w,
                child: Image.asset(
                  'assets/icons/bucket.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Label for Clear Wall
          Positioned(
            bottom: 32.h,
            right: 60.w,
            child: Text(
              "Clear Wall",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
