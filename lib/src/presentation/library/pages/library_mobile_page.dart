// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/library/widget/history_widget.dart';
import 'package:zmare/src/presentation/library/widget/library_playlist_widget.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/profile/bloc/profile_bloc.dart';
import 'package:zmare/src/presentation/widgets/zmare_bottom_sheet.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';
import 'package:zmare/src/service_locator.dart';

class LibraryMobilePage extends StatefulWidget {
  const LibraryMobilePage({super.key});

  @override
  State<LibraryMobilePage> createState() => _LibraryMobilePageState();
}

class _LibraryMobilePageState extends State<LibraryMobilePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List _historyTracks = [];
  List<Playlist>? playlists = [];
  Profile? profile;
  bool showLogout = false;
  final ProfileBloc profileBloc = locator.get<ProfileBloc>();
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final historyList = locator
      .get<Box<dynamic>>(instanceName: BoxType.cache.name)
      .listenable(keys: ['recentSongs']);

  Future<void> getPlaylists() async {
    if (profile != null) {
      profileBloc.add(GetProfilePlaylists(profile!.id!, 1));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      strokeWidth: 2.0,
      onRefresh: () async {
        HapticFeedback.mediumImpact();
        playlists = [];
        getPlaylists();
        return Future<void>.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        children: [
          ValueListenableBuilder(
            valueListenable: historyList,
            builder: (BuildContext context, value, Widget? child) {
              _historyTracks =
                  value.get('recentSongs', defaultValue: []) as List;
              return HistoryWidget(
                  tracks: _historyTracks.length > 10
                      ? _historyTracks.sublist(0, 10)
                      : _historyTracks);
            },
          ),
          ValueListenableBuilder(
              valueListenable: locator
                  .get<Box<dynamic>>(instanceName: BoxType.account.name)
                  .listenable(
                keys: [accountDetail],
              ),
              builder: (BuildContext context, value, Widget? child) {
                final accountJson = value.get(accountDetail, defaultValue: '');
                if (accountJson != '') {
                  profile =
                      Profile?.fromJson(jsonDecode(jsonEncode(accountJson)));
                  getPlaylists();
                  return Column(
                    children: [
                      BlocProvider(
                        create: (context) => profileBloc,
                        child: BlocConsumer(
                            bloc: profileBloc,
                            listener: (context, state) {
                              if (state is ProfilePlaylists) {
                                playlists = state.playlistList.playlist!;
                              }
                            },
                            builder: (BuildContext context, Object? state) {
                              return LibraryPlaylistWidget(
                                profile: profile,
                                playlists: playlists!.length > 10
                                    ? playlists!.sublist(0, 10)
                                    : playlists!,
                                onCallBack: (bool isCreatePlaylist) {
                                  if (isCreatePlaylist == true) {
                                    HapticFeedback.mediumImpact();
                                    getPlaylists();
                                    context.showMaterialSnackBar(
                                        context.loc.playlistCreated);
                                  }
                                },
                              );
                            }),
                      ),
                      LibraryTile(
                        title: context.loc.likes,
                        icon: FluentIcons.heart_48_regular,
                        onTap: () {
                          context.pushNamed(likesPath, extra: profile!.id);
                        },
                      ),
                      LibraryTile(
                        title: context.loc.stream,
                        icon: Icons.audiotrack_sharp,
                        onTap: () {
                          context.pushNamed(streamPath);
                        },
                      ),
                      LibraryTile(
                        title: context.loc.down,
                        icon: FluentIcons.arrow_download_20_regular,
                        onTap: () {
                          context.pushNamed(downloadsPath);
                        },
                      ),
                      if (Platform.isAndroid)
                        LibraryTile(
                          title: context.loc.myMusic,
                          icon: FluentIcons.music_note_2_play_20_filled,
                          onTap: () {
                            context.pushNamed(myMusicName);
                          },
                        ),
                      LibraryTile(
                        title: context.loc.settings,
                        icon: FluentIcons.settings_48_regular,
                        onTap: () {
                          context.pushNamed(settingsPath);
                        },
                      ),
                      Divider(color: Colors.grey.withOpacity(0.2)),
                      LibraryTile(
                        title: context.loc.logout,
                        icon: Icons.logout_outlined,
                        onTap: () {
                          zmareAlertDialog(
                            context,
                            title: ZmareText(
                              text: context.loc.logoutContent,
                            ),
                            child: const SizedBox.shrink(),
                            confirmationButton: OutlinedButton(
                              // style: TextButton.styleFrom(
                              //   // backgroundColor:
                              //   //     Theme.of(context).colorScheme.primary,
                              //   padding:
                              //       const EdgeInsets.symmetric(horizontal: 16),
                              // ),
                              onPressed: () {
                                setState(() {
                                  showLogout = false;
                                });
                                context.pop();
                                playlists = [];
                                authBloc.add(LogoutEvent());
                              },
                              child: Text(context.loc.logout,
                                  style: TextStyle(
                                      color: context.colorScheme.primary)),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      LibraryTile(
                        title: context.loc.down,
                        icon: FluentIcons.arrow_download_16_regular,
                        onTap: () {
                          context.pushNamed(downloadsPath);
                        },
                      ),
                      if (Platform.isAndroid)
                        LibraryTile(
                          title: context.loc.myMusic,
                          icon: FluentIcons.music_note_2_play_20_regular,
                          onTap: () {
                            context.pushNamed(myMusicName);
                          },
                        ),
                      LibraryTile(
                        title: context.loc.settings,
                        icon: FluentIcons.settings_48_regular,
                        onTap: () {
                          context.pushNamed(settingsPath);
                        },
                      ),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }
}

class LibraryTile extends StatelessWidget {
  const LibraryTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.patternColor,
  });

  final String title;
  final IconData icon;
  final Function() onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final Color? patternColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: iconColor ?? colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: colorScheme.onPrimary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: textColor ?? colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    Platform.isAndroid
                        ? Icons.arrow_forward
                        : Icons.arrow_forward_ios,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
