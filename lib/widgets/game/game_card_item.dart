import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameCardItem extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final IconData selectedIcon;
  final bool isSelected;

  const GameCardItem({
    Key? key,
    required this.label,
    required this.color,
    required this.icon,
    required this.selectedIcon,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.0),
      constraints: const BoxConstraints(maxHeight: 200, maxWidth: 130),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
        color: color,
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
        boxShadow: const [
          BoxShadow(blurRadius: 1.0),
        ],
      ),
      child: Card(
        elevation: 15,
        color: Colors.grey[350],
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Column(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FaIcon(
                        isSelected ? selectedIcon : icon,
                        color: color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: -25,
                    child: FaIcon(
                      icon,
                      color: color.withOpacity(0.3),
                      size: 150,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
