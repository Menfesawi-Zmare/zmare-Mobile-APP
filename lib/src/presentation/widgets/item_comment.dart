import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/data/track/model/response/load_comment_response.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/textinput_dialog.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
          visualDensity: const VisualDensity(vertical: 4),
          minVerticalPadding: 0,
          leading: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: ClipOval(
                  child: KhmertracksImage(
                    imageUrl: widget.comment.user!.image!,
                    placeholderImage: Images.defalultArtistCover,
                  ),
                ),
              ),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.cornerRadius),
                child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KhmertracksTitle(realName(
                                widget.comment.user!.username,
                                widget.comment.user!.firstName,
                                widget.comment.user!.lastName)),
                            const SizedBox(
                              height: 8,
                            ),
                            KhmertracksTitle(
                              widget.comment.message,
                              maxLines: 10,
                            )
                          ]),
                    )),
              ),
            ],
          ),
          trailing: profile!.id == widget.comment.user!.id
              ? Wrap(
                  children: [
                    IconButton(
                        onPressed: () => showTextInputDialog(
                              context: context,
                              keyboardType: TextInputType.text,
                              title: context.loc.edit,
                              initialText: widget.comment.message,
                              onSubmitted: (String value) async {
                                widget.onEditCallBack(widget.itemIndex, value);
                              },
                            ),
                        icon: const Icon(FluentIcons.edit_24_regular)),
                    IconButton(
                        onPressed: () =>
                            widget.onDeleteCallBack(widget.itemIndex),
                        icon: const Icon(FluentIcons.delete_24_regular))
                  ],
                )
              : const SizedBox(),
        ));
  }
}
