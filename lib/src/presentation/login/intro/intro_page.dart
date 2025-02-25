// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zmare/src/core/resources/resources.dart';
import 'package:zmare/src/utils/services/firebase/authenticate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/core/enum/login_type.dart';
import 'package:zmare/src/data/register/model/register_social_request.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:video_player/video_player.dart';

class IntroPage extends StatefulWidget {
  const IntroPage(
      {super.key, this.showBackButton = false, required this.controller});
  final bool showBackButton;
  final VideoPlayerController controller;
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool isLoading = false;

  late AuthBloc authBloc = locator.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authBloc,
      child: BlocListener(
        bloc: authBloc,
        listener: (context, state) {
          if (state is Loading) {
            context.show();
          }
          if (state is LoginWithGmail) {
            if (state.registerResponse.status == true) {
              context.dismiss();
              context.go(homePagePath);
              authBloc.add(GetProfileEvent());
            }
          }
          if (state is Failure) {
            context.dismiss();
            context.showMaterialSnackBar(state.message);
          }
        },
        child: Scaffold(
          // extendBody: true,
          // extendBodyBehindAppBar: widget.showBackButton ? true : false,
          // appBar: AppBar(
          //     backgroundColor: Colors.transparent,
          //     toolbarHeight: widget.showBackButton ? null : 0,
          //     leading: widget.showBackButton
          // ? IconButton(
          //     color: Theme.of(context).colorScheme.primary,
          //     onPressed: () {
          //       context.pop();
          //     },
          //     icon: Icon(Platform.isIOS
          //         ? Icons.arrow_back_ios
          //         : Icons.arrow_back))
          // : null),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: double.maxFinite,
                    width: double.infinity,
                    child: widget.controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: widget.controller.value.aspectRatio,
                            child: VideoPlayer(widget.controller),
                          )
                        : Container(color: Palette.black15),
                  ),
                ),
                Container(
                  color: context.colorScheme.onPrimary.withOpacity(0.8),
                ),
                Positioned(
                    top: 20,
                    child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Platform.isIOS
                            ? Icons.arrow_back_ios
                            : Icons.arrow_back))),
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                          child: SvgPicture.asset(
                        Images.zmareIconWhite,
                        width: 150.0,
                        height: 140.0,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 20, right: 16, bottom: 8),
                        child: Text(
                          context.loc.appTitle,
                          textAlign: TextAlign.center,
                          style: context.headlineMedium?.copyWith(
                              color: Palette.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                        ),
                        child: Text(context.loc.appDescription,
                            style: context.titleMedium
                                ?.copyWith(color: Palette.white),
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, top: 40, bottom: 10),
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(signUpName);
                          },
                          style: ButtonStyle(
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.only(top: 12, bottom: 12),
                            ),
                            shape: WidgetStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                side: BorderSide(
                                  color: Palette.white,
                                ),
                              ),
                            ),
                          ),
                          child: Text(context.loc.signUp,
                              style: context.titleMedium?.copyWith(
                                  color: Palette.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor:
                                const Color.fromARGB(255, 158, 8, 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: const BorderSide(
                                color: Color(gmailColor),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            FirebaseService service = FirebaseService();
                            try {
                              UserCredential? userCredential =
                                  await service.signInwithGoogle();

                              if (userCredential != null) {
                                authBloc.add(LoginWithSocial(
                                    RegisterSocialRequest(
                                        firstName:
                                            userCredential.user!.displayName,
                                        lastName: '',
                                        username: '',
                                        email: userCredential.user!.email!,
                                        image: userCredential.user!.photoURL!
                                            .replaceAll('s96-c', 's1024-c'),
                                        type: LoginType.google.name)));
                              }
                            } catch (e) {
                              if (e is FirebaseAuthException) {
                                context.showMaterialSnackBar(e.message!);
                              }
                              GoogleSignIn().signOut();
                              context.showMaterialSnackBar(
                                  "Try again later please!");
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Image.asset(
                                      Images.gmailIcon,
                                      height: 24,
                                      width: 24,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.loc.continueWithGmail,
                                    textAlign: TextAlign.center,
                                    style: context.titleMedium?.copyWith(
                                        color: context.onSurface,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      if (Platform.isIOS)
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, bottom: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onSurface),
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              FirebaseService service = FirebaseService();
                              try {
                                UserCredential? userCredential =
                                    await service.signInWithApple();
                                if (userCredential != null) {
                                  authBloc.add(LoginWithSocial(
                                      RegisterSocialRequest(
                                          firstName:
                                              userCredential.user!.displayName,
                                          lastName: '',
                                          username: '',
                                          email: userCredential.user!.email!,
                                          image: '',
                                          type: LoginType.apple.name)));
                                }
                              } catch (e) {
                                if (e is FirebaseAuthException) {
                                  context.showMaterialSnackBar(e.message!);
                                }
                                GoogleSignIn().signOut();
                                context.showMaterialSnackBar(
                                    context.loc.pleaseTryAgain);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            },
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Image.asset(
                                    Images.appleIcon,
                                    height: 24,
                                    width: 24,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  context.loc.continueWithApple,
                                  textAlign: TextAlign.center,
                                  style: context.titleMedium?.copyWith(
                                      color: context.colorScheme.surface,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, bottom: 10),
                        child: TextButton(
                            onPressed: () => context.pushNamed(signInName),
                            child: Text(context.loc.login,
                                style: context.titleMedium?.copyWith(
                                    color: context.onSurface,
                                    fontWeight: FontWeight.bold))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
