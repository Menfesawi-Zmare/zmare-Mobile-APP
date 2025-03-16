import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/presentation/widgets/snackbar.dart';
import 'package:zmare/src/utils/services/audio/download.dart';
import 'package:hive/hive.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../app/routes.dart';
import '../../service_locator.dart';
import '../../utils/helper/constants.dart';

class DownloadButton extends StatefulWidget {
  final Map data;
  final String? icon;
  final double? size;

  DownloadButton({
    super.key,
    required this.data,
    this.icon,
    this.size,
  });

  @override
  State<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<DownloadButton> {
  late Download down;
  final Box downloadsBox = Hive.box(BoxType.downloads.name);
  final ValueNotifier<bool> showStopButton = ValueNotifier<bool>(false);
  final accountJson = account.get(accountDetail, defaultValue: '');
  bool isSignedUp = false;

  @override
  void initState() {
    super.initState();
    if (accountJson != '') {
      isSignedUp = true;
    }
    down = Download(widget.data['id'].toString());
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
          return SizedBox.square(
            dimension: 50,
            child: Center(
              child: (downloadsBox.containsKey(widget.data['id']))
                  ? IconButton(
                      icon: Icon(MdiIcons.checkCircleOutline),
                      tooltip: 'Download Done',
                      color: Theme.of(context).colorScheme.secondary,
                      iconSize: widget.size ?? 24.0,
                      onPressed: () {
                        if (accountJson.isNotEmpty) {
                          down.prepareDownload(context, widget.data);
                        } else {
                          ShowSnackBar().showSnackBar(
                              context, "Please sign up to download ",
                              duration: Duration(seconds: 3));
                          context.pushNamed(
                            loginName,
                            extra: {
                              'isLoggedIn': true,
                            },
                          );
                        }
                      },
                    )
                  : down.progress == 0
                      ? IconButton(
                          icon: Icon(
                            widget.icon == 'download'
                                ? FluentIcons.arrow_download_16_regular
                                : FluentIcons.arrow_download_16_regular,
                          ),
                          iconSize: widget.size ?? 24.0,
                          color: Theme.of(context).colorScheme.secondary,
                          tooltip: 'Download',
                          onPressed: () {
                            if (accountJson.isNotEmpty) {
                              down.prepareDownload(context, widget.data);
                            } else {
                              ShowSnackBar().showSnackBar(
                                  context, "Please sign up to download ",
                                  duration: Duration(seconds: 3));
                              context.pushNamed(
                                loginName,
                                extra: {
                                  'isLoggedIn': true,
                                },
                              );
                            }
                          },
                        )
                      : GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: ValueListenableBuilder(
                                  valueListenable: showStopButton,
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                      ),
                                      iconSize: 22.0,
                                      color: Theme.of(context).iconTheme.color,
                                      tooltip: AppLocalizations.of(
                                        context,
                                      )!
                                          .stopDown,
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
                                            MainAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: !showValue,
                                            child: Center(
                                              child: Text(
                                                down.progress == null
                                                    ? '0%'
                                                    : '${(100 * down.progress!).round()}%',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Visibility(
                                            visible: showValue,
                                            child: child!,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: 26,
                                              child: LinearProgressIndicator(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                value: down.progress == 1
                                                    ? null
                                                    : down.progress,
                                              ),
                                            ),
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
          );
        });
  }
}

class MultiDownloadButton extends StatefulWidget {
  final List data;
  final String playlistName;
  const MultiDownloadButton({
    super.key,
    required this.data,
    required this.playlistName,
  });

  @override
  State<MultiDownloadButton> createState() => _MultiDownloadButtonState();
}

class _MultiDownloadButtonState extends State<MultiDownloadButton> {
  late Download down;
  int done = 0;

  @override
  void initState() {
    super.initState();
    down = Download(widget.data.first['id'].toString());
    down.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _waitUntilDone(String id) async {
    while (down.lastDownloadId != id) {
      await Future.delayed(const Duration(seconds: 1));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: (down.lastDownloadId == widget.data.last['id'])
            ? ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.green),
                child: const Icon(Icons.done_all, color: Colors.white))
            : down.progress == 0
                ? ElevatedButton(
                    onPressed: () async {
                      for (final items in widget.data) {
                        down.prepareDownload(
                          context,
                          items as Map,
                          createFolder: true,
                          folderName: widget.playlistName,
                        );
                        await _waitUntilDone(items['id'].toString());
                        if (mounted) {
                          setState(() {
                            done++;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.grey),
                    child: const Icon(FluentIcons.arrow_download_16_regular,
                        color: Colors.white))
                : Column(
                    children: [
                      Center(
                        child: Text(down.progress == null
                            ? '0%'
                            : '${(100 * down.progress!).round()}%'),
                      ),
                      Center(
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: LinearProgressIndicator(
                            value: down.progress == 1 ? null : down.progress,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: LinearProgressIndicator(
                            value: done / widget.data.length,
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
