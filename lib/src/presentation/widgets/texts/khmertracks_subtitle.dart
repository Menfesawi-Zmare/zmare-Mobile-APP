import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmare/src/utils/ext/text_style_extension.dart';

class KhmertracksSubTitle extends StatelessWidget {
  const KhmertracksSubTitle(this.title,
      {super.key, this.maxLines = 1, this.center = false});
  final String? title;
  final int? maxLines;
  final bool center;
  @override
  Widget build(BuildContext context) {
    return Text(title!,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: center ? TextAlign.center : TextAlign.start,
        style: context.bodySmall?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: GoogleFonts.notoSansEthiopic().fontFamily));
  }
}
