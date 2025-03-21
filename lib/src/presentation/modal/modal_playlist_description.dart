import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/zmare_text.dart';

class ModalPlaylistDescrition extends StatelessWidget {
  const ModalPlaylistDescrition({super.key, required this.description});
  final String description;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ZmareText(
              text: description,
              isSmall: true,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.close),
            title: Text(context.loc.cancel,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            onTap: () => context.pop(),
          )
        ]));
  }
}
