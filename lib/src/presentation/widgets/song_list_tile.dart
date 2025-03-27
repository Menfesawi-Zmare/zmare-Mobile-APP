import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_subtitle.dart';

import 'package:zmare/src/utils/ext/color_extension.dart';

import 'texts/zmare_title.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.song,
    required this.onTap,
    this.highlight = false,
    this.offline = false,
    this.trailingWidget,
  });

  final MediaItem song;
  final Function onTap;
  final bool highlight;
  final bool offline;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16),
      minVerticalPadding: 8.0,
      leading: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
          ),
          child: offline
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Image(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(
                        song.artUri!.toFilePath(),
                      ),
                    ),
                    errorBuilder: (context, exception, stackTrace) {
                      return const Image(
                        fit: BoxFit.cover,
                        image: AssetImage(Images.defalutCover),
                      );
                    },
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: ZmareImage(
                    imageUrl: song.artUri.toString(),
                    placeholderImage: Images.defalutSongCover,
                  ),
                )),
      title: ZmareTitle(song.title),
      subtitle: ZmareSubTitle('${song.artist} • ${song.album}'),
      onTap: () => onTap(),
      // tileColor:
      //     highlight ? context.colorScheme.surfaceVariant : Colors.transparent,
      trailing: trailingWidget,
    );
  }
}
