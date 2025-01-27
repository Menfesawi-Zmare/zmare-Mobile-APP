import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/profile_privacy.dart';
import 'package:go_router/go_router.dart';

class ProfilePrivacyModal extends StatelessWidget {
  const ProfilePrivacyModal(
      {super.key, required this.selectedIndex, required this.onCallBack});
  final int selectedIndex;
  final Function(ProfilePrivacy value) onCallBack;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          ListTile(
              contentPadding: const EdgeInsets.only(left: 20, right: 10),
              title: Text(context.loc.ttlProfile,
                  style: context.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: const Icon(Icons.close))),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(right: 10),
            itemCount: ProfilePrivacy.values.length,
            itemBuilder: (context, e) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 20, right: 10),
                title: Text(ProfilePrivacy.values[e].name(context),
                    style: context.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                trailing: selectedIndex == e
                    ? Icon(Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary)
                    : const SizedBox.shrink(),
                onTap: () {
                  onCallBack(ProfilePrivacy.values[e]);
                  GoRouter.of(context).pop();
                },
              );
            },
          )
        ],
      ),
    );
  }
}
