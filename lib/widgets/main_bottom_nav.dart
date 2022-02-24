import 'package:flutter/material.dart';

class MainBottomNav extends StatelessWidget {
  const MainBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      onTap: null,
      backgroundColor: theme.primaryColor,
      unselectedItemColor: theme.primaryColorLight,
      selectedItemColor: theme.colorScheme.onSecondary,
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.gamepad_outlined),
          label: 'Current game',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Games list',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.score),
          label: 'Scoreboard',
        ),
      ],
    );
  }
}
