import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/enum/page_type.dart';
import 'package:flutter_music_pro/src/presentation/home/widgets/content_widget.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/my_music_detail_page.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/show_songs.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/custom_album_page.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/custom_artist_page.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/custom_production_page.dart';
import 'package:flutter_music_pro/src/utils/helper/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_music_pro/src/data/album/model/album.dart';
import 'package:flutter_music_pro/src/data/artist/model/artist.dart';
import 'package:flutter_music_pro/src/data/production/model/production.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/account/pages/account_page.dart';
import 'package:flutter_music_pro/src/presentation/account/pages/delete_account_page.dart';
import 'package:flutter_music_pro/src/presentation/account/pages/edit_bio_page.dart';
import 'package:flutter_music_pro/src/presentation/account/pages/change_password_page.dart';
import 'package:flutter_music_pro/src/presentation/account/pages/edit_social_page.dart';
import 'package:flutter_music_pro/src/presentation/account/pages/edit_profile_page.dart';
import 'package:flutter_music_pro/src/presentation/album/pages/album_detail_page.dart';
import 'package:flutter_music_pro/src/presentation/album/pages/production_albums.dart';
import 'package:flutter_music_pro/src/presentation/artist/pages/all_artist_albums_page.dart';
import 'package:flutter_music_pro/src/presentation/artist/pages/all_artist_songs_page.dart';
import 'package:flutter_music_pro/src/presentation/artist/pages/artist_page.dart';
import 'package:flutter_music_pro/src/presentation/artist/pages/artist_scrobbles.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/all_album_page.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/all_artist_page.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/all_playlist_page.dart';
import 'package:flutter_music_pro/src/presentation/explorer/pages/all_production_page.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/downloads_page.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/likes_tracks.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/nowplaying.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/user_playlist_page.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/recent.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/my_music_page.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/stream_page.dart';
import 'package:flutter_music_pro/src/presentation/library/pages/subscriptions_page.dart';
import 'package:flutter_music_pro/src/presentation/login/intro/intro_page.dart';
import 'package:flutter_music_pro/src/presentation/login/pages/login_page.dart';
import 'package:flutter_music_pro/src/presentation/login/pages/sign_up_page.dart';
import 'package:flutter_music_pro/src/presentation/player/pages/audioplayer.dart';
import 'package:flutter_music_pro/src/presentation/playlist/page/playlist_page.dart';
import 'package:flutter_music_pro/src/presentation/profile/pages/profile_page.dart';
import 'package:flutter_music_pro/src/presentation/search/pages/search_page.dart';
import 'package:flutter_music_pro/src/presentation/settings/pages/personalize_page.dart';
import 'package:flutter_music_pro/src/presentation/settings/pages/setting_page.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:video_player/video_player.dart';
import '../core/enum/box_types.dart';
import '../data/playlist/model/playlist.dart';
import '../presentation/home/pages/home_page.dart';

final settings = Hive.box(BoxType.settings.name);
final account = Hive.box(BoxType.account.name);

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

final GoRouter goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: homePagePath,
  errorBuilder: (context, state) => Center(
    child: Text(state.error.toString()),
  ),
  observers: [HeroController()],
  refreshListenable: settings.listenable(),
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: loginName,
      path: loginPath,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final videoPlayerController =
            extras['videoPlayerController'] as VideoPlayerController;
        final isLoggedIn = extras['isLoggedIn'] as bool;
        return IntroPage(
          controller: videoPlayerController,
          showBackButton: isLoggedIn,
        );
      },
    ),
    GoRoute(
      path: signInPath,
      name: signInName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: signUpPath,
      name: signUpName,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SignUpPage(),
    ),
    StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state,
            StatefulNavigationShell navigationShell) {
          return HomePage(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
              navigatorKey: _sectionANavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: homePagePath,
                  builder: (BuildContext context, GoRouterState state) =>
                      ContentWidget(currentPage: PageType.explorer.toIndex),
                ),
              ]),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: latestPagePath,
                builder: (BuildContext context, GoRouterState state) =>
                    ContentWidget(currentPage: PageType.latest.toIndex),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: popularPagePath,
                builder: (BuildContext context, GoRouterState state) =>
                    ContentWidget(currentPage: PageType.popular.toIndex),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: randomPagePath,
                  builder: (BuildContext context, GoRouterState state) =>
                      ContentWidget(currentPage: PageType.random.toIndex)),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                  path: libraryPagePath,
                  builder: (BuildContext context, GoRouterState state) =>
                      ContentWidget(currentPage: PageType.library.toIndex)),
            ],
          ),
        ]),
    GoRoute(
        name: landingName,
        path: landingPath,
        builder: (context, state) => const SizedBox(),
        routes: [
          GoRoute(
            path: allArtistPath,
            name: allArtistPath,
            builder: (context, state) =>
                AllArtistPage(title: state.extra as String),
          ),
          GoRoute(
            path: '$customArtistPath/:title',
            name: customArtistPath,
            builder: (context, state) => CustomArtistPage(
                listArtists: state.extra as List<Artist>,
                title: state.pathParameters['title']!),
          ),
          GoRoute(
            path: '$allPlaylistsPath/:title',
            name: allPlaylistsPath,
            builder: (context, state) => AllPlaylistsPage(
                listPlaylists: state.extra as List<Playlist>,
                title: state.pathParameters['title']!),
          ),
          GoRoute(
            path: allAlbumPath,
            name: allAlbumPath,
            builder: (context, state) => const AllAlbumPage(),
          ),
          GoRoute(
            path: '$customAlbumPath/:title',
            name: customAlbumPath,
            builder: (context, state) => CustomAlbumPage(
                listAlbums: state.extra as List<Album>,
                title: state.pathParameters['title']!),
          ),
          GoRoute(
              path: allProductionPath,
              name: allProductionPath,
              builder: (context, state) =>
                  AllProductionPage(title: state.extra as String)),
          GoRoute(
              path: '$customProductionPath/:title',
              name: customProductionPath,
              builder: (context, state) => CustomProductionPage(
                  listProductions: state.extra as List<Production>,
                  title: state.pathParameters['title']!)),
          GoRoute(
              path: artistPath,
              name: artistPath,
              builder: (context, state) =>
                  ArtistPage(artists: state.extra as Artist)),
          GoRoute(
              path: allArtistAlbumsPath,
              name: allArtistAlbumsPath,
              builder: (context, state) =>
                  AllArtistAlbumsPage(artist: state.extra as Artist)),
          GoRoute(
              path: allArtistSongsPath,
              name: allArtistSongsPath,
              builder: (context, state) =>
                  AllArtistSongPage(artist: state.extra as Artist)),
          GoRoute(
              path: albumSongsPath,
              name: albumSongsPath,
              builder: (context, state) =>
                  AlbumDetailPage(album: state.extra as Album)),
          GoRoute(
              path: playerPath,
              name: playerPath,
              builder: (context, state) => const PlayScreen()),
          GoRoute(
              path: 'view-playlist/:action',
              name: viewPlaylistsPath,
              builder: (context, state) => PlaylistPage(
                  playlist: state.extra as Playlist,
                  action: state.pathParameters['action']!)),
          GoRoute(
              path: viewProfilePath,
              name: viewProfilePath,
              builder: (context, state) =>
                  ProfilePage(profile: state.extra as Profile)),
          GoRoute(
              path: artistFollowersPath,
              name: artistFollowersPath,
              builder: (context, state) =>
                  ArtistScrobbles(artist: state.extra as Artist)),
          GoRoute(
              path: likesPath,
              name: likesPath,
              builder: (context, state) =>
                  LikesTracks(profileId: state.extra as int)),
          GoRoute(
              path: myMusicPath,
              name: myMusicName,
              builder: (context, state) => const MyMusicPage()),
          GoRoute(
              path: '$myMusicDetailPath/:title',
              name: myMusicDetailName,
              builder: (context, state) => MyMusicDetailPage(
                    cachedSongs: state.extra as List<SongModel>?,
                    title: state.pathParameters['title'],
                  )),
          GoRoute(
              path: downloadsPath,
              name: downloadsPath,
              builder: (context, state) => const DownloadsPage()),
          GoRoute(
              path: recentlyPath,
              name: recentlyPath,
              builder: (context, state) => const RecentlyPlayed()),
          GoRoute(
              path: nowPlayingPath,
              name: nowPlayingPath,
              builder: (context, state) => const NowPlaying()),
          GoRoute(
              path: streamPath,
              name: streamPath,
              builder: (context, state) => const StreamPage()),
          GoRoute(
              path: subscriptionsPath,
              name: subscriptionsPath,
              builder: (context, state) => const SubscriptionsPage()),
          GoRoute(
              path: userPlaylistName,
              name: userPlaylistName,
              builder: (context, state) =>
                  UserPlaylistPage(profile: state.extra as Profile)),
          GoRoute(
              path: searchPath,
              name: searchPath,
              builder: (context, state) => const SearchPage()),
          GoRoute(
              path: settingsPath,
              name: settingsPath,
              builder: (context, state) => const SettingsPage(),
              routes: [
                GoRoute(
                    path: personalizeName,
                    name: personalizePath,
                    builder: (context, state) => const PersonalizePage()),
              ]),
          GoRoute(
              path: viewProductionAlbumsPath,
              name: viewProductionAlbumsPath,
              builder: (context, state) =>
                  ProductionAlbumsPage(productions: state.extra as Production)),
          GoRoute(
              path: accountPath,
              name: accountPath,
              builder: (context, state) => const AccountPage()),
          GoRoute(
              path: editProfilePath,
              name: editProfilePath,
              builder: (context, state) =>
                  EditProfilePage(profile: state.extra as Profile)),
          GoRoute(
              path: editBioPath,
              name: editBioPath,
              builder: (context, state) =>
                  EditBioPage(profile: state.extra as Profile)),
          GoRoute(
              path: editSocialPath,
              name: editSocialPath,
              builder: (context, state) =>
                  EditSocialPage(profile: state.extra as Profile)),
          GoRoute(
              path: changePasswordPath,
              name: changePasswordPath,
              builder: (context, state) => const ChangePasswordPage()),
          GoRoute(
              path: deleteAccountPath,
              name: deleteAccountPath,
              builder: (context, state) => const DeleteAccountPage()),
          GoRoute(
              path: 'show-song/:type/:title',
              name: showSongName,
              builder: (context, state) => ShowSongs(
                    data: state.extra as List,
                    offline: state.pathParameters['type']!,
                    title: state.pathParameters['title']!,
                  )),
        ])
  ],
);
