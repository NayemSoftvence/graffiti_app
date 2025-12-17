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
    // init done after first frame so MediaQuery is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      context.read<CaveDrawingViewModel>().onScreenLoaded(size);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CaveDrawingViewModel>();
    final size = MediaQuery.of(context).size;

    // === Define drawing area (must match visually with slab) ===
    final double drawingTop = 150.h; // tune if needed
    final double drawingLeft = 32.w;
    final double drawingRight = size.width - 32.w;
    final double drawingBottom = size.height - 260.h;

    _drawingAreaRect = Rect.fromLTRB(
      drawingLeft,
      drawingTop,
      drawingRight,
      drawingBottom,
    );

    return Scaffold(
      body: Stack(
        children: [
          // 🪨 Cave background with slab
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/stone_wall.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🔝 Title
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

          // ✏️ Drawing area (clipped to slab)
          Positioned(
            top: drawingTop,
            left: drawingLeft,
            right: size.width - drawingRight,
            bottom: size.height - drawingBottom,
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

          // 🎨 Individual tools (left side)
          Positioned(
            left: 10.w,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 80.w,
              height: 812.h,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 260.h,
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

          // 🎨 Individual tools (right side)
          Positioned(
            right: 10.w,
            top: 0,
            bottom: 0,
            child: SizedBox(
              width: 80.w,
              height: 812.h,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 260.h,
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

          // 🧸 Mascot on right side
          const _RightSideMascot(),

          // 🔘 Continue button (center bottom)
          Positioned(
            bottom: 110.h,
            left: 60.w,
            right: 60.w,
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

          // 🔊 Replay Sounds (left bottom)
          Positioned(
            bottom: 32.h,
            left: 50.w,
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

          // 🪣 Draggable Clear Wall bucket
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

          // Label for Clear Wall (static text)
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

/// Positions the existing MascotWidget on the right side,
/// roughly like the reference mockup.
class _RightSideMascot extends StatelessWidget {
  const _RightSideMascot();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20.w,
      bottom: 130.h,
      child: SizedBox(width: 160.w, height: 160.w, child: const MascotWidget()),
    );
  }
}
