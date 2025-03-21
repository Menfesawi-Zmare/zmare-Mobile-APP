import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/ad_helper.dart';
import 'package:zmare/src/utils/helper/add_mediaitem_to_queue.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';
import 'package:zmare/src/data/album/model/album.dart';
import 'package:zmare/src/data/artist/model/artist.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/playlist/modal/playlists_bottomsheet.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'modal_artist.dart';

class ModalMore extends StatelessWidget {
  const ModalMore({
    super.key,
    required this.songList,
    this.isPlayingPage = false,
    this.offline = false,
    this.action = false,
    this.playlist,
    this.onRemoveCallBack,
    this.onDownloadCallBack,
  });

  final ItemSongModel songList;
  final bool isPlayingPage;
  final bool offline;
  final bool action;
  final Playlist? playlist;
  final Function(Playlist playlist)? onRemoveCallBack;
  final Function(bool isDownload)? onDownloadCallBack;

  @override
  Widget build(BuildContext context) {
    final accountJson = account.get(accountDetail, defaultValue: '');
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface.withOpacity(0.9),
              theme.colorScheme.surface.withOpacity(0.7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header with Song Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Song Cover Image with Custom Shape
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: songList.image!.startsWith('file:')
                          ? Image(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(Uri.parse(songList.image!).toFilePath()),
                              ),
                            )
                          : ZmareImage(
                              imageUrl: songList.image!,
                              placeholderImage: Images.defalutSongCover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Song Title and Artist
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songList.title!,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${songList.artist!} • ${songList.album!}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            // Action Buttons in a Scrollable List
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  if (!isPlayingPage)
                    _buildActionCard(
                      context,
                      icon: Icons.queue_music_outlined,
                      title: context.loc.playNext,
                      onTap: () {
                        final MediaItem mediaItem =
                            MediaItemConverter.mapToMediaItem(
                                songList.toJson());
                        playNext(mediaItem, context);
                        GoRouter.of(context).pop();
                      },
                    ),
                  if (accountJson != '')
                    _buildActionCard(
                      context,
                      icon: Icons.playlist_add_outlined,
                      title: context.loc.saveToPlaylist,
                      onTap: () {
                        GoRouter.of(context).pop();
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(25)),
                          ),
                          isScrollControlled: true,
                          builder: (context) =>
                              PlaylistsBottomSheet(songList: songList),
                        );
                      },
                    ),
                  _buildActionCard(
                    context,
                    icon: MdiIcons.album,
                    title: context.loc.goToAlbum,
                    onTap: () {
                      GoRouter.of(context).pop();
                      AdHelper.showInterstitialAd();
                      if (isPlayingPage) GoRouter.of(context).pop();
                      context.pushNamed(
                        albumSongsPath,
                        extra: Album(
                          name: songList.album,
                          id: songList.albumId,
                          image: songList.albumCover,
                        ),
                      );
                    },
                  ),
                  _buildActionCard(
                    context,
                    icon: MdiIcons.accountMusicOutline,
                    title: context.loc.goToArtist,
                    onTap: () {
                      GoRouter.of(context).pop();
                      AdHelper.showInterstitialAd();
                      if (songList.artist!.split(',').length > 1) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ModalArtists(
                            isPlayingPage: isPlayingPage,
                            artistName: songList.artist!,
                            artistId: songList.artistId!,
                          ),
                        );
                      } else {
                        if (isPlayingPage) context.pop();
                        context.pushNamed(
                          artistPath,
                          extra: Artist(
                            id: int.parse(songList.artistId!),
                            name: songList.artist,
                            image: '',
                            description: '',
                            albumTotal: 0,
                            listener: 0,
                            subscribers: 0,
                            trackTotal: 0,
                          ),
                        );
                      }
                    },
                  ),
                  if (isPlayingPage || songList.download == false)
                    const SizedBox.shrink()
                  else
                    _buildActionCard(
                      context,
                      icon: FluentIcons.arrow_download_48_filled,
                      title: context.loc.down,
                      onTap: () {
                        onDownloadCallBack!(true);
                        GoRouter.of(context).pop();
                      },
                    ),
                  // if (action && playlist != null)
                  //   _buildActionCard(
                  //     context,
                  //     icon: MdiIcons.deleteOutline,
                  //     title:
                  //         "${context.loc.removedFrom} ${playlist?.name ?? ''}",
                  //     onTap: () {
                  //       onRemoveCallBack!(playlist!);
                  //       GoRouter.of(context).pop();
                  //     },
                  //   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.onSurface),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
