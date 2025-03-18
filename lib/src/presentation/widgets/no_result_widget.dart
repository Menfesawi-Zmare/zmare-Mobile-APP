// ignore: unused_import
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zmare/src/core/resources/images.dart';
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
        SvgPicture.asset(
          Images.afroAygebamCross,
          height: 120,
        ),
        // const Icon(
        //   Icons.sentiment_very_satisfied_rounded,
        //   size: 72,
        // ),
        SizedBox(
          height: 30,
        ),
        KhmertracksText(
          text: context.loc.resultsNotFound,
          isBold: true,
        ),
        if (showRefresh)
          Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 20),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: context.primary),
                      shape: BoxShape.circle,
                      color: context.surfaceVariant),
                  child: Center(
                      child: Icon(
                    Icons.refresh,
                    color: context.primary,
                  )),
                ),
              )

              // OutlinedButton.icon(
              //   onPressed: onTap,
              //   icon: Center(child: Icon(Icons.refresh)),
              //   label: Text(
              //     // context.loc.refresh,
              //     '',
              //     style: context.titleSmall!.copyWith(
              //         color: context.colorScheme.onSurface,
              //         fontWeight: FontWeight.bold),
              //   ),
              //   style: OutlinedButton.styleFrom(
              //       minimumSize: const Size.square(40),
              //       side: const BorderSide(
              //         color: Colors.transparent,
              //       ),
              //       shape: const CircleBorder(),
              //       backgroundColor:
              //           Theme.of(context).colorScheme.surfaceContainerHighest,
              //       visualDensity: const VisualDensity(vertical: 1)),
              // ),
              ),
      ],
    ));
  }
}
