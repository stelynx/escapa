import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../logic/game_bloc.dart';

class TimerDisplay extends StatelessWidget {
  final GameState state;

  const TimerDisplay({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int currentTime = DateTime.now().millisecondsSinceEpoch;
    final String time = (((state.endTimeInMs ?? currentTime) -
                (state.startTimeInMs ?? currentTime)) /
            1000)
        .toStringAsFixed(3);

    final bool vertical =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Positioned.fill(
      child: Align(
        alignment: vertical
            ? Alignment.topCenter
            : state.showTimerOnLeft
                ? Alignment.centerLeft
                : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(
            top: vertical ? state.border.position.dy / 2 : 0,
            left: !vertical && state.showTimerOnLeft
                ? state.border.position.dx / 6
                : 0,
            right: !vertical && !state.showTimerOnLeft
                ? state.border.position.dx / 6
                : 0,
          ),
          child: Text(
            time,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: state.border.width,
              fontWeight: FontWeight.w200,
              fontFamily: 'Courier',
            ),
          ),
        ),
      ),
    );
  }
}
