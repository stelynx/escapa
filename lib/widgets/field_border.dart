import 'package:flutter/material.dart';

import '../models/field_border.dart';

class FieldBorderWidget extends StatelessWidget {
  final FieldBorder border;

  const FieldBorderWidget({
    Key? key,
    required this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: border.position.dx,
      top: border.position.dy,
      child: Container(
        width: border.size,
        height: border.size,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: border.width,
          ),
        ),
      ),
    );
  }
}
