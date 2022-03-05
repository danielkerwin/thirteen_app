import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GameStatus {
  created,
  active,
  complete,
}

enum GameCardSuit {
  spade,
  club,
  diamond,
  heart,
}

extension GameCardSuitExtension on GameCardSuit {
  String get name => describeEnum(this);

  Color get color {
    switch (this) {
      case GameCardSuit.spade:
      case GameCardSuit.club:
        return Colors.black;
      case GameCardSuit.diamond:
      case GameCardSuit.heart:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case GameCardSuit.spade:
        return FontAwesomeIcons.lightSpade;
      case GameCardSuit.club:
        return FontAwesomeIcons.lightClub;
      case GameCardSuit.diamond:
        return FontAwesomeIcons.lightDiamond;
      case GameCardSuit.heart:
        return FontAwesomeIcons.lightHeart;
    }
  }

  IconData get selectedIcon {
    switch (this) {
      case GameCardSuit.spade:
        return FontAwesomeIcons.solidSpade;
      case GameCardSuit.club:
        return FontAwesomeIcons.solidClub;
      case GameCardSuit.diamond:
        return FontAwesomeIcons.solidDiamond;
      case GameCardSuit.heart:
        return FontAwesomeIcons.solidHeart;
    }
  }
}

final numberValues = List.generate(8, (index) => index);
final numberMap = numberValues.fold<Map<int, String>>({}, (prev, idx) {
  prev[idx + 1] = '${idx + 3}';
  return prev;
});

final gameCardValueMap = {
  ...numberMap,
  9: 'J',
  10: 'Q',
  11: 'K',
  12: 'A',
  13: '2',
};

enum GameMoveType {
  single,
  double,
  triple,
  quad,
  run,
}

extension GameMoveTypeExtension on GameMoveType {
  String get name => describeEnum(this);

  String description(int length) {
    switch (this) {
      case GameMoveType.single:
      case GameMoveType.double:
      case GameMoveType.triple:
      case GameMoveType.quad:
        return name;
      case GameMoveType.run:
        return '$length card run';
    }
  }
}
