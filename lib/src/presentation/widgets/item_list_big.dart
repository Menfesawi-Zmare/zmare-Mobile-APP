import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/presentation/widgets/snackbar.dart';
import 'package:zmare/src/utils/services/audio/download.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/presentation/modal/modal_more.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../core/enum/box_types.dart';
import '../../service_locator.dart';

class ItemListBig extends StatefulWidget {
  const ItemListBig(
      {super.key, required this.songList, required this.listItemSong});
  final ItemSongModel songList;
  final List<ItemSongModel> listItemSong;

  @override
  State<ItemListBig> createState() => _ItemListBigState();
}

class _ItemListBigState extends State<ItemListBig> {
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
    return ValueListenableBuilder(
        valueListenable: locator
            .get<Box<dynamic>>(instanceName: BoxType.account.name)
            .listenable(
          keys: [accountDetail],
        ),
        builder: (BuildContext context, value, Widget? child) {
          final accountJson = value.get(accountDetail, defaultValue: '');
          return ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              dense: true,
              contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
              visualDensity: const VisualDensity(vertical: 2),
              horizontalTitleGap: 10.0,
              minVerticalPadding: 0,
              leading: SizedBox.square(
                dimension: 56,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: KhmertracksImage(
                      imageUrl: widget.songList.image!,
                      placeholderImage: Images.defalutCover,
                    ),
                  ),
                ),
              ),
              title: KhmertracksTitle(widget.songList.title!),
              subtitle: KhmertracksSubTitle(
                  '${widget.songList.artist} • ${widget.songList.album}'),
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
                                  value:
                                      down.progress == 1 ? null : down.progress,
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
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible: !showValue,
                                            child: Center(
                                              child: Text(
                                                down.progress == null
                                                    ? '0'
                                                    : '${(100 * down.progress!).round()}',
                                                style: context.labelSmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
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
                            Future.delayed(const Duration(seconds: 2),
                                () async {
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
                          useRootNavigator: true,
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (context) => ModalMore(
                            songList: widget.songList,
                            onDownloadCallBack: (isDownload) {
                              if (isDownload == true &&
                                  accountJson.isNotEmpty) {
                                down.prepareDownload(
                                    context, widget.songList.toJson());
                              } else {
                                ShowSnackBar().showSnackBar(
                                    context, "Please sign up to download",
                                    duration: Duration(seconds: 3));
                                context.pushNamed(
                                  loginName,
                                  extra: {
                                    'isLoggedIn': true,
                                  },
                                );
                              }
                              // if (isDownload == true) {
                              //   down.prepareDownload(
                              //       context, widget.songList.toJson());
                              // }
                            },
                          ),
                        );
                      },
                      icon: Icon(MdiIcons.dotsVertical)),
                ],
              ),
              onTap: () {
                PlayerInvoke.init(
                  songsList:
                      widget.listItemSong.map((e) => e.toJson()).toList(),
                  index: widget.listItemSong
                      .map((e) => e.toJson())
                      .toList()
                      .indexWhere(
                          (element) => element['id'] == widget.songList.id),
                  isOffline: false,
                );
              });
        });
  }
}
