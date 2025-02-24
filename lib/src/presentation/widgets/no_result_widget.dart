import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';

class NoResultWidget extends StatelessWidget {
  const NoResultWidget({super.key, this.onTap, this.showRefresh = false});
  final VoidCallback? onTap;
  final bool showRefresh;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.sentiment_very_satisfied_rounded,
          size: 72,
        ),
        KhmertracksText(
          text: context.loc.resultsNotFound,
          isBold: true,
        ),
        if (showRefresh)
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 20),
            child: OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(
                FluentIcons.arrow_sync_24_regular,
                color: Theme.of(context).colorScheme.onSurface,
                size: 26,
              ),
              label: Text(
                context.loc.refresh,
                style: context.titleSmall!.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.square(40),
                  side: const BorderSide(
                    color: Colors.transparent,
                  ),
                  shape: const StadiumBorder(),
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  visualDensity: const VisualDensity(vertical: 1)),
            ),
          ),
      ],
    ));
  }
}
