import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../../core/enum/box_types.dart';
import '../../service_locator.dart';

class KhmertracksIconTitle extends StatelessWidget {
  const KhmertracksIconTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<Box<dynamic>>(
            valueListenable: locator
                .get<Box<dynamic>>(instanceName: BoxType.settings.name)
                .listenable(keys: [themeModeKey, dynamicThemeKey]),
            builder: (context, value, child) {
              final ThemeMode themeMode = ThemeMode.values[value.get(
                themeModeKey,
                defaultValue: 0,
              )];
              // int themeValue = value.get(themeModeKey, defaultValue: 0);
              // final bool isDynamic = value.get(
              //   dynamicThemeKey,
              //   defaultValue: false,
              // );
              final Brightness brightness =
                  MediaQuery.of(context).platformBrightness;
              bool isDarkMode = brightness == Brightness.dark;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SvgPicture.asset(
                  themeMode == ThemeMode.dark
                      ? Images.zmareIconWhite
                      : themeMode == ThemeMode.light
                          ? Images.zmareIconBlack
                          : isDarkMode
                              ? Images.zmareIconWhite
                              : Images.zmareIconWhite,
                  height: 32,
                ),
              );
            }),
        Text(
          context.loc.appTitle,
          style: context.titleMedium?.copyWith(
            color: context.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
