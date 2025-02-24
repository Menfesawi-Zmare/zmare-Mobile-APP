// ignore_for_file: deprecated_member_use

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/data/playlist/model/create_playlist_model.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/utils/helper/ad_helper.dart';
import 'package:zmare/src/data/playlist/model/playlist.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/library/modal/modal_add_playlist_tracks.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_library_add_playlist.dart';
import 'package:zmare/src/presentation/widgets/item_library_playlist.dart';
import 'package:zmare/src/presentation/widgets/textinput_dialog.dart';
import 'package:zmare/src/service_locator.dart';

class LibraryPlaylistWidget extends StatefulWidget {
  const LibraryPlaylistWidget(
      {super.key,
      required this.playlists,
      required this.onCallBack,
      required this.profile});
  final List<Playlist> playlists;
  final Profile? profile;
  final Function(bool isCreatePlaylist) onCallBack;
  @override
  State<LibraryPlaylistWidget> createState() => _LibraryPlaylistWidgetState();
}

class _LibraryPlaylistWidgetState extends State<LibraryPlaylistWidget> {
  final AuthBloc authBloc = locator.get<AuthBloc>();
  bool action = true;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => authBloc,
        child: BlocListener(
          bloc: authBloc,
          listener: (context, state) {
            if (state is CreatePlaylistState) {
              widget.onCallBack(true);
              _scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            }
          },
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  horizontalTitleGap: 8.0,
                  contentPadding: const EdgeInsets.only(left: 16.0, right: 0.0),
                  title: Text(context.loc.playlists,
                      style: context.titleMedium!
                          .copyWith(fontWeight: FontWeight.w500)),
                  subtitle: widget.playlists.isEmpty
                      ? Text(context.loc.listNotPlaylists,
                          style: context.bodySmall!
                              .copyWith(fontWeight: FontWeight.w400))
                      : null,
                  leading: Icon(
                    Icons.playlist_play_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  trailing: widget.playlists.isNotEmpty
                      ? TextButton(
                          onPressed: () {
                            AdHelper.showInterstitialAd();
                            context.pushNamed(userPlaylistName,
                                extra: widget.profile);
                          },
                          child: Text(context.loc.viewAll,
                              style: context.titleSmall!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue)))
                      : null,
                ),
                SizedBox(
                    height: 160,
                    child: ListView.builder(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.playlists.length + 1,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        // itemExtent: 155,
                        itemBuilder: (BuildContext context, int index) =>
                            (index != widget.playlists.length)
                                ? ItemLibraryPlaylist(
                                    icon: Icons.playlist_play_outlined,
                                    playlist: widget.playlists[index],
                                    onPressed: () => context.pushNamed(
                                        viewPlaylistsPath,
                                        extra: widget.playlists[index],
                                        pathParameters: {'action': '$action'}))
                                : ItemLibraryAddPlaylist(
                                    title: context.loc.createPlaylist,
                                    icon: FluentIcons.add_48_regular,
                                    onPressed: () {
                                      HapticFeedback.mediumImpact();
                                      final historyList =
                                          Hive.box(BoxType.cache.name).get(
                                              'recentSongs',
                                              defaultValue: []) as List;
                                      if (historyList.isNotEmpty) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) {
                                                  return ModalAddPlaylistTracks(
                                                    onCallBack:
                                                        (bool isReload) {
                                                      if (isReload == true) {
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 1),
                                                            () async {
                                                          widget
                                                              .onCallBack(true);
                                                          _scrollController
                                                              .animateTo(
                                                            0.0,
                                                            curve:
                                                                Curves.easeOut,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                          );
                                                        });
                                                      }
                                                    },
                                                  );
                                                },
                                                fullscreenDialog: true));
                                      } else {
                                        showTextInputDialog(
                                          context: context,
                                          keyboardType: TextInputType.name,
                                          title: context.loc.createNewPlaylist,
                                          onSubmitted: (String value) async {
                                            final RegExp avoid =
                                                RegExp(r'[\.\*\:\"\?#/;\|]');
                                            value
                                                .replaceAll(avoid, '')
                                                .replaceAll('  ', ' ');
                                            authBloc.add(CreatePlaylistEvent(
                                                CreatePlaylistModel(
                                                    name: value, public: 1)));
                                          },
                                        );
                                      }
                                    }))),
                Divider(color: Colors.grey.withOpacity(0.2)),
              ]),
        ));
  }
}
