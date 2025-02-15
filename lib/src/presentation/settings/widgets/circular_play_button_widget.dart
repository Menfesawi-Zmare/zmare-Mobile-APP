import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:zmare/src/service_locator.dart';

class CircularPlayButtonWidget extends StatefulWidget {
  const CircularPlayButtonWidget({super.key});

  @override
  State<CircularPlayButtonWidget> createState() =>
      _CircularPlayButtonWidgetState();
}

class _CircularPlayButtonWidgetState extends State<CircularPlayButtonWidget> {
  final settings = locator<Box<dynamic>>(instanceName: BoxType.settings.name);
  late bool isSelected =
      settings.get(circularPlayButtonKey, defaultValue: false);
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(FluentIcons.play_circle_28_regular),
      title: KhmertracksTitle(
        context.loc.circularPlayButton,
      ),
      onChanged: (bool value) async {
        setState(() {
          isSelected = value;
        });
        settings.put(circularPlayButtonKey, value);
      },
      value: isSelected,
    );
  }
}
