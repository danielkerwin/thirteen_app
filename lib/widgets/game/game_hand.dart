import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/helpers.dart';
import '../../models/game.model.dart';
import '../../models/game_card.model.dart';
import '../../services/database.service.dart';
import 'game_card_item.dart';

class GameHand extends StatefulWidget {
  final String gameId;
  final List<GameCard> cards;

  const GameHand({
    Key? key,
    required this.gameId,
    required this.cards,
  }) : super(key: key);

  @override
  _GameHandState createState() => _GameHandState();
}

class _GameHandState extends State<GameHand> {
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

  void _playSelectedCards(Game game) async {
    if (_selectedCards.isEmpty || !game.isActivePlayer) {
      final activePlayer = game.activePlayerName;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        Helpers.getSnackBar(
          'You\'re not the active player - it\'s $activePlayer\'s turn',
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    final cardsToPlay =
        widget.cards.where((card) => _selectedCards.contains(card.id)).toList();

    try {
      await DatabaseService.playHand(widget.gameId, cardsToPlay);
      setState(() {
        // widget.cards.removeWhere((card) => _selectedCards.contains(card.id));
        _selectedCards.clear();
      });
    } on FirebaseFunctionsException catch (err) {
      messenger.showSnackBar(
        Helpers.getSnackBar(err.message ?? 'Failed to play hand'),
      );
    } catch (err) {
      messenger.showSnackBar(
        Helpers.getSnackBar('Unknown error occurred'),
      );
    }
    setState(() => _isLoading = false);
  }

  Widget _buildCard({
    required Game game,
    required BuildContext context,
    required GameCard pickedCard,
    required double left,
    required double bottom,
    required double rotation,
    bool isSelected = false,
  }) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInBack,
      left: left,
      bottom: isSelected ? bottom + 50 : bottom,
      child: Transform(
        origin: const Offset(65, 100),
        transform: Matrix4.rotationZ(rotation),
        child: GestureDetector(
          onVerticalDragEnd: (_) => _playSelectedCards(game),
          onTap: () => _toggleCardSelection(pickedCard.id),
          child: GameCardItem(
            key: ValueKey(pickedCard.id),
            label: pickedCard.label,
            color: pickedCard.color,
            icon: pickedCard.icon,
            selectedIcon: pickedCard.selectedIcon,
            isSelected: isSelected,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardsLayout(
    Game game,
    BuildContext context,
    MediaQueryData mediaQuery,
  ) {
    final rotation = mediaQuery.orientation;
    final deviceSize = mediaQuery.size;

    final size = deviceSize.width;
    final totalCards = widget.cards.length;
    const leftStart = 30;
    const rotationStart = -0.55;
    final rotationModifier = ((rotationStart * 2) / totalCards).abs();
    var bottom = rotation == Orientation.landscape ? -100.0 : 20.0;
    const bottomModifier = 3.5;

    return List.generate(totalCards, (index) {
      final isHalfWay = index >= totalCards / 2;
      bottom = isHalfWay ? bottom - bottomModifier : bottom + bottomModifier;
      return _buildCard(
        game: game,
        context: context,
        pickedCard: widget.cards[index],
        left: leftStart + (index * ((size - leftStart * 3) / totalCards)),
        bottom: bottom,
        rotation: rotationStart + (index * rotationModifier),
        isSelected: _selectedCards.contains(widget.cards[index].id),
      );
    });
  }

  _skipRound() {}

  void _unselectCards() {
    setState(() {
      _selectedCards.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building game_hand');
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final game = Provider.of<Game>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: _isLoading ? 0.8 : 1.0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildCardsLayout(
                    game,
                    context,
                    mediaQuery,
                  ),
                ),
              ),
              if (_isLoading)
                CircularProgressIndicator(
                  backgroundColor: theme.primaryColor,
                )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: game.isActivePlayer ? _skipRound : null,
              child: const Text('Skip'),
              style: ElevatedButton.styleFrom(
                primary: theme.colorScheme.secondary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _selectedCards.isEmpty || _isLoading
                      ? null
                      : () => _playSelectedCards(game),
                  child: Text('Play ${_selectedCards.length} selected'),
                  style: ElevatedButton.styleFrom(
                      // primary: theme.primaryColor,
                      ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed:
                  _selectedCards.isEmpty || _isLoading ? null : _unselectCards,
              child: const Text('Unselect'),
              style: ElevatedButton.styleFrom(
                primary: theme.colorScheme.secondary,
              ),
            ),
          ],
        )
      ],
    );
  }
}
