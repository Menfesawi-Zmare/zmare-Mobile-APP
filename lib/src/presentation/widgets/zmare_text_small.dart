import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/text_style_extension.dart';

class ZmareTextSmall extends StatelessWidget {
  const ZmareTextSmall({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.titleSmall);
  }
}
