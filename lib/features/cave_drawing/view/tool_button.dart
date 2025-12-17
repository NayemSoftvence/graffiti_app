import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange.shade200 : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.6),
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
