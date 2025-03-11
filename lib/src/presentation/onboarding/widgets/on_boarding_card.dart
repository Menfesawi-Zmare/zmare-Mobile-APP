import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
import 'package:zmare/src/utils/ext/color_extension.dart';

import '../../../core/resources/images.dart';

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard(
      {super.key, required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      padding: const EdgeInsets.all(20),
      // margin: const EdgeInsets.only(top: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(31, 31, 31, 1),
            Color.fromRGBO(10, 10, 10, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 270,
                child: Text(
                  maxLines: 2,
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    letterSpacing: -0.17,
                    color: Colors.white,
                  ),
                ),
              ),
              RiveAnimatedIcon(
                  riveIcon: RiveIcon.sound,
                  width: 30,
                  height: 30,
                  color: context.colorScheme.primary,
                  strokeWidth: 10,
                  loopAnimation: true,
                  onTap: () {},
                  onHover: (value) {}),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          ),
          if (MediaQuery.of(context).size.width >
              MediaQuery.of(context).size.height)
            const SizedBox()
          else
            const SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                Images.zmareIconWhite,
                color: context.primary,
                width: 60,
                height: 40,
              ),
              Text(
                "Zmare",
                style: GoogleFonts.jotiOne(
                  fontSize: 15,
                  color: context.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().moveY(begin: 50, duration: 1000.ms, curve: Curves.easeIn);
  }
}
