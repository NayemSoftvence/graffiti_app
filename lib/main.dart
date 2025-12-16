import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/drawing_controller.dart';
import 'screens/drawing_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DrawingController(),
      child: const GraffitiApp(),
    ),
  );
}

class GraffitiApp extends StatelessWidget {
  const GraffitiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DrawingScreen(),
    );
  }
}
