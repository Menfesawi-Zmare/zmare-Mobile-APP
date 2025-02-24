import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:get_it/get_it.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/service_locator.dart';

void addToNowPlaying({
  required BuildContext context,
  required MediaItem mediaItem,
  bool showNotification = true,
}) {
  final AudioPlayerHandler audioHandler = GetIt.I<AudioPlayerHandler>();
  final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
  if (currentMediaItem != null &&
      currentMediaItem.extras!['url'].toString().startsWith('http')) {
    if (audioHandler.queue.value.contains(mediaItem) && showNotification) {
      context.showMaterialSnackBar(context.loc.alreadyInQueue);
    } else {
      audioHandler.addQueueItem(mediaItem);
      if (showNotification) {
        context.showMaterialSnackBar(context.loc.addedToQueue);
      }
    }
  } else {
    if (showNotification) {
      context.showMaterialSnackBar(currentMediaItem == null
          ? context.loc.nothingPlaying
          : context.loc.cantAddToQueue);
    }
  }
}

void playNext(
  MediaItem mediaItem,
  BuildContext context,
) {
  final AudioPlayerHandler audioHandler = locator<AudioPlayerHandler>();
  final MediaItem? currentMediaItem = audioHandler.mediaItem.value;
  if (currentMediaItem != null &&
      currentMediaItem.extras!['url'].toString().startsWith('http')) {
    final queue = audioHandler.queue.value;
    if (queue.contains(mediaItem)) {
      audioHandler.moveQueueItem(
        queue.indexOf(mediaItem),
        queue.indexOf(currentMediaItem) + 1,
      );
    } else {
      audioHandler.addQueueItem(mediaItem).then(
            (value) => audioHandler.moveQueueItem(
              queue.length,
              queue.indexOf(currentMediaItem) + 1,
            ),
          );
    }
    context.showMaterialSnackBar(
        '"${mediaItem.title}" ${context.loc.willPlayNext}');
  } else {
    context.showMaterialSnackBar(
      currentMediaItem == null
          ? context.loc.nothingPlaying
          : context.loc.cantAddToQueue,
    );
  }
}
