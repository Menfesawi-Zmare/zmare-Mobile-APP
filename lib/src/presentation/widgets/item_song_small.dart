import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_music_pro/src/utils/services/audio/download.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/services/audio/player_service.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';
import 'package:flutter_music_pro/src/presentation/modal/modal_more.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemSongSmall extends StatefulWidget {
  const ItemSongSmall(
      {super.key,
      required this.songList,
      required this.number,
      required this.index,
      required this.listItemSong,
      this.action = false,
      this.playlist,
      this.onRemoveCallBack,
      this.showArtistName = false});
  final String number;
  final ItemSongModel songList;
  final int index;
  final List<ItemSongModel> listItemSong;
  final bool action;
  final Playlist? playlist;
  final Function(Playlist playlist)? onRemoveCallBack;
  final bool showArtistName;

  @override
  State<ItemSongSmall> createState() => _ItemSongSmallState();
}

class _ItemSongSmallState extends State<ItemSongSmall> {
  late Download down;
  bool downloaded = false;
  final ValueNotifier<bool> showStopButton = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    down = Download(widget.songList.id!.toString());
    down.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        dense: true,
        contentPadding: const EdgeInsets.only(left: 16.0, right: 0.0),
        visualDensity: VisualDensity(vertical: widget.showArtistName ? 0 : 4),
        horizontalTitleGap: 10.0,
        minVerticalPadding: 0,
        leading: KhmertracksTitle(widget.number),
        title: KhmertracksTitle(widget.songList.title!),
        subtitle: widget.showArtistName
            ? KhmertracksSubTitle(widget.songList.artist)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (down.progress == 0)
              const SizedBox.shrink()
            else
              SizedBox.square(
                dimension: 50,
                child: Center(
                  child: GestureDetector(
                    child: Stack(
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            value: down.progress == 1 ? null : down.progress,
                          ),
                        ),
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: showStopButton,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                ),
                                iconSize: 25.0,
                                color: Theme.of(context).iconTheme.color,
                                tooltip: context.loc.stopDown,
                                onPressed: () {
                                  down.download = false;
                                },
                              ),
                            ),
                            builder: (
                              BuildContext context,
                              bool showValue,
                              Widget? child,
                            ) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Visibility(
                                      visible: !showValue,
                                      child: Center(
                                        child: Text(
                                          down.progress == null
                                              ? '0'
                                              : '${(100 * down.progress!).round()}',
                                          style: context.labelSmall!.copyWith(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: showValue,
                                      child: child!,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      showStopButton.value = true;
                      Future.delayed(const Duration(seconds: 2), () async {
                        showStopButton.value = false;
                      });
                    },
                  ),
                ),
              ),
            IconButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25.0),
                        ),
                      ),
                      builder: (context) => ModalMore(
                          songList: widget.songList,
                          action: widget.action,
                          playlist: widget.playlist,
                          onRemoveCallBack: (Playlist playlist) {
                            widget.onRemoveCallBack!(playlist);
                          },
                          onDownloadCallBack: (isDownload) {
                            if (isDownload == true) {
                              down.prepareDownload(
                                  context, widget.songList.toJson());
                            }
                          }));
                },
                icon: Icon(MdiIcons.dotsHorizontal)),
          ],
        ),
        onTap: () {
          PlayerInvoke.init(
            songsList: widget.listItemSong.map((e) => e.toJson()).toList(),
            index: widget.index,
            isOffline: false,
            shuffle: false,
          );
        });
  }
}
