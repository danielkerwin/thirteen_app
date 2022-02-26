import 'dart:math';

import 'package:flutter/material.dart';

import '../models/game_card.model.dart';

class Game with ChangeNotifier {
  // String? _id;
  List<GameCard> _cardsInHand = [];
  List<GameCard> _cardsOnTable = [];
  final Set<String> _selectedCardsInHand = {};

  List<GameCard> get cardsInHand {
    return [..._cardsInHand];
  }

  List<GameCard> get cardsOnTable {
    return [..._cardsOnTable];
  }

  get selectedCards {
    return {..._selectedCardsInHand};
  }

  set cardsInHand(List<GameCard> cards) {
    _cardsInHand = cards;
    // notifyListeners();
  }

  void toggleCardSelection(String id) {
    print('toggling card $id');
    if (_selectedCardsInHand.contains(id)) {
      _selectedCardsInHand.remove(id);
    } else {
      _selectedCardsInHand.add(id);
    }
    notifyListeners();
  }

  void clearSelectedCards() {
    print('clearing selected cards');

    _selectedCardsInHand.clear();
    notifyListeners();
  }

  void sortCards() {
    print('sorting cards');

    _cardsInHand.sort(
      (a, b) {
        final value = a.value - b.value;
        if (value == 0) {
          return a.suit.index - b.suit.index;
        }
        return value;
      },
    );
    notifyListeners();
  }

  void playSelectedCards() {
    print('playing selected cards');
    _cardsOnTable = _cardsInHand
        .where((card) => _selectedCardsInHand.contains(card.id))
        .toList();
    _cardsInHand.removeWhere((card) => _selectedCardsInHand.contains(card.id));
    _selectedCardsInHand.clear();
    notifyListeners();
  }
}
