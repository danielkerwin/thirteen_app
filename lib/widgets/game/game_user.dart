import 'package:flutter/material.dart';

class GameUser extends StatelessWidget {
  final String nickname;
  final int cards;
  final bool isActive;

  const GameUser({
    Key? key,
    required this.nickname,
    required this.cards,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: SizedBox(
        height: 55,
        child: Card(
          elevation: 2,
          color: isActive ? Theme.of(context).colorScheme.secondary : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  nickname,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isActive ? theme.colorScheme.onSecondary : null,
                  ),
                ),
              ),
              Text(
                '$cards cards',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? theme.colorScheme.onSecondary : null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
