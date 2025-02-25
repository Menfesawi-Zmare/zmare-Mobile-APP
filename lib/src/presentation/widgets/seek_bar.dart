import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';

class SeekBar extends StatefulWidget {
  final AudioPlayerHandler audioHandler;
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final bool offline;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.offline,
    required this.audioHandler,
    this.bufferedPosition = Duration.zero,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _dragValue;
  bool _dragging = false;
  late SliderThemeData _sliderThemeData;
  Duration? playerDuration = const Duration();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
      rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
      trackShape: CustomTrackShape(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final value = min(
      _dragValue ?? widget.position.inMilliseconds.toDouble(),
      widget.duration.inMilliseconds.toDouble(),
    );
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   width: 56,
          //   child: Text(
          //     RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
          //             .firstMatch('$_position')
          //             ?.group(1) ??
          //         '$_position',
          //   ),
          // ),
          SizedBox(
            height: 30.0,
            child: Stack(
              children: [
                SliderTheme(
                  data: _sliderThemeData.copyWith(
                    thumbShape: HiddenThumbComponentShape(),
                    activeTrackColor:
                        Theme.of(context).iconTheme.color!.withOpacity(0.5),
                    inactiveTrackColor:
                        Theme.of(context).iconTheme.color!.withOpacity(0.3),
                    trackShape: const RectangularSliderTrackShape(),
                  ),
                  child: ExcludeSemantics(
                    child: Slider(
                      max: widget.duration.inMilliseconds.toDouble(),
                      value: min(
                        widget.bufferedPosition.inMilliseconds.toDouble(),
                        widget.duration.inMilliseconds.toDouble(),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ),
                SliderTheme(
                  data: _sliderThemeData.copyWith(
                    inactiveTrackColor: Theme.of(context).colorScheme.secondary,
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                    thumbColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Slider(
                    max: widget.duration.inMilliseconds.toDouble(),
                    value: value,
                    onChanged: (value) {
                      if (!_dragging) {
                        _dragging = true;
                      }
                      setState(() {
                        _dragValue = value;
                      });
                      widget.onChanged
                          ?.call(Duration(milliseconds: value.round()));
                    },
                    onChangeEnd: (value) {
                      widget.onChangeEnd
                          ?.call(Duration(milliseconds: value.round()));
                      _dragging = false;
                    },
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 56,
                child: Text(
                  RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                          .firstMatch('$_position')
                          ?.group(1) ??
                      '$_position',
                ),
              ),
              SizedBox(
                width: 56,
                child: Text(
                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                            .firstMatch('$_duration')
                            ?.group(1) ??
                        '$_duration',
                    textAlign: TextAlign.right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Duration get _duration => widget.duration;
  Duration get _position => widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
