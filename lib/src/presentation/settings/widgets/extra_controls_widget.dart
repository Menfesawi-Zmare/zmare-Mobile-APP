import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:zmare/src/service_locator.dart';

class ExtraControlsWidget extends StatefulWidget {
  const ExtraControlsWidget({super.key});

  @override
  State<ExtraControlsWidget> createState() => _ExtraControlsWidgetState();
}

class _ExtraControlsWidgetState extends State<ExtraControlsWidget> {
  final settings = locator<Box<dynamic>>(instanceName: BoxType.settings.name);
  late bool isSelected = settings.get(extraControlsKey, defaultValue: false);
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.play_arrow_rounded),
      title: KhmertracksTitle(
        context.loc.extraControls,
      ),
      subtitle: KhmertracksSubTitle(
        context.loc.extraControlsSub,
      ),
      onChanged: (bool value) async {
        setState(() {
          isSelected = value;
        });
        settings.put(extraControlsKey, value);
      },
      value: isSelected,
    );
  }
}
