import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';

class FlutterMusicProLyricUI extends LyricUI {
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;
  TextStyle? textStyle;
  FlutterMusicProLyricUI(
      {this.defaultSize = 18,
      this.defaultExtSize = 14,
      this.otherMainSize = 16,
      this.bias = 0.5,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlight = true,
      this.highlightDirection = HighlightDirection.LTR,
      this.textStyle});

  FlutterMusicProLyricUI.clone(FlutterMusicProLyricUI flutterMusicProLyricUI)
      : this(
          defaultSize: flutterMusicProLyricUI.defaultSize,
          defaultExtSize: flutterMusicProLyricUI.defaultExtSize,
          otherMainSize: flutterMusicProLyricUI.otherMainSize,
          bias: flutterMusicProLyricUI.bias,
          lineGap: flutterMusicProLyricUI.lineGap,
          inlineGap: flutterMusicProLyricUI.inlineGap,
          lyricAlign: flutterMusicProLyricUI.lyricAlign,
          lyricBaseLine: flutterMusicProLyricUI.lyricBaseLine,
          highlight: flutterMusicProLyricUI.highlight,
          highlightDirection: flutterMusicProLyricUI.highlightDirection,
        );

  @override
  TextStyle getPlayingExtTextStyle() => textStyle!.copyWith(
        color: Colors.grey[300],
        fontSize: defaultExtSize,
        fontFamily: 'Hidase',
      );

  @override
  TextStyle getOtherExtTextStyle() => textStyle!.copyWith(
      color: Colors.grey[300], fontSize: defaultExtSize, fontFamily: 'Hidase');

  @override
  TextStyle getOtherMainTextStyle() =>
      textStyle!.copyWith(fontSize: otherMainSize, fontFamily: 'Hidase');

  @override
  TextStyle getPlayingMainTextStyle() => textStyle!.copyWith(
      fontSize: defaultSize,
      fontFamily: 'Hidase',
      fontWeight: FontWeight.w900,
      color: Colors.amber);
  @override
  bool initAnimation() => true;

  @override
  bool enableLineAnimation() => true;

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;
}
