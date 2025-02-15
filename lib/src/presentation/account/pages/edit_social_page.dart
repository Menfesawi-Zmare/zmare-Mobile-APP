import 'package:flutter/material.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/data/account/model/account.dart';
import 'package:zmare/src/data/profile/model/profile.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text.dart';
import 'package:zmare/src/presentation/widgets/khmertracks_text_field.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditSocialPage extends StatefulWidget {
  const EditSocialPage({super.key, this.profile});
  final Profile? profile;

  @override
  State<EditSocialPage> createState() => _EditSocialPageState();
}

class _EditSocialPageState extends State<EditSocialPage> {
  final faceBookController = TextEditingController();
  final instagramController = TextEditingController();
  final twitterController = TextEditingController();
  final youTubeController = TextEditingController();
  final AuthBloc authBloc = locator.get<AuthBloc>();

  @override
  void initState() {
    faceBookController.text = widget.profile!.facebook ?? "";
    instagramController.text = widget.profile!.instagram ?? "";
    twitterController.text = widget.profile!.twitter ?? "";
    youTubeController.text = widget.profile!.youtube ?? "";
    super.initState();
  }

  @override
  void dispose() {
    faceBookController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    youTubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocConsumer(
        bloc: authBloc,
        listener: (context, state) {
          if (state is UpdateBioState) {
            if (state.updateAccountResponse.status == true) {
              GoRouter.of(context).pop();
              context.showMaterialSnackBar(context.loc.settingsSaved);
              authBloc.add(GetProfileEvent());
            }
          }
          if (state is Failure) {
            context.showMaterialSnackBar(state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            appBar: context.materialYouAppBar(
              context.loc.userTtlSocial,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KhmertracksTextField(
                      controller: faceBookController,
                      labelText: context.loc.ttlFacebook,
                      hintText: context.loc.subFacebook,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      controller: twitterController,
                      labelText: context.loc.ttlTwitter,
                      hintText: context.loc.subTwitter,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                      controller: instagramController,
                      labelText: context.loc.ttlInstagram,
                      hintText: context.loc.subInstagram,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    KhmertracksTextField(
                        controller: youTubeController,
                        labelText: context.loc.ttlYoutube,
                        hintText: context.loc.subYoutube),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    ProfileData profile = ProfileData(
                        facebook: faceBookController.text,
                        twitter: twitterController.text,
                        instagram: instagramController.text,
                        youtube: youTubeController.text);
                    authBloc.add(UpdateSocialEvent(profile));
                  },
                  child: KhmertracksText(
                    text: context.loc.saveChanges,
                    isBold: true,
                    isSmall: true,
                  )),
            ),
          );
        },
      ),
    );
  }
}
