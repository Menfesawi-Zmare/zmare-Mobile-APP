import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';

class KhmertracksIconTitle extends StatelessWidget {
  const KhmertracksIconTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Image.asset(
            Images.logoIcon,
            height: 32,
          ),
        ),
        Text(
          context.loc.appTitle,
          style: context.titleMedium?.copyWith(
            color: context.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
