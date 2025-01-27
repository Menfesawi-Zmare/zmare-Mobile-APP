import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';
import 'package:flutter_music_pro/src/utils/ext/string_extensions.dart';
import 'package:flutter_music_pro/src/core/enum/profile_privacy.dart';
import 'package:flutter_music_pro/src/data/account/model/account.dart';
import 'package:flutter_music_pro/src/data/profile/model/profile.dart';
import 'package:flutter_music_pro/src/presentation/account/modal/profile_privacy_modal.dart';
import 'package:flutter_music_pro/src/presentation/login/bloc/auth_bloc.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text.dart';
import 'package:flutter_music_pro/src/presentation/widgets/khmertracks_text_field.dart';
import 'package:flutter_music_pro/src/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditBioPage extends StatefulWidget {
  const EditBioPage({super.key, this.profile});
  final Profile? profile;

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  final _formKey = GlobalKey<FormState>();
  int privacyId = ProfilePrivacy.private.toIndex;
  final AuthBloc authBloc = locator.get<AuthBloc>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final websiteController = TextEditingController();
  final privateController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    privacyId = widget.profile!.private!;
    firstNameController.text = widget.profile!.firstName!;
    lastNameController.text = widget.profile!.lastName!;
    emailController.text = widget.profile!.email!;
    countryController.text = widget.profile!.country ?? '';
    cityController.text = widget.profile!.city ?? '';
    websiteController.text = widget.profile!.website ?? '';
    descriptionController.text = widget.profile!.description ?? '';
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    countryController.dispose();
    cityController.dispose();
    websiteController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    privateController.text = ProfilePrivacy.values
        .where((element) => element.toIndex == privacyId)
        .first
        .name(context);
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
              context.loc.userTtlGeneral,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KhmertracksTextField(
                        controller: firstNameController,
                        labelText: context.loc.ttlFirstName,
                        hintText: context.loc.subFirstName,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                        controller: lastNameController,
                        labelText: context.loc.ttlLastName,
                        hintText: context.loc.subFirstName,
                        validator: (val) {
                          if (!val!.isNotEmpty) {
                            return 'Enter valid last name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                        controller: emailController,
                        labelText: context.loc.ttlEmail,
                        hintText: context.loc.subEmail,
                        validator: (val) {
                          if (!val!.isValidEmail) {
                            return context.loc.enterValidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                          controller: countryController,
                          labelText: context.loc.ttlCountry,
                          hintText: context.loc.subCountry),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                          controller: cityController,
                          labelText: context.loc.ttlCity,
                          hintText: context.loc.subCity),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                        controller: websiteController,
                        labelText: context.loc.ttlWebsite,
                        hintText: context.loc.subWebsite,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                        readOnly: true,
                        controller: privateController,
                        labelText: context.loc.ttlProfile,
                        hintText: context.loc.subProfile,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            builder: (context) => ProfilePrivacyModal(
                              selectedIndex: privacyId,
                              onCallBack: (ProfilePrivacy value) {
                                // setState(() {
                                privacyId = value.toIndex;
                                privateController.text = value.name(context);
                                // });
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      KhmertracksTextField(
                          labelText: context.loc.subDescription,
                          hintText: context.loc.ttlDescription,
                          minLine: 6,
                          maxLine: 12,
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ProfileData profile = ProfileData(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          country: countryController.text,
                          city: cityController.text,
                          website: websiteController.text,
                          private: privacyId.toString(),
                          description: descriptionController.text);
                      authBloc.add(UpdateBioEvent(profile));
                    }
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
