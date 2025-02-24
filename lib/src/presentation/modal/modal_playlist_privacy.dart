import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/playlist_privacy_type.dart';

class ModalPlaylistPrivacy extends StatelessWidget {
  const ModalPlaylistPrivacy(
      {super.key, required this.selectedIndex, required this.onCallBack});
  final int selectedIndex;
  final Function(PlaylistPrivacyType value) onCallBack;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(Icons.lock),
            title: Text(PlaylistPrivacyType.private.name(context),
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            trailing: selectedIndex == PlaylistPrivacyType.private.toIndex
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              onCallBack(PlaylistPrivacyType.private);
              GoRouter.of(context).pop();
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            leading: const Icon(Icons.public),
            title: Text(PlaylistPrivacyType.public.name(context),
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            trailing: selectedIndex == PlaylistPrivacyType.public.toIndex
                ? const Icon(Icons.check_circle)
                : const SizedBox.shrink(),
            onTap: () {
              onCallBack(PlaylistPrivacyType.public);
              GoRouter.of(context).pop();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.close),
            title: Text(context.loc.cancel,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            onTap: () => context.pop(),
          )
        ],
      ),
    );
  }
}
