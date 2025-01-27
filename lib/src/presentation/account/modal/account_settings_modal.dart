import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';

class AccountSettingsModal extends StatelessWidget {
  const AccountSettingsModal({super.key});
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
              title: Text(context.loc.settingsLabel,
                  style: context.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: const Icon(Icons.close))),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 10),
            title: Text(context.loc.password,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            leading: const Icon(FluentIcons.password_24_regular),
            onTap: () {
              context.pop();
              context.pushNamed(changePasswordPath);
            },
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20, right: 10),
            title: Text(context.loc.user_menu_delete,
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            leading: const Icon(FluentIcons.delete_24_regular),
            onTap: () {
              context.pop();
              context.pushNamed(deleteAccountPath);
            },
          ),
        ],
      ),
    );
  }
}
