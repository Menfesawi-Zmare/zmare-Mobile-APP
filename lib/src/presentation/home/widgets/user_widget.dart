import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:video_player/video_player.dart';
import '../../../core/enum/box_types.dart';
import '../../../service_locator.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (p0) => ValueListenableBuilder(
            valueListenable: locator
                .get<Box<dynamic>>(instanceName: BoxType.account.name)
                .listenable(
              keys: [accountDetail],
            ),
            builder: (BuildContext context, value, Widget? child) {
              final accountJson = value.get(accountDetail, defaultValue: '');
              if (accountJson != '') {
                Profile? profile =
                    Profile?.fromJson(jsonDecode(jsonEncode(accountJson)));
                return InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.pushNamed(accountPath),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                          child: SizedBox.square(
                        dimension: 30,
                        child: KhmertracksImage(
                          imageUrl: profile.image!,
                          placeholderImage: Images.defalultArtistCover,
                        ),
                      ))),
                );
              } else {
                return InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => context.pushNamed(
                    loginName,
                    extra: {
                      'isLoggedIn': true,
                    },
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipOval(
                      child: Container(
                        width: 42,
                        height: 42,
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: Icon(
                          Icons.account_circle_outlined,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
