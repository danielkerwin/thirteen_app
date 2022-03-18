import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thirteen_app/constants/game.constants.dart';
import 'package:thirteen_app/widgets/game/game_filter.dart';

import 'boilerplate.dart';

void main() {
  testWidgets('GameFilter is created', (WidgetTester tester) async {
    // final filter = MockFilter();

    const filters = GameFilters.active;
    await tester.pumpWidget(
      boilerplate(
        const Scaffold(
          body: GameFilter(filters: filters),
        ),
      ),
    );

    final radioFinder = find.byType(Radio<GameFilters>);
    expect(radioFinder, findsWidgets);
  });
}
