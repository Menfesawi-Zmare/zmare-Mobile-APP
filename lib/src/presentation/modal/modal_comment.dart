import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/data/song/model/item_song_model.dart';
import 'package:zmare/src/data/track/model/response/load_comment_response.dart';
import 'package:zmare/src/presentation/track/bloc/track_bloc.dart';
import 'package:zmare/src/presentation/widgets/item_comment.dart';
import 'package:zmare/src/presentation/widgets/no_comment_widget.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/foundation.dart' as foundation;

import '../widgets/textinput_dialog.dart';

class ModalComment extends StatefulWidget {
  const ModalComment({super.key, required this.track});
  final ItemSongModel track;
  @override
  State<ModalComment> createState() => _ModalCommentState();
}

class _ModalCommentState extends State<ModalComment> {
  final TrackBloc trackBloc = locator.get<TrackBloc>();
  final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 1);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final commentController = TextEditingController();
  final accountJson = account.get(accountDetail, defaultValue: '');
  Profile? profile;
  final _scrollController = ScrollController();
  bool _emojiShowing = false;
  int? itemIndex;
  bool isLongPressed = false;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    if (accountJson != '') {
      profile = Profile.fromJson(accountJson);
    }
    _pagingController.addPageRequestListener((pageKey) {
      trackBloc.add(LoadTrackCommentEvent(widget.track.id!, pageKey));
    });
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        if (_focusNode.hasFocus) {
          if (_emojiShowing) {
            FocusScope.of(context).unfocus();
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCommentSubmitted() {
    trackBloc
        .add(AddTrackCommentEvent(widget.track.id!, commentController.text));
  }

  void _onEditComment(int index, String message) {
    trackBloc.add(
        EditTrackCommentEvent(_pagingController.itemList![index].id!, message));
  }

  void _onDeleteComment(int index) {
    trackBloc
        .add(DeleteTrackCommentEvent(_pagingController.itemList![index].id!));
  }

  Widget _buildCommentActions(int index, Comment item) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: context.onPrimary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // spacing: 10,
        children: [
          InkWell(
            onTap: () {
              showTextInputDialog(
                context: context,
                keyboardType: TextInputType.text,
                title: context.loc.edit,
                initialText: item.message,
                onSubmitted: (String value) => _onEditComment(index, value),
              );
              setState(() => isLongPressed = false);
            },
            child: Row(
              // spacing: 10,
              children: [
                Icon(Icons.edit, size: 15),
                SizedBox(
                  width: 10,
                ),
                Text("Edit"),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _onDeleteComment(index);
              setState(() => isLongPressed = false);
            },
            child: Row(
              // spacing: 10,
              children: [
                Icon(Icons.delete, size: 15),
                SizedBox(
                  width: 10,
                ),
                Text("Delete"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(
      FocusNode focusNode, bool isFocused, BuildContext ctx) {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {
                    final isKeyboardVisible =
                        MediaQuery.of(context).viewInsets.bottom > 0;

                    if (isKeyboardVisible) {
                      // Hide keyboard and show emoji picker
                      FocusScope.of(context).unfocus();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _emojiShowing = true;
                        });
                      });
                    } else {
                      // Toggle emoji visibility
                      setState(() {
                        _emojiShowing = !_emojiShowing;
                      });

                      if (_emojiShowing) {
                        FocusScope.of(context).unfocus(); // Hide keyboard
                      } else {
                        FocusScope.of(context)
                            .requestFocus(focusNode); // Show keyboard
                      }
                    }
                  },
                  icon: Icon(
                    _emojiShowing ? Icons.keyboard : Icons.emoji_emotions,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: commentController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(16.0, 0.0, 18.0, 30.0),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(width: 1.5, color: Colors.transparent),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(FluentIcons.send_24_regular),
                      onPressed: _onCommentSubmitted,
                    ),
                    hintText: context.loc.comment,
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _onCommentSubmitted(),
                  onTap: () {
                    setState(() {
                      _emojiShowing =
                          false; // Hide emoji when tapping the input
                    });
                  },
                ),
              ),
            ],
          ),
          Offstage(
            offstage: !_emojiShowing,
            child: EmojiPicker(
              textEditingController: commentController,
              scrollController: _scrollController,
              config: Config(
                height: 256,
                checkPlatformCompatibility: true,
                viewOrderConfig: const ViewOrderConfig(),
                emojiViewConfig: EmojiViewConfig(
                  backgroundColor: ctx.surface,
                  gridPadding: EdgeInsets.all(5),
                  columns: 8,
                  recentsLimit: 10,
                  emojiSizeMax: 28 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.2
                          : 1.0),
                ),
                // emojiTextStyle: TextStyle(c),
                skinToneConfig: SkinToneConfig(
                    indicatorColor: ctx.onSurface, enabled: true),
                categoryViewConfig: CategoryViewConfig(
                    backgroundColor: ctx.surface,
                    dividerColor: ctx.onSurface,
                    indicatorColor: ctx.onSurface,
                    iconColorSelected: ctx.onSurface),
                bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: ctx.onPrimary, buttonColor: ctx.onPrimary),
                searchViewConfig: SearchViewConfig(
                  backgroundColor: ctx.onPrimary,
                  buttonIconColor: ctx.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        trackBloc.add(LoadTrackCommentEvent(widget.track.id!, 1));
        _pagingController.refresh();
      },
      child: Scaffold(
        appBar: context.materialYouAppBar(
          context.loc.comment,
          leadingWidget: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: BlocProvider(
          create: (context) => trackBloc,
          child: BlocListener<TrackBloc, TrackState>(
            listener: (context, state) {
              if (state is LoadTrackCommentState) {
                final isLastPage = state.loadCommentResponse.data!.length <
                    state.loadCommentResponse.pagination!.perPage!;
                if (isLastPage) {
                  _pagingController
                      .appendLastPage(state.loadCommentResponse.data!);
                } else {
                  _pagingController.appendPage(state.loadCommentResponse.data!,
                      state.loadCommentResponse.pagination!.currentPage! + 1);
                }
              } else if (state is AddTrackCommentState) {
                FocusScope.of(context).unfocus();
                commentController.clear();
                _pagingController.refresh();
              } else if (state is TrackFailedState) {
                _pagingController.error = state;
              } else if (state is TrackNoData) {
                _pagingController.itemList = [];
              } else if (state is DeleteTrackCommentState &&
                  itemIndex != null &&
                  state.result) {
                setState(
                    () => _pagingController.itemList!.removeAt(itemIndex!));
              } else if (state is EditTrackCommentState &&
                  itemIndex != null &&
                  state.commentResponse.status!) {
                setState(() => _pagingController.itemList![itemIndex!].message =
                    state.commentResponse.message!);
              }
            },
            child: GestureDetector(
              onTap: () => setState(() => isLongPressed = false),
              child: PagedListView<int, Comment>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Comment>(
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: NoCommentWidget(
                        onTap: () => _pagingController.refresh()),
                  ),
                  itemBuilder: (context, item, index) {
                    return Column(
                      children: [
                        InkWell(
                          onLongPress: () => setState(() {
                            isLongPressed = true;
                            itemIndex = index;
                          }),
                          child: ItemComment(
                            comment: item,
                            itemIndex: index,
                            onDeleteCallBack: _onDeleteComment,
                            onEditCallBack: _onEditComment,
                          ),
                        ),
                        if (itemIndex == index &&
                            isLongPressed &&
                            profile?.id == item.user?.id)
                          _buildCommentActions(index, item),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
          visible: accountJson != '',
          child: _buildCommentInput(_focusNode, _isFocused, context),
        ),
      ),
    );
  }
}
