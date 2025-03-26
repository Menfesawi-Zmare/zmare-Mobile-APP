import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
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
  late String? isMandatoryInt;

  bool isPlayerVisisble = true;
  bool _shouldShowMiniPlayer = true;

  @override
  void initState() {
    super.initState();
    isMandatoryInt = settings.get(isMandatory);
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

    // Update visibility based on route
    final hideMiniPlayerRoutes = [
      '/landing/player',
      '/landing/settings',
      '/login',
      '/signin',
      '/landing/reset',
      '/landing/otpPath',
      '/landing/resetPage',
      '/signup',
      '/onboarding'
    ];

    setState(() {
      _shouldShowMiniPlayer = !hideMiniPlayerRoutes.contains(currentRoute);
    });
  }

  final showMiniPlayer = locator.get<Box<dynamic>>(
    instanceName: BoxType.showMiniPlayer.name,
  );

  Color dominantColor = Colors.black;
  void updateBackgroundColors(List<Color?> value) {
    setState(() {
      gradientColor.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    if (isPlayerVisisble) {
      return ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: 45 + 10 + 10),
        child: Material(
          color: Colors.transparent,
          child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
=======
    if (!_shouldShowMiniPlayer) {
      return const SizedBox();
    }
    if (isMandatoryInt != null && isMandatoryInt == "1") {
      return const SizedBox();
    }

    return ValueListenableBuilder<String>(
      valueListenable: currentRouteNotifier,
      builder: (context, currentRoute, _) {
        if (isPlayerVisisble) {
          return ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 45 + 10 + 10),
            child: Material(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
>>>>>>> 4e8a02c82ad7e17b0e31eba26016194800dd7dc1
                  onTap: () {
                    toogleVisibility();
                  },
                  child: StreamBuilder<MediaItem?>(
                    stream: audioHandler.mediaItem,
                    builder: (context, snapshot) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: context.surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                        height: 45,
                        width: 45,
                        child: RiveAnimatedIcon(
                          riveIcon: RiveIcon.sound,
                          width: 10,
                          height: 10,
                          color: context.colorScheme.primary,
                          strokeWidth: 10,
                          loopAnimation: true,
                          onTap: () {
                            toogleVisibility();
                          },
                          onHover: (value) {},
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        } else {
          return Material(
            child: Dismissible(
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                toogleVisibility();
              },
              key: Key("mini_player_dismissible"),
              child: StreamBuilder<PlaybackState>(
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
                          mediaItem.artUri?.toString().startsWith('file:') ??
                              false;
                      mediaItem.artUri.toString().startsWith('file')
                          ? getColors(
                              imageProvider: FileImage(
                                File(mediaItem.artUri!.toFilePath()),
                              ),
                            ).then((value) => updateBackgroundColors(value))
                          : getColors(
                              imageProvider: CachedNetworkImageProvider(
                                mediaItem.artUri.toString(),
                              ),
                            ).then((value) => updateBackgroundColors(value));

                      return ValueListenableBuilder(
                        valueListenable: playerSettings.listenable(),
                        builder:
                            (BuildContext context, Box box1, Widget? child) {
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
                                            ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
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
                                          child: GestureDetector(
                                            onTap: () {
                                              GoRouter.of(rootNavigatorKey
                                                      .currentContext!)
                                                  .pushNamed(playerPath);
                                            },
                                            child: ListTile(
                                              minLeadingWidth: 0.0,
                                              splashColor: Colors.transparent,
                                              contentPadding: EdgeInsets.zero,
                                              title: AnimatedText(
                                                text:
                                                    '${mediaItem.title} • ${mediaItem.artist}',
                                                pauseAfterRound:
                                                    const Duration(seconds: 3),
                                                defaultAlignment:
                                                    TextAlign.left,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                showFadingOnlyWhenScrolling:
                                                    false,
                                                fadingEdgeEndFraction: 0.1,
                                                fadingEdgeStartFraction: 0.1,
                                                style: context.titleMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Washera',
                                                ),
                                              ),
                                              leading: Hero(
                                                tag: 'currentArtwork',
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30 - .0),
                                                    ),
                                                    clipBehavior:
                                                        Clip.antiAlias,
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
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return const Image(
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                              placeholderImage:
                                                                  Images
                                                                      .defalutCover,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              trailing: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        extraControls ? 0 : 10),
                                                child: ControlButtons(
                                                  audioHandler,
                                                  dominantColor: dominantColor,
                                                  miniplayer: true,
                                                  buttons: extraControls
                                                      ? [
                                                          'Previous',
                                                          'Play/Pause',
                                                          'Next'
                                                        ]
                                                      : ['Play/Pause'],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          );
        }
      },
    );
  }

  void toogleVisibility() {
    setState(() {
      isPlayerVisisble = !isPlayerVisisble;
    });
  }
}
