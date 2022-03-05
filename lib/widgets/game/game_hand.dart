import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/audio.constant.dart';
import '../../helpers/helpers.dart';
import '../../providers/providers.dart';
import '../../models/game.model.dart';
import '../../models/game_card.model.dart';
import '../main/loading.dart';
import 'game_card_item.dart';

class GameHand extends ConsumerStatefulWidget {
  final Game game;

  const GameHand({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  _GameHandState createState() => _GameHandState();
}

class _GameHandState extends ConsumerState<GameHand> {
  final Set<GameCard> _selectedCards = {};
  bool _isLoading = false;

  void _toggleCardSelection(GameCard card) async {
    final audio = ref.read(audioProvider);
    audio.play(Audio.selectCard);
    setState(() {
      if (_selectedCards.contains(card)) {
        _selectedCards.remove(card);
      } else {
        _selectedCards.add(card);
      }
    });
  }

  void _playSelectedCards() async {
    final audio = ref.read(audioProvider);
    if (_selectedCards.isEmpty) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    if (!widget.game.isActivePlayer) {
      final activePlayer = widget.game.activePlayerName;
      audio.play(Audio.playCardError);
      messenger.showSnackBar(
        Helpers.getSnackBar(
          'You\'re not the active player - it\'s $activePlayer\'s turn',
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final cardsToPlay = _selectedCards.toList();

    try {
      await ref.read(databaseProvider)!.playHand(widget.game.id, cardsToPlay);
      audio.play(Audio.playCardSuccess);
      setState(() {
        _selectedCards.clear();
      });
    } on FirebaseFunctionsException catch (err) {
      audio.play(Audio.playCardError);
      messenger.showSnackBar(
        Helpers.getSnackBar(err.message ?? 'Failed to play hand'),
      );
    } catch (err) {
      audio.play(Audio.playCardError);
      messenger.showSnackBar(
        Helpers.getSnackBar('Unknown error occurred'),
      );
    }
    setState(() => _isLoading = false);
  }

  void _skipRound() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    var message = 'You\'ve skipped this round';

    if (!widget.game.isActivePlayer) {
      final activePlayer = widget.game.activePlayerName;
      message = 'You\'re not the active player - it\'s $activePlayer\'s turn';
      messenger.showSnackBar(Helpers.getSnackBar(message));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(databaseProvider)!.skipRound(widget.game.id);
      messenger.showSnackBar(Helpers.getSnackBar(message));
    } on FirebaseFunctionsException catch (err) {
      message = err.message ?? 'Failed to skip round';
      messenger.showSnackBar(Helpers.getSnackBar(message));
    } catch (err) {
      message = 'Unknown error';
      messenger.showSnackBar(Helpers.getSnackBar(message));
    }

    setState(() => _isLoading = false);
  }

  Widget _buildCard({
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
          onVerticalDragEnd: (_) => _playSelectedCards(),
          onTap: () => _toggleCardSelection(pickedCard),
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
    List<GameCard> cards,
    BuildContext context,
    MediaQueryData mediaQuery,
  ) {
    final rotation = mediaQuery.orientation;
    final deviceSize = mediaQuery.size;

    final size = deviceSize.width;
    final totalCards = cards.length;
    const leftStart = 30;
    const rotationStart = -0.55;
    final rotationModifier = ((rotationStart * 2) / totalCards).abs();
    var bottom = rotation == Orientation.landscape ? -100.0 : 20.0;
    const bottomModifier = 3.5;

    return List.generate(totalCards, (index) {
      final isHalfWay = index >= totalCards / 2;
      bottom = isHalfWay ? bottom - bottomModifier : bottom + bottomModifier;
      return _buildCard(
        context: context,
        pickedCard: cards[index],
        left: leftStart + (index * ((size - leftStart * 3) / totalCards)),
        bottom: bottom,
        rotation: rotationStart + (index * rotationModifier),
        isSelected: _selectedCards.contains(cards[index]),
      );
    });
  }

  void _unselectCards() {
    setState(() {
      _selectedCards.clear();
    });
  }

  bool _canSkip() {
    return widget.game.isActivePlayer &&
        !widget.game.isSkippedRound &&
        !_isLoading &&
        widget.game.isActive &&
        widget.game.turn != 1;
  }

  bool _canPlay() {
    return _selectedCards.isNotEmpty && !_isLoading && widget.game.isActive;
  }

  @override
  Widget build(BuildContext context) {
    print('Building game_hand');
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final gameHandAsync = ref.watch(playerHandProvider(widget.game.id));
    return gameHandAsync.when(
      error: (err, stack) => const Center(
        child: Text('Error'),
      ),
      loading: () => const Loading(),
      data: (gameHand) => Column(
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
                      gameHand.cards,
                      context,
                      mediaQuery,
                    ),
                  ),
                ),
                if (_isLoading)
                  CircularProgressIndicator.adaptive(
                    backgroundColor: theme.primaryColor,
                  )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _canSkip() ? () => _skipRound() : null,
                child: const Text('Skip'),
                style: ElevatedButton.styleFrom(
                  primary: theme.colorScheme.secondary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _canPlay() ? () => _playSelectedCards() : null,
                    child: Text('Play ${_selectedCards.length} selected'),
                    style: ElevatedButton.styleFrom(
                        // primary: theme.primaryColor,
                        ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _selectedCards.isEmpty || _isLoading
                    ? null
                    : _unselectCards,
                child: const Text('Unselect'),
                style: ElevatedButton.styleFrom(
                  primary: theme.colorScheme.secondary,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
