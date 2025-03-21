import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/services/audio/player_service.dart';
import 'package:zmare/src/presentation/widgets/download_button.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_title.dart';

class DownloadsSearch extends SearchDelegate {
  final bool isDowns;
  final List data;

  DownloadsSearch({required this.data, this.isDowns = false});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isEmpty)
        IconButton(
          icon: const Icon(FluentIcons.search_48_regular),
          tooltip: context.loc.search,
          onPressed: () {},
        )
      else
        IconButton(
          onPressed: () {
            query = '';
          },
          tooltip: context.loc.clear,
          icon: const Icon(
            Icons.clear_rounded,
          ),
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(FluentIcons.arrow_left_48_regular),
      tooltip: context.loc.back,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data
        : [
            ...{
              ...data.where(
                (element) => element['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              ),
              ...data.where(
                (element) => element['artist']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              ),
            }
          ];
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        minVerticalPadding: 8.0,
        contentPadding: const EdgeInsets.only(left: 16),
        leading: SizedBox.square(
          dimension: 56,
          child: isDowns
              ? Image(
                  fit: BoxFit.cover,
                  image: FileImage(
                    File(suggestionList[index]['image'].toString()),
                  ),
                  errorBuilder: (_, __, ___) =>
                      Image.asset(Images.defalutCover),
                )
              : ZmareImage(
                  placeholderImage: Images.defalutCover,
                  imageUrl: suggestionList[index]['image']
                      .toString()
                      .replaceAll('http:', 'https:')),
        ),
        title: ZmareTitle(
          suggestionList[index]['title'].toString(),
        ),
        subtitle: ZmareSubTitle(
          suggestionList[index]['artist'].toString(),
        ),
        trailing: isDowns
            ? null
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DownloadButton(
                    data: suggestionList[index] as Map,
                    icon: 'download',
                  ),
                ],
              ),
        onTap: () {
          PlayerInvoke.init(
            songsList: suggestionList,
            index: index,
            isOffline: isDowns,
            fromDownloads: isDowns,
            recommend: false,
          );
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data
        : [
            ...{
              ...data.where(
                (element) => element['title']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              ),
              ...data.where(
                (element) => element['artist']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              ),
            }
          ];
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (context, index) => ListTile(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0))),
        minVerticalPadding: 8.0,
        contentPadding: const EdgeInsets.only(left: 16),
        leading: SizedBox.square(
            dimension: 56,
            child: isDowns
                ? Image(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(suggestionList[index]['image'].toString()),
                    ),
                    errorBuilder: (_, __, ___) =>
                        Image.asset(Images.defalutCover),
                  )
                : ZmareImage(
                    placeholderImage: Images.defalutCover,
                    imageUrl: suggestionList[index]['image']
                        .toString()
                        .replaceAll('http:', 'https:'))),
        title: Text(
          suggestionList[index]['title'].toString(),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          suggestionList[index]['artist'].toString(),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          PlayerInvoke.init(
            songsList: suggestionList,
            index: index,
            isOffline: isDowns,
            fromDownloads: isDowns,
            recommend: false,
          );
        },
      ),
    );
  }
}
