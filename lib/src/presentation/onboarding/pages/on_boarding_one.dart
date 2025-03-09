import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zmare/src/presentation/onboarding/widgets/on_boarding_card.dart';

import '../../../core/resources/images.dart';
import '../widgets/custom_onboarding_container.dart';

class OnBoardingOne extends StatelessWidget {
  const OnBoardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomOnboardingContainer(
                          height: 93.88,
                          width: 71,
                          bottomLeft: 47.07,
                          bottomRight: 47.07,
                          topLeft: 47.07,
                          topRight: 47.07,
                          imgUrl: Images.onBoardingImg4)
                      .animate()
                      .move(begin: Offset(10, -10), duration: 1000.ms),
                  const SizedBox(height: 30), // Spacing between containers
                  CustomOnboardingContainer(
                          height: 200,
                          width: 138,
                          bottomLeft: 68.5,
                          bottomRight: 68.5,
                          topLeft: 68.5,
                          topRight: 68.5,
                          imgUrl: Images.onBoardingImg3)
                      .animate()
                      .move(begin: Offset(-10, 10), duration: 1000.ms),
                ],
              ),
              const SizedBox(width: 20), // Spacing between columns
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomOnboardingContainer(
                          height: 200,
                          width: 138,
                          bottomLeft: 68.5,
                          bottomRight: 68.5,
                          topLeft: 68.5,
                          topRight: 68.5,
                          imgUrl: Images.onBoardingImg2)
                      .animate()
                      .move(begin: Offset(10, -10), duration: 1000.ms),
                  const SizedBox(height: 30),
                  CustomOnboardingContainer(
                          height: 93.88,
                          width: 71,
                          bottomLeft: 47.07,
                          bottomRight: 47.07,
                          topLeft: 47.07,
                          topRight: 47.07,
                          imgUrl: Images.onBoardingImg1)
                      .animate()
                      .move(begin: Offset(-10, -10), duration: 1000.ms),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          OnBoardingCard(
              title: "Sing to the Lord a New Song.",
              description:
                  "Rejoice in sacred Ethiopian Orthodox hymns and prayers, uplifting your soul with melodies that glorify God.")
        ],
      ),
    );
  }
}
