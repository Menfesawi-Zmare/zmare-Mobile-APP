import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';

class KhmertracksText extends StatelessWidget {
  const KhmertracksText(
      {super.key,
      required this.text,
      this.isBold = false,
      this.isSmall = false});
  final String text;
  final bool isBold;
  final bool isSmall;
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: context.titleLarge?.copyWith(
            fontFamily: 'Hidase',
            fontWeight: isBold ? FontWeight.w800 : FontWeight.normal,
            fontSize: isSmall
                ? context.titleMedium!.fontSize
                : context.titleLarge!.fontSize));
  }
}
