import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/data/playlist/model/create_playlist_model.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlists_request_model.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_bottom_sheet.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';
import 'package:flutter_music_pro/src/presentation/widgets/textinput_dialog.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class ModalAddPlaylistTracks extends StatefulWidget {
  const ModalAddPlaylistTracks({super.key, required this.onCallBack});
  final Function(bool isReload) onCallBack;
  @override
  State<ModalAddPlaylistTracks> createState() => _ModalAddPlaylistTracksState();
}

class _ModalAddPlaylistTracksState extends State<ModalAddPlaylistTracks> {
  List _historyTracks = [];
  List<bool>? listCheckBox = [];
  final AuthBloc authBloc = locator.get<AuthBloc>();
  List<int> listIndex = [];
  List<int> trackIdList = [];
  @override
  void initState() {
    _historyTracks = Hive.box(BoxType.cache.name)
        .get('recentSongs', defaultValue: []) as List;
    // ignore: unused_local_variable
    for (var e in _historyTracks) {
      listCheckBox!.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocListener(
        bloc: authBloc,
        listener: (context, state) {
          if (state is CreatePlaylistState) {
            for (var e in trackIdList) {
              authBloc.add(AddToPlaylistEvent(PlaylistsRequestModel(
                  trackId: e,
                  playlistId: state.createPlaylistResponse.data!.id)));
            }
            widget.onCallBack(true);
            context.pop();
          }
        },
        child: Scaffold(
            appBar: context.materialYouAppBar(context.loc.addTracks,
                leadingWidget: IconButton(
                    onPressed: () {
                      if (listCheckBox!
                          .where((element) => element == true)
                          .isNotEmpty) {
                        khmertracksAlertDialog(
                          context,
                          title: KhmertracksText(
                            text: context.loc.discardPlaylist,
                          ),
                          child: Text(context.loc.discardPlaylistDetail,
                              style: context.titleMedium),
                          confirmationButton: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            onPressed: () {
                              context.pop();
                              context.pop();
                            },
                            child: Text(context.loc.yes,
                                style: TextStyle(
                                    color: context.colorScheme.onPrimary)),
                          ),
                        );
                        return;
                      }
                      context.pop();
                    },
                    icon: const Icon(Icons.close)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: TextButton(
                      onPressed: () {
                        listCheckBox!.asMap().forEach((index, value) {
                          if (value == true) {
                            setState(() {
                              trackIdList
                                  .add(int.parse(_historyTracks[index]['id']));
                            });
                          }
                        });
                        showTextInputDialog(
                          context: context,
                          keyboardType: TextInputType.name,
                          title: context.loc.createNewPlaylist,
                          onSubmitted: (String value) async {
                            final RegExp avoid = RegExp(r'[\.\*\:\"\?#/;\|]');
                            value.replaceAll(avoid, '').replaceAll('  ', ' ');
                            authBloc.add(CreatePlaylistEvent(
                                CreatePlaylistModel(name: value, public: 1)));
                          },
                        );
                      },
                      child: Text(context.loc.next,
                          style: context.titleMedium?.copyWith(
                              color: Colors.blue, fontWeight: FontWeight.w600)),
                    ),
                  )
                ]),
            body: ListView(children: [
              ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: 0),
                title: Text(context.loc.recentlyPlayed,
                    style: context.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                trailing: Text(
                    context.loc.tracksSelected(listCheckBox!
                        .where((element) => element == true)
                        .length),
                    style: context.titleMedium),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _historyTracks.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        dense: true,
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, right: 16.0),
                        visualDensity:
                            const VisualDensity(vertical: 2, horizontal: -2),
                        controlAffinity: ListTileControlAffinity.trailing,
                        secondary: SizedBox.square(
                          dimension: 56,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: KhmertracksImage(
                                imageUrl: _historyTracks[index]['image'],
                                placeholderImage: Images.defalutSongCover,
                              ),
                            ),
                          ),
                        ),
                        title: Text(_historyTracks[index]["title"],
                            maxLines: 2, style: context.titleSmall?.copyWith()),
                        value: listCheckBox![index],
                        subtitle: Text(_historyTracks[index]["artist"],
                            style: context.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .color)),
                        onChanged: (val) {
                          setState(() {
                            listCheckBox![index] = val!;
                          });
                        });
                  }),
            ])),
      ),
    );
  }
}
