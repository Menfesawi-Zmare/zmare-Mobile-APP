import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zmare/src/app/routes.dart';
import 'package:zmare/src/core/resources/images.dart';
import 'package:zmare/src/presentation/widgets/texts/khmertracks_subtitle.dart';
import 'package:zmare/src/utils/ext/common.dart';
import 'package:zmare/src/utils/services/audio/download.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyAccount extends StatelessWidget {
  final String? email;
  const VerifyAccount({super.key, required this.email});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SizedBox(height: 125, child: SvgPicture.asset(Images.zmareIconWhite)),
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
                      text: email!,
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
              ))
        ],
      ),
    );
  }
}
