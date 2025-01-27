import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({super.key, required this.profile, this.isPinned = false});
  final Profile profile;
  final bool isPinned;
  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: widget.profile.description != null ? true : false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.loc.description,
                        style: context.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(widget.profile.description ?? ''),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Visibility(
                visible: widget.profile.instagram != null ||
                        widget.profile.twitter != null ||
                        widget.profile.facebook != null ||
                        widget.profile.youtube != null
                    ? true
                    : false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(context.loc.links,
                        style: context.titleLarge!
                            .copyWith(fontWeight: FontWeight.bold)),
                    Visibility(
                      visible: widget.profile.instagram != null ? true : false,
                      child: ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(
                          Images.instagramIcon,
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(
                          context.loc.instagram,
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        onTap: () => launchUrl(
                          Uri.parse(
                              'https://www.instagram.com/${widget.profile.instagram ?? ""}'),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.profile.facebook != null ? true : false,
                      child: ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(
                          Images.facebookIcon,
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(
                          context.loc.facebook,
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        onTap: () => launchUrl(
                          Uri.parse(
                              'https://facebook.com/${widget.profile.facebook ?? ""}'),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.profile.twitter != null ? true : false,
                      child: ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(
                          Images.twitterIcon,
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(
                          context.loc.twitter,
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        onTap: () => launchUrl(
                          Uri.parse(
                              'https://www.twitter.com/${widget.profile.twitter ?? ""}'),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.profile.youtube != null ? true : false,
                      child: ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(
                          Images.youtubeIcon,
                          fit: BoxFit.cover,
                          height: 24,
                          width: 24,
                        ),
                        title: Text(
                          context.loc.youTube,
                          style: TextStyle(color: context.colorScheme.primary),
                        ),
                        onTap: () => launchUrl(
                          Uri.parse(
                              'https://www.youtube.com/${widget.profile.youtube ?? ""}'),
                          mode: LaunchMode.externalApplication,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Text(context.loc.moreInfo,
                  style: context.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold)),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding: EdgeInsets.zero,
                leading: const Icon(FluentIcons.globe_24_regular),
                title: Text(
                  widget.profile.url!,
                  style: TextStyle(color: context.colorScheme.primary),
                ),
                onTap: () => launchUrl(
                  Uri.parse(widget.profile.url!),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              Visibility(
                visible: widget.profile.country != null ? true : false,
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(FluentIcons.location_24_regular),
                  title: Text(location(
                      widget.profile.country ?? '', widget.profile.city ?? '')),
                ),
              ),
              ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                contentPadding: EdgeInsets.zero,
                leading: const Icon(FluentIcons.info_24_regular),
                title: Text('${context.loc.join} ${widget.profile.date}'),
              ),
            ],
          ),
        ]);
  }
}
