import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thirteen_app/widgets/game/game_card_item.dart';

import 'boilerplate.dart';

void main() {
  testWidgets('GameCardItem is created', (WidgetTester tester) async {
    await tester.pumpWidget(
      boilerplate(
        const GameCardItem(
          color: Colors.red,
          label: 'A',
          icon: Icons.abc,
          selectedIcon: Icons.abc_outlined,
        ),
      ),
    );

    final labelFinder = find.text('A');

    expect(labelFinder, findsWidgets);
  });
}
