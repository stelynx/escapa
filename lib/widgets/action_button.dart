import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../logic/game_bloc.dart';

class ActionButton extends StatelessWidget {
  final GameState state;
  final VoidCallback onPressed;
  final IconData icon;

  const ActionButton({
    Key? key,
    required this.state,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool vertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Positioned.fill(
      child: Align(
        alignment: vertical
            ? Alignment.bottomCenter
            : !state.showTimerOnLeft
                ? Alignment.centerLeft
                : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
            left: !vertical && !state.showTimerOnLeft
                ? state.border.position.dx / 3
                : 0,
            right: !vertical && state.showTimerOnLeft
                ? state.border.position.dx / 3
                : 0,
            bottom: vertical ? state.border.position.dy / 2 : 0,
          ),
          child: CupertinoButton(
            child: Icon(
              icon,
              size: state.border.width,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
