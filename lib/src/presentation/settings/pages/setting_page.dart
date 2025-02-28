import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/settings/widgets/app_font_changer.dart';
import 'package:zmare/src/presentation/settings/widgets/app_language_changer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/theme_mode.dart';
import 'package:zmare/src/presentation/settings/pages/personalize_page.dart';
import 'package:zmare/src/presentation/settings/widgets/circular_play_button_widget.dart';
import 'package:zmare/src/presentation/settings/widgets/settings_color_picker_widget.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/choose_theme_mode_widget.dart';
import '../widgets/setting_option.dart';
import '../widgets/settings_group_card.dart';
import '../widgets/version_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = locator.get<Box<dynamic>>(
      instanceName: BoxType.settings.name,
    );
    final currentTheme = ThemeMode.values[locator
        .get<Box<dynamic>>(instanceName: BoxType.settings.name)
        .get(themeModeKey, defaultValue: 0)];
    String? tg = settings.get(telegramUrl, defaultValue: null);
    String? fb = settings.get(facebookUrl, defaultValue: null);
    String? tw = settings.get(twitterUrl, defaultValue: null);
    String? yt = settings.get(youtubeUrl, defaultValue: null);
    String? ig = settings.get(instagramUrl, defaultValue: null);
    String? appUrl = settings.get(
        Platform.isAndroid ? playStoreUrl : appStoreUrl,
        defaultValue: null);
    return Scaffold(
      appBar: context.materialYouAppBar(
        context.loc.settingsLabel,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // SettingsGroup(
          //   title: context.loc.colorsUI,
          //   options: [
          //     SettingsColorPickerWidget(settings: settings),
          //     Divider(color: Colors.grey.withOpacity(0.2)),
          //     SettingsOption(
          //       icon: FluentIcons.dark_theme_24_regular,
          //       title: context.loc.chooseTheme,
          //       subtitle: currentTheme.themeName(context),
          //       onTap: () {
          //         showModalBottomSheet(
          //           useRootNavigator: true,
          //           constraints: BoxConstraints(
          //             maxWidth: MediaQuery.of(context).size.width >= 700
          //                 ? 700
          //                 : double.infinity,
          //           ),
          //           shape: const RoundedRectangleBorder(
          //             borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(16),
          //               topRight: Radius.circular(16),
          //             ),
          //           ),
          //           context: context,
          //           builder: (_) => ChooseThemeModeWidget(
          //             currentTheme: currentTheme,
          //           ),
          //         );
          //       },
          //     ),
          //     Divider(color: Colors.grey.withOpacity(0.2)),
          //     const CircularPlayButtonWidget(),
          //     Divider(color: Colors.grey.withOpacity(0.2)),
          //     SettingsOption(
          //         icon: Icons.hdr_strong_rounded,
          //         title: context.loc.personalize,
          //         subtitle: context.loc.personalizeDes,
          //         onTap: () =>
          //             Navigator.of(context).push(MaterialPageRoute<void>(
          //                 builder: (BuildContext context) {
          //                   return const PersonalizePage();
          //                 },
          //                 fullscreenDialog: true)))
          //   ],
          // ),
          SettingsGroup(title: context.loc.langAndFont, options: [
            AppLanguageChanger(settings: settings),
            // const Divider(),
            // AppFontChanger(settings: settings),
          ]),
          Visibility(
            visible: appUrl != null ? true : false,
            child: Column(
              children: [
                SettingsGroup(
                  title: context.loc.supportDevelopment,
                  options: [
                    SettingsOption(
                      icon: FluentIcons.star_24_regular,
                      title: context.loc.appRateLabel,
                      subtitle: Platform.isAndroid
                          ? context.loc.androidAppRateDescLabel
                          : context.loc.iOSAppRateDescLabel,
                      onTap: () => launchUrl(
                        Uri.parse(appUrl!),
                        mode: LaunchMode.externalApplication,
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.2)),
                    SettingsOption(
                        icon: FluentIcons.share_24_regular,
                        title: context.loc.share,
                        subtitle: context.loc.shareAppSub,
                        onTap: () => Share.share(
                              '${context.loc.appTitle} • ${context.loc.shareAppSub} $appUrl',
                              subject: context.loc.appTitle,
                            ))
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: ig == null &&
                    tg == null &&
                    yt == null &&
                    fb == null &&
                    tw == null
                ? false
                : true,
            child: SettingsGroup(
              title: context.loc.socialLinksLabel,
              options: [
                Visibility(
                  visible: fb != null ? true : false,
                  child: SettingsOption(
                    icon: FontAwesomeIcons.facebook,
                    title: context.loc.facebook,
                    subtitle: context.loc.checkOutOurFacebook,
                    onTap: () => launchUrl(
                      Uri.parse(fb!),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
                Visibility(
                  visible: tw != null ? true : false,
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SettingsOption(
                        icon: FontAwesomeIcons.twitter,
                        title: context.loc.twitter,
                        subtitle: context.loc.checkOutOurTwitter,
                        onTap: () => launchUrl(
                          Uri.parse(tw!),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: ig != null ? true : false,
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SettingsOption(
                        icon: FontAwesomeIcons.instagram,
                        title: context.loc.instagram,
                        subtitle: context.loc.checkOutOurInstagram,
                        onTap: () => launchUrl(
                          Uri.parse(ig!),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: yt != null ? true : false,
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SettingsOption(
                        icon: FontAwesomeIcons.youtube,
                        title: context.loc.youTube,
                        subtitle: context.loc.checkOutOurYoutube,
                        onTap: () => launchUrl(
                          Uri.parse(yt!),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: tg != null ? true : false,
                  child: Column(
                    children: [
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      SettingsOption(
                        icon: FontAwesomeIcons.telegram,
                        title: context.loc.telegramLabel,
                        subtitle: context.loc.telegramGroupLabel,
                        onTap: () => launchUrl(
                          Uri.parse(tg!),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SettingsGroup(title: context.loc.othersLabel, options: [
            const VersionWidget(),
            Divider(color: Colors.grey.withOpacity(0.2)),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: KhmertracksTitle(context.loc.appTitle),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
