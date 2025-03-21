import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/core/enum/sub_type.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/ext/string_extensions.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/profile/widget/about_widget.dart';
import 'package:zmare/src/presentation/profile/widget/likes_widget.dart';
import 'package:zmare/src/presentation/profile/widget/profile_playlists_widget.dart';
import 'package:zmare/src/presentation/profile/widget/subscriber_widget.dart';
import 'package:zmare/src/presentation/profile/widget/subscriptions_widget.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';

import 'package:zmare/src/service_locator.dart';

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
              // appBar: context.materialYouAppBar(
              //   "",
              //   actions: [],
              // ),
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
                            actions: [
                              IconButton(
                                icon: Icon(
                                  FluentIcons.search_28_regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () {
                                  context.pushNamed(searchPath);
                                },
                              ),
                            ],
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
                                      Stack(
                                        children: [
                                          Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 30),
                                              width: double.infinity,
                                              height: 250,
                                              child: ZmareImage(
                                                imageUrl: widget.profile.cover!,
                                                placeholderImage:
                                                    Images.defalultArtistCover,
                                              )),
                                          Container(
                                            height: 250,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    end: Alignment.topCenter,
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    stops: [
                                                  0.12,
                                                  1.0,
                                                ],
                                                    colors: [
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .surface
                                                      .withOpacity(0.5),
                                                  // Colors.transparent
                                                ])),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: SizedBox(
                                                          width: 60,
                                                          height: 60,
                                                          child: ZmareImage(
                                                            imageUrl: widget
                                                                .profile.image!,
                                                            placeholderImage: Images
                                                                .defalultArtistCover,
                                                          )),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 16,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        realName(
                                                            widget.profile
                                                                .username!,
                                                            widget.profile
                                                                .firstName,
                                                            widget.profile
                                                                .lastName),
                                                        style: context
                                                            .headlineSmall!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                      ),
                                                      Text(
                                                        "@${widget.profile.username}",
                                                        style: context
                                                            .labelMedium
                                                            ?.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                                fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (accountJson != '')
                                      SizedBox(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 20),
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
