import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/presentation/widgets/animated_text.dart';
import 'package:zmare/src/service_locator.dart';

import '../../utils/helper/dominant_color.dart';

class MiniPlayer extends StatefulWidget {
  static const MiniPlayer _instance = MiniPlayer._internal();

  factory MiniPlayer() {
    return _instance;
  }

  const MiniPlayer._internal();

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  final ValueNotifier<List<Color?>?> gradientColor =
      ValueNotifier(defaultGradientColor);
  final ValueNotifier<String> currentRouteNotifier = ValueNotifier<String>('');
  AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  Box<dynamic> playerSettings = locator.get(
    instanceName: BoxType.settings.name,
  );

  @override
  void initState() {
    super.initState();
    // Add a listener to GoRouter for route changes
    GoRouter.of(rootNavigatorKey.currentContext!)
        .routerDelegate
        .addListener(_onRouteChanged);
    // Initialize the current route
    _onRouteChanged();
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    GoRouter.of(rootNavigatorKey.currentContext!)
        .routerDelegate
        .removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onRouteChanged() {
    final currentRoute = GoRouter.of(rootNavigatorKey.currentContext!)
        .routeInformationProvider
        .value
        .location;
    currentRouteNotifier.value = currentRoute;
  }

  final showMiniPlayer = locator.get<Box<dynamic>>(
    instanceName: BoxType.showMiniPlayer.name,
  );
  final stickToBottomRoutes = [
    '/homepage',
    '/library',
    '/popular',
    '/latest',
    '/login',
  ];

  final List<String> hideMiniPlayerRoutes = [
    '/landing/player',
    '/landing/settings',
    '/login'
    // '/settings',
    // '/homepage',
    // '/latest',
    // '/popular',
    // '/library',
  ];

  Color dominantColor = Colors.black;
  void updateBackgroundColors(List<Color?> value) {
    setState(() {
      gradientColor.value = value;
    });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: currentRouteNotifier,
        builder: (context, currentRoute, _) {
          print("Current route: $currentRoute");
          if (hideMiniPlayerRoutes.contains(currentRoute)) {
            return const SizedBox();
          }

          return StreamBuilder<PlaybackState>(
            stream: audioHandler.playbackState,
            builder: (context, snapshot) {
              return StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (context, snapshot) {
                  final MediaItem? mediaItem = snapshot.data;
                  if (snapshot.connectionState != ConnectionState.active) {
                    return const SizedBox();
                  }
                  if (mediaItem == null) return const SizedBox();
                  final bool isLocal =
                      mediaItem.artUri?.toString().startsWith('file:') ?? false;
                  mediaItem.artUri.toString().startsWith('file')
                      ? getColors(
                          imageProvider: FileImage(
                            File(
                              mediaItem.artUri!.toFilePath(),
                            ),
                          ),
                        ).then((value) => updateBackgroundColors(value))
                      : getColors(
                          imageProvider: CachedNetworkImageProvider(
                            mediaItem.artUri.toString(),
                          ),
                        ).then((value) => updateBackgroundColors(value));

                  return ValueListenableBuilder(
                    valueListenable: playerSettings.listenable(),
                    builder: (BuildContext context, Box box1, Widget? child) {
                      final bool extraControls =
                          box1.get(extraControlsKey, defaultValue: true);
                      return ValueListenableBuilder(
                          valueListenable: gradientColor,
                          builder: (context, value, child) {
                            dominantColor =
                                value?[0] ?? const Color(0xff2e2a33);
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? [
                                                value?[0] ??
                                                    const Color(0xff2e2a33),
                                                value?[1] ??
                                                    const Color(0xff141216)
                                              ]
                                            : [
                                                value?[0] ??
                                                    const Color(0xff2e2a33),
                                                const Color.fromARGB(
                                                    255, 205, 201, 201),
                                              ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 0.0,
                                  vertical: 0.0,
                                ),
                                child: SizedBox(
                                  height: 57,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                        ),
                                        child: ListTile(
                                          minLeadingWidth: 0.0,
                                          splashColor: Colors.transparent,
                                          contentPadding: EdgeInsets.zero,
                                          onTap: () {
                                            GoRouter.of(rootNavigatorKey
                                                    .currentContext!)
                                                .pushNamed(playerPath);
                                            // rootNavigatorKey.currentState?.push(
                                            //   PageRouteBuilder(
                                            //     opaque: false,
                                            //     pageBuilder: (_, __, ___) =>
                                            //         const PlayScreen(),
                                            //   ),
                                            // );
                                          },
                                          title: AnimatedText(
                                              text:
                                                  '${mediaItem.title} • ${mediaItem.artist}',
                                              pauseAfterRound:
                                                  const Duration(seconds: 3),
                                              defaultAlignment: TextAlign.left,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              showFadingOnlyWhenScrolling:
                                                  false,
                                              fadingEdgeEndFraction: 0.1,
                                              fadingEdgeStartFraction: 0.1,
                                              style:
                                                  context.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Washera',
                                              )),
                                          leading: Hero(
                                            tag: 'currentArtwork',
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, top: 5),
                                              child: Card(
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30 - .0),
                                                ),
                                                clipBehavior: Clip.antiAlias,
                                                child: isLocal
                                                    ? SizedBox.square(
                                                        dimension: 45.0,
                                                        child: Image(
                                                          fit: BoxFit.cover,
                                                          image: FileImage(
                                                            File(mediaItem
                                                                .artUri!
                                                                .toFilePath()),
                                                          ),
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Image(
                                                              fit: BoxFit.cover,
                                                              image: AssetImage(
                                                                  Images
                                                                      .defalutCover),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : SizedBox.square(
                                                        dimension: 45,
                                                        child: ZmareImage(
                                                            imageUrl: mediaItem
                                                                .artUri
                                                                .toString(),
                                                            placeholderImage: Images
                                                                .defalutCover)),
                                              ),
                                            ),
                                          ),
                                          trailing: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    extraControls ? 0 : 10),
                                            child: ControlButtons(audioHandler,
                                                dominantColor: dominantColor,
                                                miniplayer: true,
                                                buttons: extraControls
                                                    ? [
                                                        'Previous',
                                                        'Play/Pause',
                                                        'Next'
                                                      ]
                                                    : ['Play/Pause']),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  );
                },
              );
            },
          );
        });
  }
}
