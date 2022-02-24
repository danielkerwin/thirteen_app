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
      padding: const EdgeInsets.all(1.0),
      // width: 130,
      // height: 200,
      constraints: const BoxConstraints(maxHeight: 200, maxWidth: 130),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
        color: color,
        border: Border.all(color: Colors.white, width: 0.4),
        boxShadow: const [
          BoxShadow(blurRadius: 1.0),
        ],
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        elevation: 15,
        color: Colors.grey[350],
        child: Column(
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
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
                  fontSize: 80,
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
