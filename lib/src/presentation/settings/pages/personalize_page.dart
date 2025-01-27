import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/grid_type.dart';
import 'package:flutter_music_pro/src/presentation/settings/widgets/extra_controls_widget.dart';
import 'package:flutter_music_pro/src/presentation/settings/widgets/setting_option.dart';
import 'package:flutter_music_pro/src/presentation/settings/widgets/settings_group_card.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

class PersonalizePage extends StatefulWidget {
  const PersonalizePage({super.key});

  @override
  State<PersonalizePage> createState() => _PersonalizePageState();
}

class _PersonalizePageState extends State<PersonalizePage> {
  late int artistGridIndex =
      settings.get(artistGridKey, defaultValue: GridType.circular.toIndex);
  late int playlistGridIndex =
      settings.get(playlistGridKey, defaultValue: GridType.tinyCard.toIndex);
  late int albumGridIndex =
      settings.get(albumGridKey, defaultValue: GridType.coloredCard.toIndex);
  late int productionGridIndex = settings.get(productionGridKey,
      defaultValue: GridType.squareCard.toIndex);

  void chooseGridStyle(String title, int selectedIndex, int type) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: KhmertracksText(text: title),
          contentPadding: const EdgeInsets.all(10.0),
          children: [
            ...GridType.values.map(
              (e) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                trailing: e.toIndex == selectedIndex
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary)
                    : null,
                title: KhmertracksTitle(
                  e.name(context),
                ),
                onTap: () {
                  setState(() {
                    switch (type) {
                      case 0:
                        artistGridIndex = e.toIndex;
                        settings.put(artistGridKey, artistGridIndex);
                        break;
                      case 1:
                        playlistGridIndex = e.toIndex;
                        settings.put(playlistGridKey, playlistGridIndex);
                        break;
                      case 2:
                        albumGridIndex = e.toIndex;
                        settings.put(albumGridKey, albumGridIndex);
                        break;
                      case 3:
                        productionGridIndex = e.toIndex;
                        settings.put(productionGridKey, productionGridIndex);
                        break;
                      default:
                    }
                  });
                  context.pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: context.materialYouAppBar(
        context.loc.personalize,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SettingsGroup(
            title: context.loc.home,
            options: [
              SettingsOption(
                  icon: Icons.person_outline_rounded,
                  title: context.loc.artistGrid,
                  subtitle: GridType.values[artistGridIndex].name(context),
                  onTap: () => chooseGridStyle(
                      context.loc.artistGrid, artistGridIndex, 0)),
              Divider(color: Colors.grey.withOpacity(0.2)),
              SettingsOption(
                  icon: Icons.featured_play_list_outlined,
                  title: context.loc.playlistGrid,
                  subtitle: GridType.values[playlistGridIndex].name(context),
                  onTap: () => chooseGridStyle(
                      context.loc.playlistGrid, playlistGridIndex, 1)),
              Divider(color: Colors.grey.withOpacity(0.2)),
              SettingsOption(
                  icon: Icons.album_outlined,
                  title: context.loc.albumGrid,
                  subtitle: GridType.values[albumGridIndex].name(context),
                  onTap: () => chooseGridStyle(
                      context.loc.albumGrid, albumGridIndex, 2)),
              Divider(color: Colors.grey.withOpacity(0.2)),
              SettingsOption(
                  icon: Icons.library_music_outlined,
                  title: context.loc.productionGrid,
                  subtitle: GridType.values[productionGridIndex].name(context),
                  onTap: () => chooseGridStyle(
                      context.loc.productionGrid, productionGridIndex, 3))
            ],
          ),
          SettingsGroup(
              title: context.loc.miniPlayer,
              options: const [ExtraControlsWidget()])
        ],
      ),
    );
  }
}
