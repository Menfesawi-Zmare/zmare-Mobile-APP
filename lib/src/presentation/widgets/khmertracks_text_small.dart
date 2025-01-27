import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/text_style_extension.dart';

class KhmertracksTextSmall extends StatelessWidget {
  const KhmertracksTextSmall({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text, style: context.titleSmall);
  }
}