import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GamePlayer extends StatelessWidget {
  final String nickname;
  final int cardCount;
  final int rank;
  final bool isActive;
  final bool isMe;
  final bool isSkipped;

  const GamePlayer({
    Key? key,
    required this.nickname,
    required this.cardCount,
    required this.rank,
    this.isActive = false,
    this.isMe = false,
    this.isSkipped = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor =
        isMe ? theme.colorScheme.primary : theme.colorScheme.secondary;
    final activeText = isActive ? theme.colorScheme.onSecondary : null;
    // final activeTextColor =
    return Expanded(
      child: SizedBox(
        height: 50,
        child: Card(
          shadowColor: isSkipped ? Colors.transparent : null,
          color: isSkipped
              ? theme.disabledColor.withOpacity(0.1)
              : isActive
                  ? activeColor
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (rank == 0) ...[
                          Icon(
                            FontAwesomeIcons.solidTrophyAlt,
                            color: isSkipped ? theme.disabledColor : activeText,
                            size: 15,
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          isMe ? 'Me' : nickname,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSkipped ? theme.disabledColor : activeText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '$cardCount cards',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSkipped ? theme.disabledColor : activeText,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
