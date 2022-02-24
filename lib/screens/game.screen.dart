import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_card.model.dart';
import '../providers/ui.provider.dart';
import '../widgets/game_card_item.dart';

class GameScreen extends StatefulWidget {
  final List<GameCard> cards;

  const GameScreen({
    Key? key,
    required this.cards,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<GameCard> _cards = [];

  @override
  void initState() {
    super.initState();
    // pick 13 cards
    final cardsToPickFrom = [...widget.cards];
    _cards = List.generate(13, (idx) {
      final random = Random();
      final randomIndex = random.nextInt(cardsToPickFrom.length);
      final pickedCard = cardsToPickFrom[randomIndex];
      cardsToPickFrom.removeAt(randomIndex);
      return pickedCard;
    });
  }

  void _sortCards() {
    _cards.sort((a, b) => a.value - b.value);
    setState(() {});
  }

  void _shuffleCards() {
    final cardsToShuffle = [...widget.cards];
    _cards = cardsToShuffle..shuffle();
  }

  Widget _buildCard(
    GameCard pickedCard,
    double left,
    double bottom,
    double rotation,
  ) {
    return Positioned(
      left: left,
      bottom: bottom,
      child: Transform(
        origin: const Offset(65, 100),
        transform: Matrix4.rotationZ(rotation),
        child: GestureDetector(
          onTap: () => print(pickedCard.label),
          child: GameCardItem(
            label: pickedCard.label,
            color: pickedCard.color,
            icon: pickedCard.icon,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardsLayout() {
    final query = MediaQuery.of(context);
    final rotation = query.orientation;
    final deviceSize = query.size;

    final size = deviceSize.width;

    const total = 13;
    final leftReduce = rotation == Orientation.landscape ? 280 : 100;
    final leftStart = leftReduce / 3;
    final leftModifier = (size - leftReduce) / total;
    const rotationStart = -0.55;
    final rotationModifier = rotationStart.abs() * 2 / total;
    var bottom = rotation == Orientation.landscape ? -100.0 : 20.0;
    const bottomModifier = 3.5;

    return List.generate(total, (index) {
      final isHalfWay = index >= total / 2;
      bottom = isHalfWay ? bottom - bottomModifier : bottom + bottomModifier;
      return _buildCard(
        _cards[index],
        leftStart + (index * leftModifier),
        bottom,
        rotationStart + (index * rotationModifier),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding game screen');

    final ui = Provider.of<UI>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        leading: IconButton(
          icon: Icon(ui.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => ui.toggleDarkMode(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0),
              Theme.of(context).primaryColorLight,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomLeft,
          children: _buildCardsLayout(),
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: _sortCards,
        icon: const Icon(Icons.swipe),
        color: Theme.of(context).primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      // persistentFooterButtons: [
      //   IconButton(
      //     onPressed: null,
      //     icon: const Icon(Icons.shuffle),
      //     color: Theme.of(context).primaryColor,
      //   ),
      //   IconButton(
      //     onPressed: _sortCards,
      //     icon: const Icon(Icons.swipe),
      //     color: Theme.of(context).primaryColor,
      //   )
      // ],
      bottomNavigationBar: BottomNavigationBar(
        onTap: null,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorLight,
        selectedItemColor: Theme.of(context).colorScheme.onSecondary,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.gamepad),
            label: 'Current game',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.history),
            label: 'Games list',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.score),
            label: 'Scoreboard',
          ),
        ],
      ),
    );
  }
}
