import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/download_button.dart';
import 'package:zmare/src/presentation/widgets/song_list_tile.dart';
import 'package:zmare/src/presentation/player/pages/audioplayer.dart';
import 'package:zmare/src/utils/helper/mediaitem_converter.dart';

class NowPlayingStream extends StatelessWidget {
  final AudioPlayerHandler audioHandler;
  final ScrollController? scrollController;
  final bool head;
  final double headHeight;

  const NowPlayingStream({
    super.key,
    required this.audioHandler,
    this.scrollController,
    this.head = false,
    this.headHeight = 50,
  });

  void _updateScrollController(
    ScrollController? controller,
    int itemIndex,
    int queuePosition,
    int queueLength,
  ) {
    if (queuePosition > 3) {
      scrollController?.animateTo(
        itemIndex * 72,
        curve: Curves.linear,
        duration: const Duration(
          milliseconds: 350,
        ),
      );
    } else if (queuePosition < 10 && queueLength > 10) {
      scrollController?.animateTo(
        (queueLength - 10) * 72,
        curve: Curves.linear,
        duration: const Duration(
          milliseconds: 350,
        ),
      );
      return;
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QueueState>(
      stream: audioHandler.queueState,
      builder: (context, snapshot) {
        final queueState = snapshot.data ?? QueueState.empty;
        final queue = queueState.queue;
        final int queueStateIndex = queueState.queueIndex ?? 0;
        final num queuePosition = queue.length - queueStateIndex;
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _updateScrollController(
            scrollController,
            queueState.queueIndex ?? 0,
            queuePosition.toInt(),
            queue.length,
          ),
        );
        return ReorderableListView.builder(
          padding:
              const EdgeInsets.only(bottom: kBottomNavigationBarHeight + 60),
          header: SizedBox(
            height: head ? headHeight : 0,
          ),
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex--;
            }
            audioHandler.moveQueueItem(oldIndex, newIndex);
          },
          scrollController: scrollController,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: queue.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(queue[index].id),
              direction: index == queueState.queueIndex
                  ? DismissDirection.none
                  : DismissDirection.horizontal,
              background: Container(
                width: double.infinity,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.playlist_remove_rounded,
                        color: Colors.white,
                      ),
                      Icon(
                        Icons.playlist_remove_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              onDismissed: (dir) {
                audioHandler.removeQueueItemAt(index);
              },
              child: SongListTile(
                offline: queue[index].artUri.toString().startsWith('file')
                    ? true
                    : false,
                song: queue[index],
                highlight: index == queueState.queueIndex,
                onTap: () => audioHandler.skipToQueueItem(index),
                trailingWidget: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    if (queue[index]
                            .extras!['url']
                            .toString()
                            .startsWith('http') &&
                        queue[index].extras!['download'] == true)
                      DownloadButton(
                        size: 24.0,
                        data: MediaItemConverter.mediaItemToMap(
                          queue[index],
                        ),
                      ),
                    ReorderableDragStartListener(
                      key: Key(queue[index].id),
                      index: index,
                      enabled: index != queueState.queueIndex,
                      child: Icon(Icons.drag_handle_rounded,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
