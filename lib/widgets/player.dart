import 'package:flutter/material.dart';

import '../models/player.dart';

typedef MoveNotifier = void Function(Offset);

class PlayerWidget extends StatelessWidget {
  /// The player object.
  final Player player;

  /// Function called on when a player moves.
  final MoveNotifier onMove;

  /// Function used to notify the logic when a player starts dragging.
  final VoidCallback startDrag;

  /// Function used to notify the logic when a player stops dragging.
  final VoidCallback cancelDrag;

  /// Is player currently being dragged?
  final bool isBeingDragged;

  /// Whether a box can be dragged. When game is over, it should not be.
  final bool isDraggable;

  const PlayerWidget({
    Key? key,
    required this.player,
    required this.onMove,
    required this.startDrag,
    required this.cancelDrag,
    required this.isBeingDragged,
    required this.isDraggable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget playerWidget = Container(
      width: player.size,
      height: player.size,
      color: Colors.red,
    );

    if (isDraggable) {
      playerWidget = Draggable(
        child: playerWidget,
        feedback: !isBeingDragged ? Container() : playerWidget,
        onDragStarted: startDrag,
        onDragUpdate: (DragUpdateDetails details) {
          onMove(details.globalPosition);
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          cancelDrag();
          // onMove(position);
        },
        onDragEnd: (DraggableDetails details) {
          cancelDrag();
          // onMove(position);
        },
      );
    }

    return Positioned(
      left: player.position.dx - player.size / 2,
      top: player.position.dy - player.size / 2,
      child: playerWidget,
    );
  }
}
