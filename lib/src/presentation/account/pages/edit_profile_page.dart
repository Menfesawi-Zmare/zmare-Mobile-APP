import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/core/enum/box_types.dart';
import 'package:flutter_music_pro/src/core/enum/profile_image_type.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/account/widgets/bio_widget.dart';
import 'package:flutter_music_pro/src/presentation/account/widgets/cover_photo_widget.dart';
import 'package:flutter_music_pro/src/presentation/account/widgets/profile_picture_widget.dart';
import 'package:flutter_music_pro/src/presentation/account/widgets/socials_widget.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/service_locator.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, this.profile});
  final Profile? profile;
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final account =
      locator.get<Box<dynamic>>(instanceName: BoxType.account.name).listenable(
    keys: [accountDetail],
  );
  final AuthBloc authBloc = locator.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: account,
        builder: (BuildContext context, value, Widget? child) {
          final accountJson = value.get(accountDetail);
          Profile profile = Profile.fromJson(accountJson);
          return BlocProvider(
            create: (context) => authBloc,
            child: BlocConsumer(
              bloc: authBloc,
              listener: (context, state) {
                if (state is UpdateImageState) {
                  if (state.updateAccountResponse.status == true) {
                    context.showMaterialSnackBar(context.loc.imageSaved);
                    authBloc.add(GetProfileEvent());
                  }
                }
                if (state is Failure){
                  context.showMaterialSnackBar(state.message);
                }
              },
              builder: (context, state) {
                return Scaffold(
                  appBar: context.materialYouAppBar(
                    context.loc.editProfile,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Divider(),
                        ProfilePictureWidget(
                          profile: profile,
                          validator: (val) {
                            if (val == null) return 'Pick a picture';
                            return null;
                          },
                          onChanged: (avatar) {
                            authBloc.add(UpdateImageEvent(
                                avatar, ProfileImageType.avatar.name));
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Divider(),
                        ),
                        CoverPhoto(
                          profile: profile,
                          validator: (val) {
                            if (val == null) return 'Pick a picture';
                            return null;
                          },
                          onChanged: (cover) {
                            authBloc.add(UpdateImageEvent(
                                cover, ProfileImageType.cover.name));
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Divider(),
                        ),
                        const BioWidget(),
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Divider(),
                        ),
                        const SocialsWidget()
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}
