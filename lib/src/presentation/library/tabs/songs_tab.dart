import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/helper/audio_query.dart';
import 'package:flutter_music_pro/src/utils/services/audio/player_service.dart';
import 'package:flutter_music_pro/src/presentation/widgets/empty_screen.dart';
import 'package:flutter_music_pro/src/presentation/widgets/playlist_head.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongsTab extends StatefulWidget {
  final List<SongModel> songs;
  final int? playlistId;
  final String? playlistName;
  final String tempPath;
  const SongsTab({
    super.key,
    required this.songs,
    required this.tempPath,
    this.playlistId,
    this.playlistName,
  });

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.songs.isEmpty
        ? emptyScreen(
            context,
            3,
            context.loc.nothingTo,
            15.0,
            context.loc.showHere,
            45,
            context.loc.downloadSomething,
            23.0,
          )
        : Column(
            children: [
              PlaylistHead(
                songsList: widget.songs,
                offline: true,
                fromDownloads: false,
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thickness: 8,
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  interactive: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 10),
                    shrinkWrap: true,
                    itemCount: widget.songs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),
                        dense: true,
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, right: 0.0),
                        visualDensity: const VisualDensity(vertical: 2),
                        horizontalTitleGap: 10.0,
                        minVerticalPadding: 0,
                        leading: OfflineAudioQuery.offlineArtworkWidget(
                          id: widget.songs[index].id,
                          type: ArtworkType.AUDIO,
                          tempPath: widget.tempPath,
                          fileName: widget.songs[index].displayNameWOExt,
                        ),
                        title: KhmertracksTitle(
                          widget.songs[index].title.trim() != ''
                              ? widget.songs[index].title
                              : widget.songs[index].displayNameWOExt,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: KhmertracksSubTitle(
                          '${widget.songs[index].artist?.replaceAll('<unknown>', 'Unknown') ?? context.loc.unknown} - ${widget.songs[index].album?.replaceAll('<unknown>', 'Unknown') ?? context.loc.unknown}',
                        ),
                        onTap: () {
                          PlayerInvoke.init(
                            songsList: widget.songs,
                            index: index,
                            isOffline: true,
                            recommend: false,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
  }
}
