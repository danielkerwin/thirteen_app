import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';
  final paragraphs = const [
    {'text': 'Created with Flutter by Daniel Kerwin.', 'isTitle': false},
    {
      'text': 'About Thirteen',
      'isTitle': true,
    },
    {
      'isTitle': false,
      'text':
          'Thirteen (Tiến lên) is a shedding-style card game where the objective is to get rid of all of ones cards by playing various combinations.',
    },
    {
      'isTitle': false,
      'text':
          'The game is considered to be the national card game of Vietnam and also known as "Vietnamese cards", "Poison", "Killer 13", "Bomb", and "Hell".  The game is derived from Chinese card games "Winner" and "Big Two".',
    },
    {
      'isTitle': false,
      'text':
          'The deck is dealt evenly between four players so that each player has 13 cards. When playing with 2 or 3 players, 13 cards are dealt to each player and the remaining cards are discarded.'
    },
    {
      'isTitle': true,
      'text': 'The following standard combinations can be played',
    },
    {
      'isTitle': false,
      'text':
          'Single ("loner", "solo"): A single card. Singles can be beaten by singles that are higher in rank.'
    },
    {
      'isTitle': false,
      'text':
          'Pair ("double", "dubs"): A combination of exactly 2 cards of the same rank (e.g. 4♥ 4♣). A pair can only be beaten by a higher-ranking pair (e.g. 8♦ 8♠ beats 5♥ 5♦). The rank of a pair is determined by the highest-ranking card. For example, 9♣ 9♦ can be beaten by 9♠ 9♥ because 9♥ ranks higher than 9♦.'
    },
    {
      'isTitle': false,
      'text':
          'Triple ("trio", "trips", "three-of-a-kind"): A combination of exactly three cards of the same rank (e.g. K♠ K♣ K♥). A triple can only be beaten by a higher-ranking triple. For example, to beat 4♥ 4♦ 4♣, a player would need 5♠ 5♣ 5♦ or higher.'
    },
    {
      'isTitle': false,
      'text':
          'Run ("sequence", "straight"): A combination of at least three cards that are in a numerical sequence (e.g. 5♠ 6♥ 7♥ 8♣). The cards can be of any suit. The highest possible ending card in a run is an Ace, and the lowest beginning card is a 3. 2s cannot be played in runs. A run can only be beaten by a higher-ranking run (e.g. 10♠ J♦ Q♥ beats 8♠ 9♦ 10♠). As with pairs, the rank of a run is determined by the highest-ranking card. For example, 7♥ 8♦ 9♣ can be beaten by 7♠ 8♣ 9♥ because 9♥ ranks higher than 9♣.'
    },
    {'isTitle': true, 'text': 'Playing the game'},
    {
      'isTitle': false,
      'text':
          'The player who has the 3♠ starts the game (or the player with the lowest card in a 2 or 3 player game). The 3♠ (or lowest card) must be part of the first play, either on its own or as part of a combination.'
    },
    {'isTitle': false, 'text': 'Play moves anti clockwise to the next player.'},
    {
      'isTitle': false,
      'text':
          'During a turn, a player can choose to pass. A player who has passed cannot reenter the game until all the remaining players have passed.'
    },
    {
      'isTitle': false,
      'text':
          'When a player plays a combination and everyone else passes, he or she has control and can play any legal combination.'
    },
    {
      'isTitle': false,
      'text':
          'The first person to shed all thirteen cards is declared the winner. The game continues until all players but one have gone out.'
    },
  ];

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About',
          style: TextStyle(fontFamily: 'LuckiestGuy'),
        ),
      ),
      body: ListView(
        children: paragraphs
            .map(
              (item) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item['text'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: item['isTitle'] as bool
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
