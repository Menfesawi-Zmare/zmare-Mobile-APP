import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:go_router/go_router.dart';

class DownloadFilter extends StatefulWidget {
  const DownloadFilter(
      {super.key,
      required this.onCallBack,
      required this.sortValue,
      required this.orderValue});
  final int orderValue;
  final int sortValue;
  final Function(int value) onCallBack;
  @override
  State<DownloadFilter> createState() => _DownloadFilterState();
}

class _DownloadFilterState extends State<DownloadFilter> {
  @override
  Widget build(BuildContext context) {
    final List<String> sortTypes = [
      context.loc.displayName,
      context.loc.dateAdded,
      context.loc.album,
      context.loc.artist,
      context.loc.duration,
      context.loc.size
    ];
    final List<String> orderTypes = [
      context.loc.inc,
      context.loc.dec,
    ];
    return SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: sortTypes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -2),
                    title: Text(sortTypes[index],
                        style: context.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: widget.sortValue == index
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      widget.onCallBack(index);
                      GoRouter.of(context).pop();
                    },
                  );
                }),
            const Divider(),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: orderTypes.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: Text(orderTypes[index],
                        style: context.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: widget.orderValue == index
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      widget.onCallBack(sortTypes.length + index);
                      GoRouter.of(context).pop();
                    },
                  );
                }),
          ],
        ));
  }
}
