import 'package:flutter/material.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_subtitle.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_title.dart';
import 'package:zmare/src/utils/ext/color_extension.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceVariant, // Custom background color
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: icon == null
            ? null
            : Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
        title: ZmareTitle(title),
        subtitle: subtitle != null
            ? ZmareSubTitle(
                subtitle,
                maxLines: 2,
              )
            : null,
        onTap: onTap,
        trailing: trailing,
      ),
    );
  }
}
