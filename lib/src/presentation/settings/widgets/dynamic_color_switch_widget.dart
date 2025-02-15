import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:zmare/src/utils/ext/common.dart';
import 'setting_option.dart';

class DynamicColorSwitchWidget extends StatelessWidget {
  const DynamicColorSwitchWidget({
    super.key,
    required this.settings,
  });

  final Box<dynamic> settings;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SettingsOption(
          title: context.loc.dynamicColorLabel,
          trailing: Switch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: settings.get(
              dynamicThemeKey,
              defaultValue: false,
            ),
            onChanged: (value) {
              settings.put(dynamicThemeKey, value);
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
