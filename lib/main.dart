import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'features/cave_drawing/view/cave_drawing_screen.dart';
import 'features/cave_drawing/viewmodel/cave_drawing_vm.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CaveDrawingViewModel(),
      child: const GraffitiApp(),
    ),
  );
}

class GraffitiApp extends StatelessWidget {
  const GraffitiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // your base design size
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(debugShowCheckedModeBanner: false, home: child);
      },
      child: const CaveDrawingScreen(),
    );
  }
}
