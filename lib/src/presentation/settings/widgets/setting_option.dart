import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_title.dart';

class SettingsOption extends StatelessWidget {
  const SettingsOption({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon == null
          ? null
          : Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface,
            ),
      title: KhmertracksTitle(title),
      subtitle: subtitle != null
          ? KhmertracksSubTitle(
              subtitle,
              maxLines: 2,
            )
          : null,
      onTap: onTap,
      trailing: trailing,
    );
  }
}
