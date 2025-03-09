import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmare/src/utils/ext/text_style_extension.dart';

class KhmertracksTitle extends StatelessWidget {
  const KhmertracksTitle(
    this.title, {
    super.key,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });
  final String? title;
  final int? maxLines;
  final TextOverflow? overflow;
  @override
  Widget build(BuildContext context) {
    return Text(title!,
        overflow: overflow,
        maxLines: maxLines,
        style: context.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.notoSansEthiopic().fontFamily));
  }
}
