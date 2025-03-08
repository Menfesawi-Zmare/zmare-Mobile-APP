import 'package:flutter/material.dart';

class CustomOnboardingContainer extends StatelessWidget {
  const CustomOnboardingContainer(
      {super.key,
      required this.height,
      required this.width,
      required this.topRight,
      required this.topLeft,
      required this.bottomRight,
      required this.bottomLeft,
      required this.imgUrl});
  final double height;
  final double width;
  final double topRight;
  final double topLeft;
  final double bottomRight;
  final double bottomLeft;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeft),
              bottomRight: Radius.circular(bottomRight),
              topLeft: Radius.circular(topLeft),
              topRight: Radius.circular(topRight)),
          color: Colors.grey,
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(imgUrl))),
    );
  }
}
