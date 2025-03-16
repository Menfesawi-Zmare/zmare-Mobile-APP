import "package:flutter/material.dart";
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:zmare/src/core/resources/resources.dart';

import 'package:zmare/src/utils/services/audio/download.dart';

class ColorLoader extends StatelessWidget {
  const ColorLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RiveAnimatedIcon(
        riveIcon: RiveIcon.sound,
        width: 60,
        height: 60,
        color: Theme.of(context).colorScheme.primary, // Using the primary color
        strokeWidth: 10,
        loopAnimation: true,
        onTap: () {},
        onHover: (value) {},
      ),
    );
  }
}
