import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/data/playlist/model/create_playlist_model.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/helper/mediaitem_converter.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlists_request_model.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/textinput_dialog.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class PlaylistsBottomSheet extends StatefulWidget {
  const PlaylistsBottomSheet({super.key, required this.songList});
  final ItemSongModel songList;
  @override
  State<PlaylistsBottomSheet> createState() => _PlaylistsBottomSheetState();
}

class _PlaylistsBottomSheetState extends State<PlaylistsBottomSheet> {
  MediaItem? mediaItem;
  final AuthBloc authBloc = locator.get<AuthBloc>();
  List<Playlist>? playlist = [];
  List<bool>? listCheckBox = [];
  @override
  void initState() {
    mediaItem = MediaItemConverter.mapToMediaItem(widget.songList.toJson());
    authBloc.add(CheckTrackInPlaylistsEvent(int.parse(mediaItem!.id)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 5),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 10),
            title: Text(context.loc.saveMusicTo, style: context.titleMedium),
            trailing: TextButton.icon(
                label: Text(context.loc.createNewPlaylist,
                    style: context.titleSmall?.copyWith(color: Colors.blue)),
                onPressed: () {
                  showTextInputDialog(
                    context: context,
                    keyboardType: TextInputType.name,
                    title: context.loc.createNewPlaylist,
                    onSubmitted: (String value) async {
                      final RegExp avoid = RegExp(r'[\.\\\*\:\"\?#/;\|]');
                      value.replaceAll(avoid, '').replaceAll('  ', ' ');
                      authBloc.add(CreatePlaylistEvent(
                          CreatePlaylistModel(name: value, public: 1)));
                    },
                  );
                },
                icon: const Icon(Icons.add, color: Colors.blue)),
          ),
          const Divider(),
          BlocProvider(
              create: (context) => authBloc,
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is CreatePlaylistState) {
                    if (state.createPlaylistResponse.status == true) {
                      playlist!.add(state.createPlaylistResponse.data!);
                      listCheckBox!
                          .add(state.createPlaylistResponse.data!.active!);
                    }
                  }
                  if (state is GetAllPlaylistsState) {
                    if (state.all.playlist!.isNotEmpty) {
                      for (var element in state.all.playlist!) {
                        playlist!.add(element);
                        listCheckBox!.add(element.active!);
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (state is Loading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is NoData) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: KhmertracksText(text: context.loc.noPlaylists),
                      ),
                    );
                  }
                  return playlist!.isNotEmpty
                      ? SizedBox(
                          height: 300,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: playlist!.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
                                    contentPadding:
                                        const EdgeInsets.only(right: 16),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: Text(playlist![index].name!,
                                        style:
                                            context.titleMedium?.copyWith()),
                                    value: listCheckBox![index],
                                    secondary: playlist![index].public == 0
                                        ? const Icon(Icons.lock)
                                        : const Icon(Icons.public),
                                    onChanged: (val) {
                                      setState(() {
                                        listCheckBox![index] = val!;
                                        authBloc.add(AddToPlaylistEvent(
                                            PlaylistsRequestModel(
                                                trackId:
                                                    int.parse(mediaItem!.id),
                                                playlistId:
                                                    playlist![index].id!)));
                                      });
                                    });
                              }),
                        )
                      : SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(context.loc.noPlaylists,
                                style: context.titleMedium),
                          ),
                        );
                },
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.check),
            title: Text(context.loc.done),
          )
        ],
      ),
    );
  }
}
