import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/data/playlist/model/create_playlist_model.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/data/playlist/model/playlists_request_model.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/textinput_dialog.dart';
import 'package:zmare/src/service_locator.dart';

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
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.loc.saveMusicTo,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
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
                    icon: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.primary),
                    label: Text(
                      context.loc.createNewPlaylist,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
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
                        child: KhmertracksText(
                          text: context.loc.noPlaylists,
                          // style: Theme.of(context).textTheme.bodyMedium,
                        ),
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
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CheckboxListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: Text(
                                    playlist![index].name!,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  value: listCheckBox![index],
                                  secondary: playlist![index].public == 0
                                      ? Icon(Icons.lock,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6))
                                      : Icon(Icons.public,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6)),
                                  onChanged: (val) {
                                    setState(() {
                                      listCheckBox![index] = val!;
                                      authBloc.add(AddToPlaylistEvent(
                                        PlaylistsRequestModel(
                                          trackId: int.parse(mediaItem!.id),
                                          playlistId: playlist![index].id!,
                                        ),
                                      ));
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: 200,
                          child: Center(
                            child: Text(
                              context.loc.noPlaylists,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primaryContainer,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    context.loc.done,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
