import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/drawing_tool.dart';

class ToolButton extends StatelessWidget {
  final DrawingTool tool;
  final DrawingTool selectedTool;
  final VoidCallback onTap;
  final Widget icon;

  const ToolButton({
    super.key,
    required this.tool,
    required this.selectedTool,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = tool == selectedTool;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 9.sp),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 210, 158, 78).withValues(alpha: 0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: icon,
      ),
    );
  }
}
