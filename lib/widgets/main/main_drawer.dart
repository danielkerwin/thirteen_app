import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Thirteen!'),
          ),
          const ListTile(),
          const ListTile(),
          const ListTile(),
        ],
      ),
    );
  }
}
