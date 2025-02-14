import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/app/routes.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/texts/khmertracks_title.dart';

import 'texts/khmertracks_subtitle.dart';

class ItemProfile extends StatefulWidget {
  const ItemProfile({super.key, required this.profile});
  final Profile profile;

  @override
  State<ItemProfile> createState() => _ItemProfileState();
}

class _ItemProfileState extends State<ItemProfile> {
  final accountJson = account.get(accountDetail, defaultValue: '');
  Profile? profile = Profile();
  @override
  void initState() {
    if (accountJson != '') {
      profile = Profile?.fromJson(jsonDecode(jsonEncode(accountJson)));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.zero,
        child: ListTile(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          dense: true,
          contentPadding: const EdgeInsets.only(left: 10.0, right: 0.0),
          visualDensity: const VisualDensity(vertical: 4),
          horizontalTitleGap: 10.0,
          minVerticalPadding: 0,
          leading: Column(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: ClipOval(
                  child: KhmertracksImage(
                    imageUrl: widget.profile.image!,
                    placeholderImage: Images.defalultArtistCover,
                  ),
                ),
              ),
            ],
          ),
          title: KhmertracksTitle(realName(widget.profile.username,
              widget.profile.firstName, widget.profile.lastName)),
          subtitle: KhmertracksSubTitle(location(
              widget.profile.country ?? '', widget.profile.city ?? '')),
          trailing: IconButton(
              onPressed: () =>
                  context.pushNamed(viewProfilePath, extra: widget.profile),
              icon: const Icon(FluentIcons.chevron_right_28_regular)),
          onTap: () => profile!.id == widget.profile.id
              ? context.pushNamed(accountPath)
              : context.pushNamed(viewProfilePath, extra: widget.profile),
        ));
  }
}
