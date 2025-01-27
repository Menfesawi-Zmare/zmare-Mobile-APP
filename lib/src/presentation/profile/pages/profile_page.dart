import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/core/enum/sub_type.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/about_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/likes_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/profile_playlists_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/subscriber_widget.dart';
import 'package:flutter_music_pro/src/presentation/profile/widget/subscriptions_widget.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';

import 'package:flutter_music_pro/src/service_locator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.profile});
  final Profile profile;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  bool isSubscribe = false;
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final accountJson = account.get(accountDetail, defaultValue: '');
  @override
  void initState() {
    if (accountJson != '') {
      authBloc.add(GetSubsEvent(widget.profile.id!, SubTypeEnum.user.name));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Prevent keyboard popup
    FocusScope.of(context).unfocus();
    super.build(context);
    final List<String> tabs = <String>[
      context.loc.subscriptions.toUpperCase(),
      context.loc.subscribers.toUpperCase(),
      context.loc.likes.toUpperCase(),
      context.loc.playlists.toUpperCase(),
      context.loc.about.toUpperCase(),
    ];
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is GetSubsState) {
            isSubscribe = state.result;
          }
        },
        builder: (context, state) {
          return MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Scaffold(
              appBar: context.materialYouAppBar(
                realName(widget.profile.username, widget.profile.firstName,
                    widget.profile.lastName),
                actions: [
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
                    return [
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
                            expandedHeight:
                                !widget.profile.cover!.contains('default.png')
                                    ? 370
                                    : 250,
                            flexibleSpace: FlexibleSpaceBar(
                              collapseMode: CollapseMode.pin,
                              background: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    if (!widget.profile.cover!
                                        .contains('default.png'))
                                      SizedBox(
                                          width: double.infinity,
                                          height: 120,
                                          child: KhmertracksImage(
                                            imageUrl: widget.profile.cover!,
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
                                              imageUrl: widget.profile.image!,
                                              placeholderImage:
                                                  Images.defalultArtistCover,
                                            )),
                                      ),
                                    ),
                                    Text(
                                      realName(
                                          widget.profile.username,
                                          widget.profile.firstName,
                                          widget.profile.lastName),
                                      style: context.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "@${widget.profile.username}",
                                      style: context.titleSmall?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant),
                                    ),
                                    if (accountJson != '')
                                      SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ElevatedButton.icon(
                                              icon: Icon(
                                                isSubscribe
                                                    ? FluentIcons
                                                        .person_delete_24_filled
                                                    : FluentIcons
                                                        .add_24_regular,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                              onPressed: () {
                                                HapticFeedback.mediumImpact();
                                                authBloc.add(AddSubsEvent(
                                                    widget.profile.id!,
                                                    'user'));
                                              },
                                              label: Text(
                                                  isSubscribe
                                                      ? context.loc.unSubscribe
                                                      : context.loc.subscribe,
                                                  style: context.titleSmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface))),
                                        ),
                                      )
                                    else
                                      SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ElevatedButton.icon(
                                              icon: Icon(
                                                FluentIcons.add_24_regular,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary),
                                              onPressed: () {
                                                context.pushNamed(loginName,
                                                    extra: true);
                                              },
                                              label: Text(context.loc.subscribe,
                                                  style: context.titleSmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                      SubscriptionsWidget(profileId: widget.profile.id!),
                      SubscribersWidget(profileId: widget.profile.id!),
                      LikesWidget(profileId: widget.profile.id!),
                      ProfilePlaylistsWidget(profileId: widget.profile.id!),
                      AboutWidget(profile: widget.profile)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
