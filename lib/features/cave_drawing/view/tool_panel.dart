import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodel/cave_drawing_vm.dart';
import '../model/drawing_tool.dart';
import 'tool_button.dart';

class ToolPanel extends StatelessWidget {
  final bool isLeft;

  const ToolPanel({super.key, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CaveDrawingViewModel>();

    // Centers of the carved slots for a 375×812 design
    final double topSlotY = 260.h; // first slot
    final double middleSlotY = 380.h; // second slot
    // If later you have a 3rd slot, you can add bottomSlotY ~ 500.h

    return SizedBox(
      width: 80.w,
      height: 812.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // LEFT SIDE
          if (isLeft) ...[
            Positioned(
              left: 0,
              top: topSlotY,
              child: ToolButton(
                tool: DrawingTool.charcoal,
                selectedTool: vm.selectedTool,
                onTap: () => vm.selectTool(DrawingTool.charcoal),
                icon: Image.asset('assets/icons/charcoal.png', width: 56.w),
              ),
            ),
            Positioned(
              left: 0,
              top: middleSlotY,
              child: ToolButton(
                tool: DrawingTool.berry,
                selectedTool: vm.selectedTool,
                onTap: () => vm.selectTool(DrawingTool.berry),
                icon: Image.asset('assets/icons/berry.png', width: 56.w),
              ),
            ),
          ],

          // RIGHT SIDE
          if (!isLeft) ...[
            Positioned(
              right: 0,
              top: topSlotY,
              child: ToolButton(
                tool: DrawingTool.ochre,
                selectedTool: vm.selectedTool,
                onTap: () => vm.selectTool(DrawingTool.ochre),
                icon: Image.asset('assets/icons/rock.png', width: 56.w),
              ),
            ),
            Positioned(
              right: 0,
              top: middleSlotY,
              child: ToolButton(
                tool: DrawingTool.feather,
                selectedTool: vm.selectedTool,
                onTap: () => vm.selectTool(DrawingTool.feather),
                icon: Image.asset('assets/icons/feather.png', width: 56.w),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
