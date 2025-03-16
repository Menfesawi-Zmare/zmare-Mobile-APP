import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';

class NoSubscribeWidget extends StatelessWidget {
  const NoSubscribeWidget({super.key, this.onTap, this.showRefresh = false});
  final VoidCallback? onTap;
  final bool showRefresh;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/mesenko.svg",
            // ignore: deprecated_member_use
            color: Colors.white,
          ),
          KhmertracksText(
            text: context.loc.newMusicsRightToYou,
            isBold: true,
          ),
          const SizedBox(
            height: 20,
          ),
          KhmertracksSubTitle(
            context.loc.newMusicsRightToYouSub,
            maxLines: 5,
            center: true,
          ),
          if (showRefresh)
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 20),
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
      )),
    );
  }
}
