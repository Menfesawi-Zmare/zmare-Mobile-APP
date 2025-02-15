import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialsWidget extends StatelessWidget {
  const SocialsWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    late final account = locator
        .get<Box<dynamic>>(instanceName: BoxType.account.name)
        .listenable(
      keys: [accountDetail],
    );
    return ValueListenableBuilder(
        valueListenable: account,
        builder: (BuildContext context, value, Widget? child) {
          final accountJson = value.get(accountDetail);
          Profile profile =
              Profile?.fromJson(jsonDecode(jsonEncode(accountJson)));
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KhmertracksText(
                      text: context.loc.userTtlSocial,
                      isBold: true,
                    ),
                    InkWell(
                      onTap: () =>
                          context.pushNamed(editSocialPath, extra: profile),
                      child: Text(
                        profile.facebook != null ||
                                profile.twitter != null ||
                                profile.instagram != null ||
                                profile.youtube != null
                            ? context.loc.edit
                            : context.loc.add,
                        style: context.titleMedium?.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Visibility(
                    visible: profile.facebook != null ? true : false,
                    child: SocialItem(
                        iconName: Images.facebookIcon,
                        name: context.loc.ttlFacebook,
                        url: 'https://facebook.com/${profile.facebook ?? ""}')),
                Visibility(
                    visible: profile.twitter != null ? true : false,
                    child: SocialItem(
                        iconName: Images.twitterIcon,
                        name: context.loc.ttlTwitter,
                        url:
                            'https://www.twitter.com/${profile.twitter ?? ""}')),
                Visibility(
                    visible: profile.instagram != null ? true : false,
                    child: SocialItem(
                        iconName: Images.instagramIcon,
                        name: context.loc.ttlInstagram,
                        url:
                            'https://www.instagram.com/${profile.instagram ?? ""}')),
                Visibility(
                    visible: profile.youtube != null ? true : false,
                    child: SocialItem(
                        iconName: Images.youtubeIcon,
                        name: context.loc.ttlYoutube,
                        url:
                            'https://www.youtube.com/${profile.youtube ?? ""}')),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          );
        });
  }
}

class SocialItem extends StatelessWidget {
  const SocialItem(
      {super.key,
      required this.iconName,
      required this.url,
      required this.name});
  final String iconName;
  final String name;
  final String url;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        iconName,
        fit: BoxFit.cover,
        height: 24,
        width: 24,
      ),
      title: Text(
        name,
        style: TextStyle(color: context.colorScheme.primary),
      ),
      onTap: () => launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      ),
    );
  }
}
