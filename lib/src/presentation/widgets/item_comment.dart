import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/data/track/model/response/load_comment_response.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/ext/string_extensions.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';

import 'package:zmare/src/presentation/widgets/texts/zmare_title.dart';

class ItemComment extends StatefulWidget {
  const ItemComment(
      {super.key,
      required this.comment,
      required this.onDeleteCallBack,
      required this.onEditCallBack,
      required this.itemIndex});
  final Comment comment;
  final int itemIndex;
  final Function(int value) onDeleteCallBack;
  final Function(int value, String message) onEditCallBack;
  @override
  State<ItemComment> createState() => _ItemCommentState();
}

class _ItemCommentState extends State<ItemComment> {
  final accountJson = account.get(accountDetail, defaultValue: '');
  Profile? profile = Profile();

  @override
  void initState() {
    if (accountJson != '') {
      profile = Profile.fromJson(accountJson);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
            mainAxisAlignment: profile!.id == widget.comment.user!.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // spacing: 10,
            children: profile!.id == widget.comment.user!.id
                ? [
                    Column(
                      crossAxisAlignment: profile!.id == widget.comment.user!.id
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          realName(
                              widget.comment.user!.username,
                              widget.comment.user!.firstName,
                              widget.comment.user!.lastName),
                          style: context.titleSmall!.copyWith(fontSize: 12),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(
                                profile!.id == widget.comment.user!.id
                                    ? 0
                                    : 10),
                            topLeft: Radius.circular(
                                profile!.id == widget.comment.user!.id
                                    ? 10
                                    : 0),
                          ),
                          child: Container(
                              color: profile!.id != widget.comment.user!.id
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7)
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ZmareTitle(
                                        widget.comment.message,
                                        maxLines: 10,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        date(widget.comment.time!),
                                        style: TextStyle(
                                            color: context.onSurface,
                                            fontSize: 10),
                                      )
                                    ]),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipOval(
                        child: ZmareImage(
                          imageUrl: widget.comment.user!.image!,
                          placeholderImage: "../../../../assets/artist.png",
                        ),
                      ),
                    ),
                  ]
                : [
                    Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ClipOval(
                            child: ZmareImage(
                              imageUrl: widget.comment.user!.image!,
                              placeholderImage: "../../../../assets/artist.png",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: profile!.id == widget.comment.user!.id
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          realName(
                              widget.comment.user!.username,
                              widget.comment.user!.firstName,
                              widget.comment.user!.lastName),
                          style: context.titleSmall!.copyWith(fontSize: 12),
                        ),
                        // const SizedBox(
                        //   height: 8,
                        // ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(
                                profile!.id == widget.comment.user!.id
                                    ? 0
                                    : 10),
                            topLeft: Radius.circular(
                                profile!.id == widget.comment.user!.id
                                    ? 10
                                    : 0),
                          ),
                          child: Container(
                              color: profile!.id != widget.comment.user!.id
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.7)
                                  : Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ZmareTitle(
                                        widget.comment.message,
                                        maxLines: 10,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        date(widget.comment.time!),
                                        style: TextStyle(
                                            color: context.onSurface,
                                            fontSize: 10),
                                      )
                                    ]),
                              )),
                        ),
                      ],
                    ),
                  ]));
  }

  String date(String date) {
    return DateFormat("d, MMM yyyy").format(DateTime.parse(date).toLocal());
  }
}
