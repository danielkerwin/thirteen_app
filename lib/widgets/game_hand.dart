import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_card.model.dart';
import '../providers/game.provider.dart';
import 'game_card_item.dart';

class GameHand extends StatelessWidget {
  const GameHand({Key? key}) : super(key: key);

  Widget _buildCard({
    required BuildContext context,
    required GameCard pickedCard,
    required double left,
    required double bottom,
    required double rotation,
    bool isSelected = false,
  }) {
    return Positioned(
      left: left,
      bottom: isSelected ? bottom + 50 : bottom,
      child: Transform(
        origin: const Offset(65, 100),
        transform: Matrix4.rotationZ(rotation),
        child: GestureDetector(
          onVerticalDragEnd: (_) =>
              Provider.of<Game>(context, listen: false).playSelectedCards(),
          onTap: () => Provider.of<Game>(context, listen: false)
              .toggleCardSelection(pickedCard.id),
          child: GameCardItem(
            key: ValueKey(pickedCard.id),
            label: pickedCard.label,
            color: pickedCard.color,
            icon: pickedCard.icon,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardsLayout(
    BuildContext context,
    MediaQueryData mediaQuery,
    List<GameCard> cards,
    Set<String> selectedCards,
  ) {
    final rotation = mediaQuery.orientation;
    final deviceSize = mediaQuery.size;

    final size = deviceSize.width;

    final total = cards.length;
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
        context: context,
        pickedCard: cards[index],
        left: leftStart + (index * leftModifier),
        bottom: bottom,
        rotation: rotationStart + (index * rotationModifier),
        isSelected: selectedCards.contains(cards[index].id),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building game_hand');
    final mediaQuery = MediaQuery.of(context);
    final game = Provider.of<Game>(context);
    if (game.cardsInHand.isEmpty) {
      return Center(
        child: ElevatedButton(
          child: const Text('Deal new hand...'),
          onPressed: Provider.of<Game>(context).generateNewCards,
        ),
      );
    }
    return Stack(
      children: _buildCardsLayout(
        context,
        mediaQuery,
        game.cardsInHand,
        game.selectedCards,
      ),
    );
  }
}
