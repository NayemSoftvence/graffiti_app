import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../viewmodel/cave_drawing_vm.dart';
import '../model/mascot_state.dart';

class MascotWidget extends StatelessWidget {
  const MascotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CaveDrawingViewModel>().mascotState;

    return Positioned(
      bottom: 120,
      left: 20,
      child: SizedBox(
        width: 140,
        height: 140,
        child: Lottie.asset(_assetForState(state)),
      ),
    );
  }

  String _assetForState(MascotState state) {
    switch (state) {
      case MascotState.idle:
        return 'assets/mascot/idle.json';
      case MascotState.pointing:
        return 'assets/mascot/pointing.json';
      case MascotState.happy:
        return 'assets/mascot/happy.json';
      case MascotState.clapping:
        return 'assets/mascot/clapping.json';
    }
  }
}
