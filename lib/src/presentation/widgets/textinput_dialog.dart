import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Add this package for SVG support
import 'package:zmare/src/core/resources/images.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/presentation/widgets/zmare_text_field.dart';

Future<void> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? initialText,
  required TextInputType keyboardType,
  required Function(String) onSubmitted,
  // Add this parameter for the SVG icon path
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctxt) {
      final controller = TextEditingController(text: initialText);
      return Dialog(
        backgroundColor: context.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        child: Container(
          height: 300, // Fixed height for the container
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG Icon at the top center
              SvgPicture.asset(
                Images.zmareIconWhite, // Use the provided SVG icon path
                width: 48,
                height: 48,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              // Title text
              Text(
                title,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              // Text input field
              Expanded(
                child: ZmareTextField(
                  textInputAction: TextInputAction.done,
                  maxLine: 5,
                  autofocus: true,
                  controller: controller,
                  labelText: title,
                  onFieldSubmitted: (value) {
                    onSubmitted(value);
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctxt);
                    },
                    child: Text(
                      context.loc.cancel,
                      style: TextStyle(
                        color: context.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctxt);
                      onSubmitted(controller.text.trim());
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      context.loc.ok,
                      style: TextStyle(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
