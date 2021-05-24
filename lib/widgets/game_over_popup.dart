import 'package:flutter/material.dart';

import '../logic/game_bloc.dart';

class GameOverPopup extends StatelessWidget {
  final GameState state;
  final int personalBest;
  final int globalBest;
  final int playerRank;

  const GameOverPopup({
    Key? key,
    required this.state,
    required this.personalBest,
    required this.globalBest,
    required this.playerRank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalTime = state.endTimeInMs! - state.startTimeInMs!;
    final String message;
    if (totalTime < 1000) {
      message = 'You can do better than this!';
    } else if (totalTime < 5000) {
      message = 'Off to a great start! What happened?';
    } else if (totalTime < 10000) {
      message = 'Not bad, not bad indeed.';
    } else if (totalTime < 15000) {
      message = 'Impressive!';
    } else if (totalTime < 120000) {
      message = 'You are a genius!';
    } else {
      message = 'You are a born US Air Force pilot!';
    }

    return Positioned(
      left: state.border.position.dx,
      top: state.border.position.dy,
      child: Container(
        width: state.border.size,
        height: state.border.size,
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.97),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Game Over'.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Courier',
                fontSize: state.border.width,
                fontWeight: FontWeight.w200,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: state.border.width * 1.2),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: state.border.width / 2,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                _scoreRow('Personal Best',
                    '${(personalBest / 1000).toStringAsFixed(3)} sec'),
                _scoreRow('Global Best',
                    '${(globalBest / 1000).toStringAsFixed(3)} sec'),
                _scoreRow('Rank', playerRank.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreRow(String text, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: state.border.width * 1.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: state.border.width / 3,
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Courier',
              fontSize: state.border.width * 2 / 5,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
