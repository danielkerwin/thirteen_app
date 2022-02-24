import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameCardItem extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const GameCardItem({
    Key? key,
    required this.label,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      width: 130,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
        color: color,
        border: Border.all(color: Colors.white, width: 0.8),
        boxShadow: const [
          BoxShadow(blurRadius: 2.0),
        ],
      ),
      child: Card(
        elevation: 15,
        color: Colors.grey[350],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      ),
                      FaIcon(
                        icon,
                        color: color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
