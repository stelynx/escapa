import 'package:flutter/widgets.dart';

class Enemy {
  /// The top-left corner.
  Offset position;

  /// The width of the enemy.
  final double width;

  /// The height of the enemy.
  final double height;

  /// Displacement over delta time.
  Offset step;

  Enemy({
    required this.position,
    required this.width,
    required this.height,
    required this.step,
  });
}
