import 'package:flutter/material.dart';

import '../../models/game_card.model.dart';
import '../../services/database.service.dart';
import 'game_card_item.dart';

class GameHandCards extends StatefulWidget {
  final String gameId;
  final List<GameCard> cards;

  const GameHandCards({Key? key, required this.gameId, required this.cards})
      : super(key: key);

  @override
  _GameHandCardsState createState() => _GameHandCardsState();
}

class _GameHandCardsState extends State<GameHandCards> {
  final List<GameCard> _cardsInHand = [];
  final Set<String> _selectedCards = {};
  bool _isLoading = false;

  void _toggleCardSelection(String id) {
    setState(() {
      if (_selectedCards.contains(id)) {
        _selectedCards.remove(id);
      } else {
        _selectedCards.add(id);
      }
    });
  }

  void _playSelectedCards() async {
    if (_selectedCards.isEmpty) {
      return;
    }
    setState(() => _isLoading = true);
    final cardsToPlay =
        _cardsInHand.where((card) => _selectedCards.contains(card.id)).toList();
    await DatabaseService.playHand(widget.gameId, cardsToPlay);
    setState(() {
      _cardsInHand.removeWhere((card) => _selectedCards.contains(card.id));
      _selectedCards.clear();
      setState(() => _isLoading = false);
    });
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
          onTap: () => _toggleCardSelection(pickedCard.id),
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
  ) {
    final rotation = mediaQuery.orientation;
    final deviceSize = mediaQuery.size;

    final size = deviceSize.width;

    final total = _cardsInHand.length;
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
        pickedCard: _cardsInHand[index],
        left: leftStart + (index * leftModifier),
        bottom: bottom,
        rotation: rotationStart + (index * rotationModifier),
        isSelected: _selectedCards.contains(_cardsInHand[index].id),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _cardsInHand.addAll(widget.cards);
    _cardsInHand.sort(
      (a, b) {
        if (a.value == b.value) {
          return a.suit.index - b.suit.index;
        }
        return a.value - b.value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building game_hand_cards');
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Opacity(
          opacity: _isLoading ? 0.2 : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: _buildCardsLayout(
              context,
              mediaQuery,
            ),
          ),
        ),
        if (_isLoading) const CircularProgressIndicator()
      ],
    );
  }
}
