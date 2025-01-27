import 'package:flutter/material.dart';
import 'package:flutter_music_pro/src/utils/ext/common.dart';

enum GridType {
circular,
coloredCard,
card,
tinyCard,
squareCard;
int get toIndex {
    switch (this) {
      case GridType.circular:
        return 0;
      case GridType.coloredCard:
        return 1;
      case GridType.card:
        return 2;
      case GridType.tinyCard:
        return 3;
      case GridType.squareCard:
        return 4;
    }
  }

  String name(BuildContext context) {
    switch (this) {
      case GridType.circular:
        return context.loc.circular;
      case GridType.coloredCard:
        return context.loc.coloredCard;
      case GridType.card:
        return context.loc.card;
      case GridType.tinyCard:
        return context.loc.tinyCard;
      case GridType.squareCard:
        return context.loc.squareCard;
    }
  }
}