import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';

// ignore: must_be_immutable
class ProfilePictureWidget extends StatefulWidget {
  const ProfilePictureWidget(
      {super.key,
      this.profile,
      required this.validator,
      required this.onChanged});
  final Profile? profile;
  final String? Function(File?) validator;
  final Function(File) onChanged;

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  File? _pickedFile;
  _cropImage(filePath) async {
    final croppedImage = (await ImageCropper.platform.cropImage(
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0)));
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KhmertracksText(
                      text: context.loc.userDescAvatar,
                      isBold: true,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? file = await FilePicker.platform
                            .pickFiles(
                                type: FileType.image, allowMultiple: false);
                        if (file != null) {
                          _pickedFile = File(file.files.first.path!);
                          _cropImage(_pickedFile!.path);
                        }
                      },
                      child: Text(
                        widget.profile!.image != null
                            ? context.loc.edit
                            : context.loc.add,
                        style: context.titleMedium?.copyWith(
                          color: Colors.blue,
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            width: 150,
                            height: 150,
                            child: KhmertracksImage(
                              imageUrl: widget.profile!.image!,
                              placeholderImage: Images.defalultArtistCover,
                            )),
                      ),
                    ),
                    if (formFieldState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 10),
                        child: Text(
                          formFieldState.errorText!,
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                              color: Colors.red[700],
                              height: 0.5),
                        ),
                      )
                  ],
                ),
              ],
            );
          }),
    );
  }
}
