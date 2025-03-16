import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/core/enum/favorite_type.dart';
import 'package:zmare/src/utils/helper/playlist.dart';
import 'package:zmare/src/data/like/model/like_dislike.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/snackbar.dart';
import 'package:zmare/src/service_locator.dart';

class LikeButton extends StatefulWidget {
  final MediaItem? mediaItem;
  final double? size;
  final Map? data;
  final bool showSnack;
  const LikeButton({
    super.key,
    required this.mediaItem,
    this.size,
    this.data,
    this.showSnack = false,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  bool liked = false;
  bool show = false;
  late AnimationController _controller;
  late Animation<double> _scale;
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final accountJson = account.get(accountDetail, defaultValue: '');

  @override
  void initState() {
    super.initState();
    show = accountJson != '';
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.slowMiddle));

    if (show) {
      authBloc.add(CheckFavoriteEvent(int.parse(
        widget.mediaItem?.id ?? widget.data!['id'].toString(),
      )));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authBloc,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is CheckFavoriteState) {
            liked = state.favorite;
          }
          return Visibility(
            visible: show,
            child: ScaleTransition(
              scale: _scale,
              child: IconButton(
                icon: Icon(
                  liked
                      ? FluentIcons.heart_48_filled
                      : FluentIcons.heart_48_regular,
                  color: liked
                      ? Colors.redAccent
                      : Theme.of(context).colorScheme.secondary,
                ),
                iconSize: widget.size ?? 24.0,
                tooltip: liked ? context.loc.unlike : context.loc.like,
                onPressed: () async {
                  final trackId =
                      widget.mediaItem?.id ?? widget.data!['id'].toString();
                  authBloc.add(LikeTrackEvent(LikeAndDislike(
                    trackId: trackId,
                    type: liked
                        ? FavoriteType.dislike.toInt
                        : FavoriteType.like.toInt,
                  )));

                  if (!liked) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                  setState(() {
                    liked = !liked;
                  });

                  if (widget.showSnack) {
                    ShowSnackBar().showSnackBar(
                      context,
                      liked
                          ? context.loc.addedToFav
                          : context.loc.removedFromFav,
                      action: SnackBarAction(
                        textColor: Theme.of(context).colorScheme.secondary,
                        label: context.loc.undo,
                        onPressed: () {
                          if (liked) {
                            removeLiked(trackId);
                          } else {
                            widget.mediaItem == null
                                ? addMapToPlaylist(
                                    BoxType.favorite.name, widget.data!)
                                : addItemToPlaylist(
                                    BoxType.favorite.name, widget.mediaItem!);
                          }
                          setState(() {
                            liked = !liked;
                          });
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
