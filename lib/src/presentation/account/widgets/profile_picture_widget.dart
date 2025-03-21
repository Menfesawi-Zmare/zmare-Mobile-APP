import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:zmare/src/core/resources/resources.dart';

import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/widgets/zmare_image.dart';

// ignore: must_be_immutable
class ProfilePictureWidget extends StatefulWidget {
  const ProfilePictureWidget({
    super.key,
    this.profile,
    required this.validator,
    required this.onChanged,
  });

  final Profile? profile;
  final String? Function(File?) validator;
  final Function(File) onChanged;

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  File? _pickedFile;

  Future<void> _cropImage(String filePath) async {
    final croppedImage = await ImageCropper.platform.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    if (croppedImage != null) {
      widget.onChanged.call(File(croppedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormField<File>(
        validator: widget.validator,
        builder: (formFieldState) {
          return Column(
            children: [
              // Title and Edit/Add Button
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     ZmareText(
              //       text: context.loc.userDescAvatar,
              //     ),
              //     TextButton(
              //       onPressed: () async {
              //         FilePickerResult? file =
              //             await FilePicker.platform.pickFiles(
              //           type: FileType.image,
              //           allowMultiple: false,
              //         );
              //         if (file != null) {
              //           _pickedFile = File(file.files.first.path!);
              //           _cropImage(_pickedFile!.path);
              //         }
              //       },
              //       child: Text(
              //         widget.profile!.image != null
              //             ? context.loc.edit
              //             : context.loc.add,
              //         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              //               color: Theme.of(context).colorScheme.primary,
              //               fontWeight: FontWeight.bold,
              //             ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 16),

              // Profile Picture
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Profile Picture Container
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ZmareImage(
                          imageUrl: widget.profile!.image!,
                          placeholderImage: Images.defalultArtistCover,
                        ),
                      ),
                    ),

                    // Edit Icon (Floating Action Button)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () async {
                          FilePickerResult? file =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            allowMultiple: false,
                          );
                          if (file != null) {
                            _pickedFile = File(file.files.first.path!);
                            _cropImage(_pickedFile!.path);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 15,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Error Message
              if (formFieldState.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    formFieldState.errorText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
