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
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';

import 'modal_artist.dart';

class ModalMore extends StatelessWidget {
  const ModalMore(
      {super.key,
      required this.songList,
      this.isPlayingPage = false,
      this.offline = false,
      this.action = false,
      this.playlist,
      this.onRemoveCallBack,
      this.onDownloadCallBack});
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
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(left: 0.0, right: 12.0),
              visualDensity: const VisualDensity(vertical: 2),
              horizontalTitleGap: 10.0,
              minVerticalPadding: 0,
              leading: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  height: 56,
                  width: 56,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: songList.image!.startsWith('file:')
                          ? Image(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(
                                  Uri.parse(songList.image!).toFilePath(),
                                ),
                              ))
                          : KhmertracksImage(
                              imageUrl: songList.image!,
                              placeholderImage: Images.defalutSongCover,
                            ),
                    ),
                  ),
                ),
              ),
              title: Text(songList.title!,
                  overflow: TextOverflow.ellipsis,
                  style:
                      context.titleMedium?.copyWith(color: context.onSurface)),
              subtitle: Text('${songList.artist!} • ${songList.album!}',
                  overflow: TextOverflow.ellipsis,
                  style: context.bodyMedium?.copyWith(
                      color: context.onSurface, fontWeight: FontWeight.w500))),
          Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
              color: Colors.grey.withOpacity(0.2)),
          if (!isPlayingPage)
            ListTile(
              title: Text(context.loc.playNext,
                  style: context.titleMedium?.copyWith(
                      color: context.onSurface, fontWeight: FontWeight.w500)),
              leading: const Icon(Icons.queue_music_outlined),
              onTap: () {
                final MediaItem mediaItem =
                    MediaItemConverter.mapToMediaItem(songList.toJson());
                playNext(mediaItem, context);
                GoRouter.of(context).pop();
              },
            ),
          if (accountJson != '')
            ListTile(
                title: Text(context.loc.saveToPlaylist,
                    style: context.titleMedium?.copyWith(
                        color: context.onSurface, fontWeight: FontWeight.w500)),
                leading: const Icon(Icons.playlist_add_outlined),
                onTap: () {
                  GoRouter.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (context) => PlaylistsBottomSheet(
                      songList: songList,
                    ),
                  );
                }),
          ListTile(
            title: Text(context.loc.goToAlbum,
                style: context.titleMedium?.copyWith(
                    color: context.onSurface, fontWeight: FontWeight.w500)),
            leading: Icon(MdiIcons.album),
            onTap: () {
              GoRouter.of(context).pop();
              AdHelper.showInterstitialAd();
              if (isPlayingPage) {
                GoRouter.of(context).pop();
              }
              context.pushNamed(albumSongsPath,
                  extra: Album(
                      name: songList.album,
                      id: songList.albumId,
                      image: songList.albumCover));
            },
          ),
          ListTile(
              title: Text(context.loc.goToArtist,
                  style: context.titleMedium?.copyWith(
                      color: context.onSurface, fontWeight: FontWeight.w500)),
              leading: Icon(MdiIcons.accountMusicOutline),
              onTap: () {
                GoRouter.of(context).pop();
                AdHelper.showInterstitialAd();
                if (songList.artist!.split(',').length > 1) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ModalArtists(
                        isPlayingPage: isPlayingPage,
                        artistName: songList.artist!,
                        artistId: songList.artistId!),
                  );
                } else {
                  if (isPlayingPage) {
                    context.pop();
                  }
                  context.pushNamed(artistPath,
                      extra: Artist(
                        id: int.parse(songList.artistId!),
                        name: songList.artist,
                        image: '',
                        description: '',
                        albumTotal: 0,
                        listener: 0,
                        subscribers: 0,
                        trackTotal: 0,
                      ));
                }
              }),
          Visibility(
            visible: isPlayingPage || songList.download == false ? false : true,
            child: ListTile(
              title: Text(context.loc.down,
                  style: context.titleMedium?.copyWith(
                      color: context.onSurface, fontWeight: FontWeight.w500)),
              leading: const Icon(FluentIcons.arrow_download_48_filled),
              onTap: () {
                onDownloadCallBack!(true);
                GoRouter.of(context).pop();
              },
            ),
          ),
          Visibility(
            visible: offline ? false : true,
            child: ListTile(
                title: Text(context.loc.share,
                    style: context.titleMedium?.copyWith(
                        color: context.onSurface, fontWeight: FontWeight.w500)),
                leading: Icon(MdiIcons.share),
                onTap: () async {
                  GoRouter.of(context).pop();
                  Share.share(
                    '${songList.title!} • ${songList.artist!} ${songList.link}',
                    subject: context.loc.appTitle,
                  );
                }),
          ),
          // Visibility(
          //   visible: action && playlist != null ? true : false,
          //   child: ListTile(
          //     title: Text(
          //         "${context.loc.removedFrom} ${playlist != null ? playlist!.name : ''}",
          //         style: context.titleMedium?.copyWith(
          //             color: context.onSurface, fontWeight: FontWeight.w500)),
          //     leading: Icon(MdiIcons.deleteOutline),
          //     onTap: () {
          //       onRemoveCallBack!(playlist!);
          //       GoRouter.of(context).pop();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
