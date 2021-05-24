import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/game_bloc.dart';
import '../models/enemy.dart';
import '../widgets/action_button.dart';
import '../widgets/enemy.dart';
import '../widgets/field_border.dart';
import '../widgets/game_over_popup.dart';
import '../widgets/player.dart';
import '../widgets/timer.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        GameBloc.changeScreenOrientation(context, orientation);

        return BlocBuilder<GameBloc, GameState>(
          builder: (BuildContext context, GameState state) {
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  // Border
                  FieldBorderWidget(border: state.border),
                  // Enemies
                  ...state.enemies.map<EnemyWidget>((Enemy enemy) {
                    return EnemyWidget(enemy: enemy);
                  }),
                  // Timer
                  TimerDisplay(state: state),
                  if (state.gameStatus == GameStatus.initial &&
                      MediaQuery.of(context).orientation ==
                          Orientation.landscape)
                    // Change timer position button
                    ActionButton(
                      state: state,
                      icon: CupertinoIcons.timer,
                      onPressed: () => GameBloc.toggleTimerPosition(context),
                    )
                  else if (state.gameStatus == GameStatus.gameOver)
                    // New game button
                    ActionButton(
                      state: state,
                      onPressed: () => GameBloc.restartGame(context),
                      icon: CupertinoIcons.restart,
                    ),
                  // Player
                  PlayerWidget(
                    player: state.player,
                    onMove: (Offset position) =>
                        GameBloc.addPosition(context, position),
                    startDrag: () =>
                        GameBloc.changeIsPlayerDragging(context, true),
                    cancelDrag: () =>
                        GameBloc.changeIsPlayerDragging(context, false),
                    isBeingDragged: state.isPlayerDragging,
                    isDraggable: state.gameStatus != GameStatus.gameOver,
                  ),
                  // Game over popup
                  if (state.gameStatus == GameStatus.gameOver)
                    GameOverPopup(
                      state: state,
                      personalBest: GameBloc.getPersonalBest(context),
                      globalBest: GameBloc.globalBest(context),
                      playerRank: GameBloc.playerRank(context),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
