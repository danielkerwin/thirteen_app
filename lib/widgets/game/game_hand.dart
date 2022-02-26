import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game_card.model.dart';
import '../../providers/game.provider.dart';
import '../../services/database.service.dart';
import 'game_card_item.dart';

class GameHand extends StatefulWidget {
  final String gameId;
  final String userId;

  const GameHand({
    Key? key,
    required this.gameId,
    required this.userId,
  }) : super(key: key);

  @override
  State<GameHand> createState() => _GameHandState();
}

class _GameHandState extends State<GameHand> {
  final Map<String, GameCard> _selectedCards = {};

  void _toggleCardSelection(GameCard card) {
    print('toggling card ${card.id}');
    if (_selectedCards.containsKey(card.id)) {
      _selectedCards.remove(card.id);
    } else {
      _selectedCards.addAll({card.id: card});
    }
  }

  void _playSelectedCards() {
    print('playing selected cards');
    DatabaseService.playHand(
      widget.gameId,
      _selectedCards.entries.map((card) {
        return {
          'value': card.value.value,
          'suit': card.value.suit,
        };
      }).toList(),
    );
    _selectedCards.clear();
  }

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
          onVerticalDragEnd: (_) => _playSelectedCards(),
          onTap: () => _toggleCardSelection(pickedCard),
          child: GameCardItem(
            key: ValueKey(pickedCard.id),
            label: pickedCard.label,
            color: pickedCard.color,
            icon: pickedCard.icon,
            isSelected: isSelected,
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
    final rotationModifier = ((rotationStart * 2) / total).abs();
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

    return StreamBuilder<DocStream>(
      stream: DatabaseService.getPlayerStream(widget.gameId, widget.userId),
      builder: (context, playerStream) {
        if (playerStream.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (!playerStream.data!.exists) {
          return const Center(
            child: Text('Waiting for game to start...'),
          );
        }

        final data = playerStream.data!.data() as Map<String, dynamic>;
        final cards = data['cards'] as List<dynamic>;

        final gameCards = cards.map((card) {
          return GameCard(
            cardvalue: card['value'],
            suitValue: card['suit'],
          );
        }).toList();

        Provider.of<Game>(context, listen: false).cardsInHand = gameCards;

        return Consumer<Game>(
          builder: (_, game, __) => Stack(
            clipBehavior: Clip.none,
            children: _buildCardsLayout(
              context,
              mediaQuery,
              game.cardsInHand,
              game.selectedCards,
            ),
          ),
        );
      },
    );
  }
}
