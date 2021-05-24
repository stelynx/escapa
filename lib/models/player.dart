import 'package:flutter/widgets.dart';

import 'enemy.dart';
import 'field_border.dart';

class Player {
  /// The center of the box.
  Offset position;

  /// Width and height of the player.
  final double size;

  Player({
    required this.position,
    required this.size,
  });

  Offset get topLeft => Offset(position.dx - size / 2, position.dy - size / 2);
  Offset get botRight => Offset(position.dx + size / 2, position.dy + size / 2);

  bool collidesWithEnemy(Enemy enemy) {
    final Offset e1 = enemy.position;
    final Offset e2 = enemy.position + Offset(enemy.width, enemy.height);
    final Offset p1 = topLeft;
    final Offset p2 = botRight;
    return p1.dx < e2.dx && p2.dx > e1.dx && p1.dy < e2.dy && p2.dy > e1.dy;
  }

  bool collidesWithFieldBorder(FieldBorder border) {
    return topLeft.dx < border.position.dx + border.width ||
        topLeft.dy < border.position.dy + border.width ||
        botRight.dx > border.position.dx + border.size - border.width ||
        botRight.dy > border.position.dy + border.size - border.width;
  }
}
