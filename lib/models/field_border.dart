import 'package:flutter/widgets.dart';

class FieldBorder {
  /// The top-left corner of the border.
  final Offset position;

  /// The width of the border line.
  final double width;

  /// The width and height of the border container.
  final double size;

  const FieldBorder({
    required this.position,
    required this.width,
    required this.size,
  });
}
