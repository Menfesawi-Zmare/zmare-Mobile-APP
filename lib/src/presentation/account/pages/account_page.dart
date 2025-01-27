import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/account/modal/account_settings_modal.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/about_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/likes_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/profile_playlists_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/subscriber_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/subscriptions_widget.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';

import 'package:flutter_music_pro/src/service_locator.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with AutomaticKeepAliveClientMixin<AccountPage> {
  final account =
      locator.get<Box<dynamic>>(instanceName: BoxType.account.name).listenable(
    keys: [accountDetail],
  );
  Profile profile = Profile();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<String> tabs = <String>[
      context.loc.subscriptions.toUpperCase(),
      context.loc.subscribers.toUpperCase(),
      context.loc.likes.toUpperCase(),
      context.loc.playlists.toUpperCase(),
      context.loc.about.toUpperCase(),
    ];
    return ValueListenableBuilder(
        valueListenable: account,
        builder: (BuildContext context, value, Widget? child) {
          final accountJson = value.get(accountDetail, defaultValue: "");
          if (accountJson != null) {
            profile = Profile?.fromJson(jsonDecode(jsonEncode(accountJson)));
          } else {
            context.pop();
          }
          return MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Scaffold(
              appBar: context.materialYouAppBar(
                realName(profile.username, profile.firstName, profile.lastName),
                actions: [
                  IconButton(
                    icon: Icon(
                      FluentIcons.settings_28_regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          useRootNavigator: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          builder: (context) => const AccountSettingsModal());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FluentIcons.search_28_regular,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      context.pushNamed(searchPath);
                    },
                  ),
                ],
              ),
              body: DefaultTabController(
                length: tabs.length,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverSafeArea(
                          top: false,
                          sliver: SliverAppBar(
                            automaticallyImplyLeading: false,
                            floating: true,
                            pinned: true,
                            snap: false,
                            primary: true,
                            forceElevated: innerBoxIsScrolled,
                            bottom: TabBar(
                              isScrollable: true,
                              labelStyle: context.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              tabs: tabs
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                            ),
                            expandedHeight: 380,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              background: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: double.infinity,
                                        height: 120,
                                        child: KhmertracksImage(
                                          imageUrl: profile.cover!,
                                          placeholderImage:
                                              Images.defalultArtistCover,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: SizedBox(
                                            width: 80,
                                            height: 80,
                                            child: KhmertracksImage(
                                              imageUrl: profile.image!,
                                              placeholderImage:
                                                  Images.defalultArtistCover,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      realName(profile.username!,
                                          profile.firstName, profile.lastName),
                                      style: context.headlineSmall!.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "@${profile.username}",
                                      style: context.labelMedium?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ElevatedButton.icon(
                                            icon: Icon(
                                              FluentIcons.edit_48_regular,
                                              size: 22,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                maximumSize: const Size(
                                                    double.infinity, 40),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                            onPressed: () {
                                              context.pushNamed(editProfilePath,
                                                  extra: profile);
                                            },
                                            label: Text(context.loc.editProfile,
                                                style: context.bodySmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: context
                                                            .colorScheme
                                                            .surface))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      SubscriptionsWidget(profileId: profile.id!),
                      SubscribersWidget(profileId: profile.id!),
                      LikesWidget(profileId: profile.id!),
                      ProfilePlaylistsWidget(
                          profileId: profile.id!,
                          action: true,
                          username: profile.username!),
                      AboutWidget(profile: Profile.fromJson(profile.toJson()))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
