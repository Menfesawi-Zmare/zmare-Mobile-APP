import 'package:flutter/material.dart';

Color darken(Color color, [double amount = .1]) {
  return HSLColor.fromColor(color).withLightness(0.2).toColor();
}

Color lighten(Color color, [double amount = .1]) {
  return HSLColor.fromColor(color).withLightness(0.7).toColor();
}