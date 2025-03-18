import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text_field.dart';

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
        backgroundColor: context.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        title: Row(
          children: [
            Icon(
              Icons.edit,
              size: 15,
              color: context.onSurface,
            ),
            SizedBox(
              width: 5,
            ),
            Text(title,
                style:
                    context.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            KhmertracksTextField(
              textInputAction: TextInputAction.none,
              maxLine: 10,
              autofocus: true,
              controller: controller,
              labelText: 'Comment',
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
            onPressed: () {
              Navigator.pop(ctxt);
              onSubmitted(controller.text.trim());
            },
            child: Text(context.loc.ok,
                style: TextStyle(
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
