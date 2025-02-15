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
  late Animation<double> _curve;
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final accountJson = account.get(accountDetail, defaultValue: '');
  @override
  void initState() {
    super.initState();
    if (accountJson != '') {
      show = true;
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _curve = CurvedAnimation(parent: _controller, curve: Curves.slowMiddle);

    _scale = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0),
        weight: 50,
      ),
    ]).animate(_curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (show) {
      authBloc.add(CheckFavoriteEvent(int.parse(
        widget.mediaItem == null
            ? widget.data!['id'].toString()
            : widget.mediaItem!.id,
      )));
    }
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer(
        bloc: authBloc,
        listener: (context, state) {
          if (state is CheckFavoriteState) {
            liked = state.favorite;
          }
          if (state is LikeState) {
            authBloc.add(CheckFavoriteEvent(int.parse(
              widget.mediaItem == null
                  ? widget.data!['id'].toString()
                  : widget.mediaItem!.id,
            )));
          }
        },
        builder: (context, state) {
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
                  liked
                      ? authBloc.add(LikeTrackEvent(LikeAndDislike(
                          trackId: widget.mediaItem == null
                              ? widget.data!['id'].toString()
                              : widget.mediaItem!.id,
                          type: FavoriteType.dislike.toInt)))
                      : authBloc.add(LikeTrackEvent(LikeAndDislike(
                          trackId: widget.mediaItem == null
                              ? widget.data!['id'].toString()
                              : widget.mediaItem!.id,
                          type: FavoriteType.like.toInt)));

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
                          liked
                              ? removeLiked(
                                  widget.mediaItem == null
                                      ? widget.data!['id'].toString()
                                      : widget.mediaItem!.id,
                                )
                              : widget.mediaItem == null
                                  ? addMapToPlaylist(
                                      BoxType.favorite.name, widget.data!)
                                  : addItemToPlaylist(
                                      BoxType.favorite.name,
                                      widget.mediaItem!,
                                    );

                          liked = !liked;
                          setState(() {});
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
