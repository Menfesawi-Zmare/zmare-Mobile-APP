import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/data/song/model/item_song_model.dart';
import 'package:flutter_music_pro/src/data/track/model/response/load_comment_response.dart';
import 'package:flutter_music_pro/src/presentation/track/bloc/track_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/item_comment.dart';
import 'package:flutter_music_pro/src/presentation/widgets/no_comment_widget.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ModalComment extends StatefulWidget {
  const ModalComment({super.key, required this.track});
  final ItemSongModel track;
  @override
  State<ModalComment> createState() => _ModalCommentState();
}

class _ModalCommentState extends State<ModalComment> {
  final TrackBloc trackBloc = locator.get<TrackBloc>();
  List<Comment> listComment = [];
  final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final commentController = TextEditingController();
  final accountJson = account.get(accountDetail, defaultValue: '');
  Profile? profile = Profile();
  int? itemIndex;
  @override
  void initState() {
    if (accountJson != '') {
      profile = Profile.fromJson(accountJson);
    }
    _pagingController.addPageRequestListener((pageKey) {
      trackBloc.add(LoadTrackCommentEvent(widget.track.id!, pageKey));
    });
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        strokeWidth: 2.0,
        onRefresh: () async {
          trackBloc.add(LoadTrackCommentEvent(widget.track.id!, 1));
          _pagingController.refresh();
        },
        child: Scaffold(
        appBar: context.materialYouAppBar(
          context.loc.comment,
          leadingWidget: IconButton(
              onPressed: () => context.pop(), icon: const Icon(Icons.close)),
        ),
        body: BlocProvider(
          create: (context) => trackBloc,
          child: BlocListener(
            bloc: trackBloc,
            listener: (context, state) {
              if (state is LoadTrackCommentState) {
                listComment = state.loadCommentResponse.data!;
                final isLastPage = listComment.length <
                    state.loadCommentResponse.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController.appendLastPage(listComment);
                } else {
                  _pagingController.appendPage(listComment,
                      state.loadCommentResponse.pagination!.currentPage! + 1);
                }
              }
              if (state is AddTrackCommentState) {
                FocusScope.of(context).unfocus();
                commentController.text = '';
                _pagingController.refresh();
              }
              if (state is TrackFailedState) {
                _pagingController.error = state;
              }
              if (state is TrackNoData) {
                _pagingController.itemList = [];
              }
              if (state is DeleteTrackCommentState) {
                if (itemIndex != null && state.result == true) {
                  setState(() {
                    _pagingController.itemList!.removeAt(itemIndex!);
                  });
                }
              }
              if (state is EditTrackCommentState) {
                if (itemIndex != null && state.commentResponse.status == true) {
                  setState(() {
                    _pagingController.itemList![itemIndex!].message =
                        state.commentResponse.message!;
                  });
                }
              }
            },
            child: PagedListView<int, Comment>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Comment>(
                  noItemsFoundIndicatorBuilder: (context) =>
                      Center(child: NoCommentWidget(onTap: () => _pagingController.refresh())),
                  itemBuilder: (context, item, index) {
                    return ItemComment(
                        comment: item,
                        itemIndex: index,
                        onDeleteCallBack: (int value) {
                          trackBloc.add(DeleteTrackCommentEvent(
                              _pagingController.itemList![value].id!));
                          setState(() {
                            itemIndex = value;
                          });
                        },
                        onEditCallBack: (int value, String message) {
                          trackBloc.add(EditTrackCommentEvent(_pagingController.itemList![value].id!, message));
                          setState(() {
                            itemIndex = value;
                            _pagingController.itemList![itemIndex!].message = message;
                          });
                        });
                  }),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: accountJson != '' ? true : false,
          child: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            controller: commentController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 18.0, 30.0),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.transparent,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.transparent,
                ),
              ), // OutlineInputBorder
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.transparent,
                ),
              ),
              // prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(FluentIcons.send_24_regular),
                onPressed: () {
                  trackBloc.add(AddTrackCommentEvent(
                      widget.track.id!, commentController.text));
                },
              ),
              hintText: context.loc.comment,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.send,
            onSubmitted: (submittedQuery) {
              trackBloc.add(
                  AddTrackCommentEvent(widget.track.id!, commentController.text));
            },
          ),
        ),
      ),
    );
  }
}
