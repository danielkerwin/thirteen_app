import 'package:flutter/material.dart';

class GamePlayer extends StatelessWidget {
  final String nickname;
  final int cards;
  final bool isActive;
  final bool isMe;

  const GamePlayer({
    Key? key,
    required this.nickname,
    required this.cards,
    this.isActive = false,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor =
        isMe ? theme.colorScheme.primary : theme.colorScheme.secondary;
    // final activeTextColor =
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Card(
          color: isActive ? activeColor : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                child: Text(
                  isMe ? 'Me' : nickname,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
