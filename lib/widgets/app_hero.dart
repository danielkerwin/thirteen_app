import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'game_card_item.dart';

class AppHero extends StatelessWidget {
  const AppHero({Key? key}) : super(key: key);

  List<Widget> get _heroCards {
    const cards = [
      GameCardItem(
        label: '2',
        color: Colors.black,
        icon: FontAwesomeIcons.lightSpade,
      ),
      GameCardItem(
        label: '2',
        color: Colors.black,
        icon: FontAwesomeIcons.lightClub,
      ),
      GameCardItem(
        label: '2',
        color: Colors.red,
        icon: FontAwesomeIcons.lightDiamond,
      ),
      GameCardItem(
        label: '2',
        color: Colors.red,
        icon: FontAwesomeIcons.lightHeart,
      ),
    ];
    var item = 0;
    var rotation = 0.4;

    return cards.map(
      (card) {
        item += 1;
        return Positioned(
          bottom: -50,
          child: Transform(
            origin: const Offset(65, 200),
            transform: Matrix4.rotationZ(-1.0 + (rotation * item)),
            child: card,
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ..._heroCards,
              Center(
                child: Text(
                  'Thirteen!',
                  style: TextStyle(
                    fontSize: 50,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: 'LuckiestGuy',
                    shadows: const [
                      Shadow(blurRadius: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
