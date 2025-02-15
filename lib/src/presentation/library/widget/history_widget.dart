import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/helper/ad_helper.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key, required this.tracks});
  final List tracks;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 16.0, right: 0.0),
            horizontalTitleGap: 8.0,
            title: Text(context.loc.history,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            subtitle: tracks.isEmpty
                ? Text(context.loc.listNoTracks,
                    style: context.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w400))
                : null,
            leading: Icon(
              FluentIcons.history_48_regular,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            trailing: tracks.length > 1
                ? TextButton(
                    onPressed: () {
                      AdHelper.showInterstitialAd();
                      context.pushNamed(recentlyPath);
                    },
                    child: Text(context.loc.viewAll,
                        style: context.titleMedium?.copyWith(
                            fontWeight: FontWeight.w400, color: Colors.blue)))
                : TextButton(
                    onPressed: () => context.pushNamed(recentlyPath),
                    child: Text(context.loc.view,
                        style: context.titleSmall!.copyWith(
                            fontWeight: FontWeight.w400, color: Colors.blue))),
          ),
          if (tracks.isNotEmpty)
            SizedBox(
              height: 160,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tracks.length,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemExtent: 95,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          PlayerInvoke.init(
                            songsList: tracks,
                            index: index,
                            isOffline: false,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: tracks[index]['image']
                                          .toString()
                                          .startsWith('file:')
                                      ? Image(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                            File(
                                              Uri.parse(tracks[index]['image']
                                                      .toString())
                                                  .toFilePath(),
                                            ),
                                          ),
                                        )
                                      : KhmertracksImage(
                                          imageUrl: tracks[index]['image'],
                                          placeholderImage: Images.defalutCover,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: SizedBox(
                                  width: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                              text: '${tracks[index]["title"]}',
                                              style: context.bodyLarge
                                                  ?.copyWith(height: 1.2))),
                                      RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: '${tracks[index]["artist"]}',
                                            style: context.bodySmall),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            )
          else
            SizedBox.fromSize(),
          Divider(color: Colors.grey.withOpacity(0.2)),
        ]);
  }
}
