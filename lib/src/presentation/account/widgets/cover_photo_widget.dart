import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_image.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';

// ignore: must_be_immutable
class CoverPhoto extends StatelessWidget {
  CoverPhoto(
      {super.key,
      this.profile,
      required this.validator,
      required this.onChanged});
  final Profile? profile;
  final String? Function(File?) validator;
  final Function(File) onChanged;
  File? _pickedFile;
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    _cropImage(filePath) async {
      final croppedImage = (await ImageCropper.platform.cropImage(
          sourcePath: filePath,
          maxWidth: 2560,
          maxHeight: 1440,
          aspectRatio: const CropAspectRatio(ratioX: 16.0, ratioY: 9.0)));
      if (croppedImage != null) {
        onChanged.call(File(croppedImage.path));
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     KhmertracksText(
          //       text: context.loc.userDescCover,
          //       isBold: true,
          //     ),
          //     GestureDetector(
          //       onTap: () async {
          //         FilePickerResult? file = await FilePicker.platform
          //             .pickFiles(type: FileType.image, allowMultiple: false);
          //         if (file != null) {
          //           _pickedFile = File(file.files.first.path!);
          //           _cropImage(_pickedFile!.path);
          //         }
          //       },
          //       child: Text(
          //         profile!.cover != null ? context.loc.edit : context.loc.add,
          //         style: context.titleMedium?.copyWith(
          //           color: Colors.blue,
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                        width: double.infinity,
                        height: 140,
                        child: KhmertracksImage(
                          boxFit: BoxFit.fitWidth,
                          imageUrl: profile!.cover!,
                          placeholderImage: Images.defalultArtistCover,
                        )),
                  ),
                  Positioned(
                      top: 0,
                      right: 5,
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(177, 158, 158, 158),
                            shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () async {
                              FilePickerResult? file = await FilePicker.platform
                                  .pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false);
                              if (file != null) {
                                _pickedFile = File(file.files.first.path!);
                                _cropImage(_pickedFile!.path);
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black54,
                            )),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
