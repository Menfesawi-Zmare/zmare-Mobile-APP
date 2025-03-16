import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/modal/modal_report.dart';

class ReportButton extends StatefulWidget {
  const ReportButton(
      {super.key, required this.mediaItem, required this.dominantColor});

  final MediaItem mediaItem;
  final Color dominantColor;
  @override
  State<ReportButton> createState() => _ReportButtonState();
}

class _ReportButtonState extends State<ReportButton> {
  bool show = false;
  final accountJson = account.get(accountDetail, defaultValue: '');
  @override
  void initState() {
    super.initState();
    if (accountJson != '') {
      show = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? IconButton(
            icon: Icon(FluentIcons.error_circle_24_regular,
                color: Theme.of(context).colorScheme.onSurface),
            tooltip: context.loc.reportTrack(widget.mediaItem.title),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return ModalReport(
                  mediaItem: widget.mediaItem,
                  dominantColor: widget.dominantColor,
                );
              }));
            },
          )
        : const SizedBox.shrink();
  }
}
