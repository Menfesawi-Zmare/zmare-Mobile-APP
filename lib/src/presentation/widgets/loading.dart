import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/presentation/widgets/color_loaders.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.showMessage = true});

  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorLoader(),
        ],
      ),
    );
  }
}
