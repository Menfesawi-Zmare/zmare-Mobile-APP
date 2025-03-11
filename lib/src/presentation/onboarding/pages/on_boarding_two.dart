import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/resources/images.dart';
import '../widgets/custom_onboarding_container.dart';
import '../widgets/on_boarding_card.dart';

class OnBoardingTwo extends StatelessWidget {
  const OnBoardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          return landscapeLayout();
        } else {
          return portraitLayout();
        }
      },
    );
  }
}

Widget portraitLayout() {
  return SizedBox(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 25),
                    CustomOnboardingContainer(
                            height: 135.27,
                            width: 115.69,
                            bottomLeft: 65.66,
                            bottomRight: 7.82,
                            topLeft: 65.66,
                            topRight: 65.66,
                            imgUrl: Images.onBoardingImg8)
                        .animate()
                        .move(begin: Offset(-10, -10), duration: 1000.ms),
                    const SizedBox(width: 10), // Spacing between containers
                    CustomOnboardingContainer(
                            height: 172.75,
                            width: 143,
                            bottomLeft: 7.82,
                            bottomRight: 65.66,
                            topLeft: 65.66,
                            topRight: 65.66,
                            imgUrl: Images.onBoardingImg6)
                        .animate()
                        .move(begin: Offset(10, -10), duration: 1000.ms),
                  ],
                ),
                const SizedBox(height: 10), // Spacing between columns
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomOnboardingContainer(
                            height: 172.75,
                            width: 143,
                            bottomLeft: 65.66,
                            bottomRight: 65.66,
                            topLeft: 65.66,
                            topRight: 7.82,
                            imgUrl: Images.onBoardingImg7)
                        .animate()
                        .move(begin: Offset(-10, 10), duration: 1000.ms),
                    SizedBox(
                      width: 10,
                    ),
                    CustomOnboardingContainer(
                            height: 135.27,
                            width: 115.69,
                            bottomLeft: 65.66,
                            bottomRight: 65.66,
                            topLeft: 7.82,
                            topRight: 65.66,
                            imgUrl: Images.onBoardingImg5)
                        .animate()
                        .move(begin: Offset(10, 10), duration: 1000.ms),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 40,
        ),
        OnBoardingCard(
            title: "Let the Word of Christ Dwell in You Richly",
            description:
                "Deepen your faith with prayers, fasting reminders, and chants, and let Christ’s teachings guide your spiritual journey.")
      ],
    ),
  );
}

Widget landscapeLayout() {
  return SizedBox(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 25),
                    CustomOnboardingContainer(
                            height: 95.27,
                            width: 75.69,
                            bottomLeft: 65.66,
                            bottomRight: 7.82,
                            topLeft: 65.66,
                            topRight: 65.66,
                            imgUrl: Images.onBoardingImg8)
                        .animate()
                        .move(begin: Offset(-10, -10), duration: 1000.ms),
                    const SizedBox(width: 10), // Spacing between containers
                    CustomOnboardingContainer(
                            height: 122.75,
                            width: 103,
                            bottomLeft: 7.82,
                            bottomRight: 65.66,
                            topLeft: 65.66,
                            topRight: 65.66,
                            imgUrl: Images.onBoardingImg6)
                        .animate()
                        .move(begin: Offset(10, -10), duration: 1000.ms),
                  ],
                ),
                const SizedBox(height: 10), // Spacing between columns
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomOnboardingContainer(
                            height: 122.75,
                            width: 103,
                            bottomLeft: 65.66,
                            bottomRight: 65.66,
                            topLeft: 65.66,
                            topRight: 7.82,
                            imgUrl: Images.onBoardingImg7)
                        .animate()
                        .move(begin: Offset(-10, 10), duration: 1000.ms),
                    SizedBox(
                      width: 10,
                    ),
                    CustomOnboardingContainer(
                            height: 95.27,
                            width: 75.69,
                            bottomLeft: 65.66,
                            bottomRight: 65.66,
                            topLeft: 7.82,
                            topRight: 65.66,
                            imgUrl: Images.onBoardingImg5)
                        .animate()
                        .move(begin: Offset(10, 10), duration: 1000.ms),
                    const SizedBox(width: 25),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 80),
        SizedBox(
          width: 400,
          child: OnBoardingCard(
              title: "Let the Word of Christ Dwell in You Richly",
              description:
                  "Deepen your faith with prayers, fasting reminders, and chants, and let Christ’s teachings guide your spiritual journey."),
        )
      ],
    ),
  );
}
