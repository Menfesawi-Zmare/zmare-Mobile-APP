import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/track/pages/track_mobile_page.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({
    super.key,
    required this.type,
  });
  final String type;
  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (p0) => TrackMobilePage(type: widget.type),
    );
  }
}
