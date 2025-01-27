import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_pro/src/core/resources/resources.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/playlist_privacy_type.dart';
import 'package:flutter_music_pro/src/data/playlist/model/playlist_update_request_model.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/presentation/modal/modal_playlist_privacy.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_image.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text_field.dart';

import '../../data/playlist/model/playlist.dart';

class ModalUpdatePlaylist extends StatefulWidget {
  const ModalUpdatePlaylist(
      {super.key,
      required this.playlist,
      required this.bloc,
      required this.onCallBack});
  final Playlist playlist;
  final AuthBloc bloc;
  final Function(Playlist playlist) onCallBack;
  @override
  State<ModalUpdatePlaylist> createState() => _ModalUpdatePlaylistState();
}

class _ModalUpdatePlaylistState extends State<ModalUpdatePlaylist> {
  int privacyId = PlaylistPrivacyType.public.toIndex;
  final playlistNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final privacyController = TextEditingController();
  @override
  void initState() {
    privacyId = widget.playlist.public!;
    playlistNameController.text = widget.playlist.name!;
    descriptionController.text = widget.playlist.description!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    privacyController.text = PlaylistPrivacyType.values
        .firstWhere((element) => element.toIndex == privacyId)
        .name(context);
    return BlocProvider(
      create: (context) => widget.bloc,
      child: BlocListener(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is UpdatePlaylistState) {
            if (state.result == true) {
              widget.onCallBack(Playlist(
                  id: widget.playlist.id,
                  name: playlistNameController.text,
                  description: descriptionController.text,
                  trackTotal: widget.playlist.trackTotal,
                  time: widget.playlist.time,
                  ownerName: widget.playlist.ownerName,
                  ownerId: widget.playlist.ownerId,
                  image: widget.playlist.image,
                  public: privacyId));
              context.pop();
            }
          }
          if (state is Failure) {
            context.showMaterialSnackBar(state.message);
          }
        },
        child: Scaffold(
          appBar: context.materialYouAppBar(context.loc.edit,
              leadingWidget: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: const Size(70, 25),
                        backgroundColor:
                            Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      widget.bloc.add(UpdatePlaylistEvent(
                          PlaylistUpdateRequestModel(
                              name: playlistNameController.text,
                              description: descriptionController.text,
                              public: privacyId,
                              playlistId: widget.playlist.id!)));
                    },
                    child: Text(context.loc.save,
                        style: context.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.colorScheme.surface)),
                  ),
                )
              ]),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: KhmertracksImage(
                        imageUrl: widget.playlist.image!,
                        placeholderImage: Images.defalutSongCover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: KhmertracksTextField(
                      controller: playlistNameController,
                      labelText: context.loc.title,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              KhmertracksTextField(
                controller: descriptionController,
                labelText: context.loc.description,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(500),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              KhmertracksTextField(
                readOnly: true,
                controller: privacyController,
                labelText: context.loc.privacy,
                prefixIcon: privacyId == PlaylistPrivacyType.public.toIndex
                    ? const Icon(Icons.public)
                    : const Icon(Icons.lock),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    builder: (context) => ModalPlaylistPrivacy(
                      selectedIndex: privacyId,
                      onCallBack: (PlaylistPrivacyType value) {
                        setState(() {
                          privacyId = value.toIndex;
                          privacyController.text = value.name(context);
                        });
                      },
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
