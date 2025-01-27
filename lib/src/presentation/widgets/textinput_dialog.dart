import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text_field.dart';

Future<void> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? initialText,
  required TextInputType keyboardType,
  required Function(String) onSubmitted,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctxt) {
      final controller = TextEditingController(text: initialText);
      return AlertDialog(
        title: Text(title,
            style: context.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KhmertracksTextField(
              autofocus: true,
              controller: controller,
              labelText: context.loc.title,
              onFieldSubmitted: (value) {
                onSubmitted(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctxt);
            },
            child: Text(context.loc.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(ctxt);
              onSubmitted(controller.text.trim());
            },
            child: Text(context.loc.ok,
                style: TextStyle(color: context.colorScheme.onPrimary)),
          ),
        ],
      );
    },
  );
}
