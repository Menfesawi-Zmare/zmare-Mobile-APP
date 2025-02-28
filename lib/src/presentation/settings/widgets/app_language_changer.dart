import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:hive_flutter/adapters.dart';

class AppLanguageChanger extends StatelessWidget {
  const AppLanguageChanger({super.key, required this.settings});
  final Box<dynamic> settings;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settings.listenable(
        keys: [
          appLanguageKey,
        ],
      ),
      builder: (context, value, child) {
        final String code = value.get(appLanguageKey, defaultValue: 'en');
        return ListTile(
          leading: Icon(
            FluentIcons.local_language_24_regular,
            color: context.onSurfaceVariant,
          ),
          onTap: () {
            showModalBottomSheet(
              useRootNavigator: true,
              context: context,
              isScrollControlled: true,
              isDismissible: true,
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width >= 700
                    ? 700
                    : double.infinity,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  maxChildSize: 1,
                  expand: false,
                  builder: (context, scrollController) {
                    return SafeArea(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Text(
                              context.loc.chooseAppLanguage,
                              style: context.titleLarge,
                            ),
                          ),
                          ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: Languages.languages.length,
                            itemBuilder: (context, index) {
                              final LanguageEntity entity =
                                  Languages.languages[index];
                              return ListTile(
                                onTap: () => value
                                    .put(appLanguageKey, entity.code)
                                    .then((value) => Navigator.pop(context)),
                                title: Text(entity.value),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    context.loc.cancel,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 16.0, bottom: 16),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Text(context.loc.ok),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          title: KhmertracksTitle(context.loc.chooseAppLanguage),
          subtitle: KhmertracksSubTitle(Languages.languages
              .firstWhere((element) => element.code == code)
              .value),
        );
      },
    );
  }
}

class LanguageEntity {
  final String code;
  final String value;

  const LanguageEntity({
    required this.code,
    required this.value,
  });
}

class Languages {
  const Languages._();

  static const languages = [
    LanguageEntity(code: 'en', value: 'English'),
    LanguageEntity(code: 'am', value: 'አማርኛ'),
  ];
}
