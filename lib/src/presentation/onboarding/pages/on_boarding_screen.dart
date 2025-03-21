import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zmare/src/core/enum/box_types.dart';
import 'package:zmare/src/presentation/onboarding/pages/on_boarding_one.dart';
import 'package:zmare/src/presentation/onboarding/pages/on_boarding_two.dart';
import 'package:zmare/src/service_locator.dart';
import 'package:zmare/src/utils/ext/color_extension.dart';
import 'package:zmare/src/utils/helper/constants.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, viewportFraction: 2);
    super.initState();
  }

  final int _pageCount = 2;
  int _currentPage = 0;
  final onBoarding = locator.get<Box<dynamic>>(
    instanceName: BoxType.onboarding.name,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentPage != 0)
                SizedBox(
                  height: 30,
                ),
              if (_currentPage == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          _completeOnboarding();
                          context.go(homePagePath);
                        },
                        child: Text(
                          "Skip",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(color: context.primary),
                        )),
                  ],
                ),
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      controller: _pageController,
                      children: [OnBoardingOne(), OnBoardingTwo()],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: WormEffect(
                      dotWidth: 40,
                      dotHeight: 10,
                      dotColor: Colors.white.withOpacity(0.3),
                      activeDotColor:
                          context.colorScheme.primary.withOpacity(0.8),
                    ),
                    onDotClicked: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pageCount - 1) {
                        setState(() {
                          _currentPage++;
                        });
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                        context.go(homePagePath);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.primary,
                    ),
                    child: Text(
                      "Next",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: context.colorScheme.surface),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeOnboarding() async {
    await onBoarding.put('isOnboardingShown', true);
  }
}
