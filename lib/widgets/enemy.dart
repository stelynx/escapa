import 'package:flutter/material.dart';

import '../models/enemy.dart';

class EnemyWidget extends StatelessWidget {
  /// The enemy object.
  final Enemy enemy;

  const EnemyWidget({
    Key? key,
    required this.enemy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: enemy.position.dx,
      top: enemy.position.dy,
      child: Container(
        width: enemy.width,
        height: enemy.height,
        color: Colors.blue,
      ),
    );
  }
}
