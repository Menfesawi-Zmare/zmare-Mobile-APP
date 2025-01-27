import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/helper/audio_query.dart';
import 'package:flutter_music_pro/src/presentation/widgets/empty_screen.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:go_router/go_router.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumsTab extends StatefulWidget {
  final Map<String, List<SongModel>> albums;
  final List<String> albumsList;
  final String tempPath;
  const AlbumsTab({
    super.key,
    required this.albums,
    required this.albumsList,
    required this.tempPath,
  });

  @override
  State<AlbumsTab> createState() => _AlbumsTabState();
}

class _AlbumsTabState extends State<AlbumsTab>
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
    return widget.albumsList.isEmpty
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
        : Scrollbar(
            controller: _scrollController,
            thickness: 8,
            thumbVisibility: true,
            radius: const Radius.circular(10),
            interactive: true,
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.albumsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
                  visualDensity: const VisualDensity(vertical: 2),
                  horizontalTitleGap: 10.0,
                  minVerticalPadding: 0,
                  leading: OfflineAudioQuery.offlineArtworkWidget(
                    id: widget.albums[widget.albumsList[index]]![0].id,
                    type: ArtworkType.AUDIO,
                    tempPath: widget.tempPath,
                    fileName: widget
                        .albums[widget.albumsList[index]]![0].displayNameWOExt,
                  ),
                  title: KhmertracksTitle(
                    widget.albumsList[index],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${widget.albums[widget.albumsList[index]]!.length} ${context.loc.songs}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    context.pushNamed(myMusicDetailName,
                        extra: widget.albums[widget.albumsList[index]],
                        pathParameters: {'title': widget.albumsList[index]});
                  },
                );
              },
            ),
          );
  }
}
