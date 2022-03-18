import 'package:test/test.dart';
import 'package:thirteen_app/helpers/helpers.dart';
import 'package:thirteen_app/models/game_card.model.dart';

void main() {
  group('isSameValue', () {
    test('is same value', () {
      var cards1 = [
        GameCard(cardvalue: 3, suitValue: 1),
        GameCard(cardvalue: 3, suitValue: 2)
      ];
      var cards2 = [
        GameCard(cardvalue: 4, suitValue: 1),
        GameCard(cardvalue: 4, suitValue: 2),
        GameCard(cardvalue: 4, suitValue: 0),
        GameCard(cardvalue: 4, suitValue: 3),
      ];
      expect(Helpers.isSameValue(cards1), equals(true));
      expect(Helpers.isSameValue(cards2), equals(true));
    });

    test('is not same value', () {
      var cards1 = [
        GameCard(cardvalue: 4, suitValue: 1),
        GameCard(cardvalue: 3, suitValue: 2)
      ];
      var cards2 = [
        GameCard(cardvalue: 3, suitValue: 1),
        GameCard(cardvalue: 4, suitValue: 1),
        GameCard(cardvalue: 3, suitValue: 2)
      ];
      expect(Helpers.isSameValue(cards1), equals(false));
      expect(Helpers.isSameValue(cards2), equals(false));
    });
  });

  group('isSequence', () {
    test('is a sequence', () {
      var cards1 = [
        GameCard(cardvalue: 3, suitValue: 2),
        GameCard(cardvalue: 4, suitValue: 1),
        GameCard(cardvalue: 5, suitValue: 3),
      ];
      var cards2 = [
        GameCard(cardvalue: 5, suitValue: 1),
        GameCard(cardvalue: 6, suitValue: 2),
        GameCard(cardvalue: 7, suitValue: 2),
      ];
      expect(Helpers.isSequence(cards1), equals(true));
      expect(Helpers.isSequence(cards2), equals(true));
    });

    test('is not a sequence', () {
      var cards1 = [
        GameCard(cardvalue: 4, suitValue: 1),
        GameCard(cardvalue: 4, suitValue: 2)
      ];
      var cards2 = [
        GameCard(cardvalue: 3, suitValue: 2),
        GameCard(cardvalue: 4, suitValue: 1),
      ];
      var cards3 = [
        GameCard(cardvalue: 6, suitValue: 1),
        GameCard(cardvalue: 6, suitValue: 2),
        GameCard(cardvalue: 6, suitValue: 3),
        GameCard(cardvalue: 6, suitValue: 0)
      ];
      var cards4 = [
        GameCard(cardvalue: 4, suitValue: 1),
        GameCard(cardvalue: 3, suitValue: 2),
        GameCard(cardvalue: 5, suitValue: 3),
      ];
      expect(Helpers.isSequence(cards1), equals(false));
      expect(Helpers.isSequence(cards2), equals(false));
      expect(Helpers.isSequence(cards3), equals(false));
      expect(Helpers.isSequence(cards4), equals(false));
    });
  });
}
