import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/core/resources/images.dart';
import 'package:zmare/src/presentation/login/bloc/auth_bloc.dart';
import 'package:zmare/src/presentation/widgets/texts/zmare_subtitle.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/services/audio/download.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyAccount extends StatefulWidget {
  final String? email;
  const VerifyAccount({super.key, required this.email});

  @override
  State<VerifyAccount> createState() => _VerifyAccountState();
}

class _VerifyAccountState extends State<VerifyAccount> {
  void _launchEmailApp() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      //to: 'example@example.com', // Optional: pre-fill the "To" field
      //subject: 'Subject', // Optional: pre-fill the subject
      //body: 'Body', // Optional: pre-fill the body
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email app';
    }
  }

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
          if (state is EmailResentSucces) {
            context.dismiss();
            context.showMaterialSnackBar(state.resentModel.message!);
          }
          if (state is Failure) {
            context.dismiss();
            context.showMaterialSnackBar(state.message);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                context.go(homePagePath);
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              SizedBox(
                  height: 125, child: SvgPicture.asset(Images.zmareIconWhite)),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                child: Text(
                  "We have sent you an email",
                  style: context.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: RichText(
                    // Use RichText for styled text
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: context.bodyMedium?.copyWith(
                        // Apply your base text style
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                "Click on the email verification link sent to you on ",
                            style: TextStyle(fontSize: 14)),
                        TextSpan(
                          text: widget.email!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: context
                                .colorScheme.primary, // Use your primary color
                          ),
                        ),
                        TextSpan(
                          text: ". \n Then click next.",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              OutlinedButton(
                  style: ButtonStyle(),
                  onPressed: _launchEmailApp,
                  child: Text(
                    "Open Email App",
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    context.pushNamed(signInName);
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      // style: DefaultTextStyle.of(context).style.copyWith(
                      //       fontSize: 16,
                      //       color: Colors.grey[800],
                      //     ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: "Didn't receive an email? ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "Check your ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "spam",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                        TextSpan(
                          text: " or ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "junk",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.primary,
                          ),
                        ),
                        TextSpan(
                          text: " folder. If it's not there, you can ",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: "Resend",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: context
                                .primary, // Highlight the "resend" action
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              authBloc.add(ResendEmailEvent(widget.email!));
                            },
                        ),
                        const TextSpan(
                          text: ".",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
