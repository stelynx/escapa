import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';
import '../models/enemy.dart';
import '../models/field_border.dart';
import '../models/player.dart';
import '../models/rank_score.dart';
import '../utility.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final SharedPreferences sharedPreferences;
  Size screenSize;
  RankScore _rankScore;

  GameBloc({
    required this.sharedPreferences,
    required this.screenSize,
    required Orientation screenOrientation,
    required RankScore rankScore,
  })  : _rankScore = rankScore,
        super(GameState.initial(
          screenSize: screenSize,
          screenOrientation: screenOrientation,
        ));

  static void addPosition(BuildContext context, Offset position) {
    BlocProvider.of<GameBloc>(context, listen: false)
        .add(UpdatePlayerPosition(position));
  }

  static void changeIsPlayerDragging(BuildContext context, bool value) {
    BlocProvider.of<GameBloc>(context, listen: false)
        .add(UpdateIsPlayerDragging(value));
  }

  static void toggleTimerPosition(BuildContext context) {
    BlocProvider.of<GameBloc>(context, listen: false)
        .add(const ToggleTimerPosition());
  }

  static void restartGame(BuildContext context) {
    BlocProvider.of<GameBloc>(context, listen: false).add(const RestartGame());
  }

  static int getPersonalBest(BuildContext context) {
    return BlocProvider.of<GameBloc>(context, listen: false)
            .sharedPreferences
            .getInt(Config.sharedPreferencesScoreKey) ??
        0;
  }

  static void changeScreenOrientation(
    BuildContext context,
    Orientation orientation,
  ) {
    BlocProvider.of<GameBloc>(context, listen: false)
        .add(OrientationChanged(orientation));
  }

  int get personalBest =>
      sharedPreferences.getInt(Config.sharedPreferencesScoreKey) ?? 0;
  set personalBest(int newBest) =>
      sharedPreferences.setInt(Config.sharedPreferencesScoreKey, newBest);

  static int globalBest(BuildContext context) {
    return BlocProvider.of<GameBloc>(context, listen: false)
        ._rankScore
        .globalBest;
  }

  static int playerRank(BuildContext context) {
    return BlocProvider.of<GameBloc>(context, listen: false)._rankScore.rank;
  }

  @override
  Stream<GameState> mapEventToState(
    GameEvent event,
  ) async* {
    if (event is MoveEnemies) {
      final int newTickCount = state.tickCount + 1;
      double newDeltaTime = state.deltaTime;
      if (newTickCount == 200) {
        newDeltaTime = Config.tickEveryMilliseconds / 60.0;
      } else if (newTickCount == 300) {
        newDeltaTime = Config.tickEveryMilliseconds / 40.0;
      } else if (newTickCount == 400) {
        newDeltaTime = Config.tickEveryMilliseconds / 30.0;
      } else if (newTickCount == 500) {
        newDeltaTime = Config.tickEveryMilliseconds / 20.0;
      } else if (newTickCount == 600) {
        newDeltaTime = Config.tickEveryMilliseconds / 10.0;
      }

      for (final Enemy enemy in state.enemies) {
        _moveEnemy(enemy);
      }

      if (_isGameOver()) {
        final int endTimeInMs = DateTime.now().millisecondsSinceEpoch;
        yield state.copyWith(
          endTimeInMs: endTimeInMs,
          isPlayerDragging: false,
          gameStatus: GameStatus.gameOver,
        );

        final int timePlayed = endTimeInMs - state.startTimeInMs!;
        if (timePlayed > personalBest) {
          personalBest = timePlayed;
          await _updateScoreOnServer(timePlayed);
        }

        _rankScore =
            await EscapaUtility.getPlayerRankAndGlobalBest(personalBest);
        yield state.copyWith();

        return;
      }

      yield state.copyWith(
        deltaTime: newDeltaTime,
        tickCount: newTickCount,
      );

      Timer(
        const Duration(milliseconds: Config.tickEveryMilliseconds),
        () => add(const MoveEnemies()),
      );
    } else if (event is UpdatePlayerPosition) {
      state.player.position = event.position;
      yield state.copyWith();
      if (_isGameOver()) {
        final int endTimeInMs = DateTime.now().millisecondsSinceEpoch;
        yield state.copyWith(
          endTimeInMs: endTimeInMs,
          isPlayerDragging: false,
          gameStatus: GameStatus.gameOver,
        );

        final int timePlayed = endTimeInMs - state.startTimeInMs!;
        if (timePlayed > personalBest) {
          personalBest = timePlayed;
          await _updateScoreOnServer(timePlayed);
        }

        _rankScore =
            await EscapaUtility.getPlayerRankAndGlobalBest(personalBest);
        yield state.copyWith();

        return;
      }
    } else if (event is UpdateIsPlayerDragging) {
      if (state.gameStatus == GameStatus.gameOver) return;

      if (state.gameStatus == GameStatus.initial) {
        add(const MoveEnemies());
        yield state.copyWith(
            startTimeInMs: DateTime.now().millisecondsSinceEpoch);
      }

      yield state.copyWith(
        isPlayerDragging: event.value,
        gameStatus: GameStatus.playing,
      );
    } else if (event is ToggleTimerPosition) {
      yield state.copyWith(showTimerOnLeft: !state.showTimerOnLeft);
    } else if (event is RestartGame) {
      yield GameState.initial(
        screenSize: screenSize,
        screenOrientation: state.screenOrientation,
        showTimerOnLeft: state.showTimerOnLeft,
      );
    } else if (event is OrientationChanged) {
      if (event.orientation == state.screenOrientation) return;

      // Change remembered screen size.
      screenSize = Size(screenSize.height, screenSize.width);

      final Offset fieldPosition = Offset(
        (screenSize.width - state.border.size) / 2,
        (screenSize.height - state.border.size) / 2,
      );

      // Translate border.
      final FieldBorder border = FieldBorder(
        position: fieldPosition,
        width: state.border.width,
        size: state.border.size,
      );

      // Translate player by calculating offset to center, moving it to center,
      // changing coordinates and offseting back.
      final Offset toCenter = state.player.position -
          Offset(screenSize.height / 2, screenSize.width / 2);
      final Player player = Player(
        position:
            Offset(screenSize.width / 2, screenSize.height / 2) + toCenter,
        size: state.border.size * 40.0 / 450.0,
      );

      // Translate enemies by calculating offset to top-left corner of border,
      // moving them there, changing coordinates and offsetting back.
      final List<Enemy> enemies = state.enemies.map<Enemy>((Enemy enemy) {
        final Offset toTopLeft = enemy.position - state.border.position;
        return Enemy(
          position: border.position + toTopLeft,
          width: enemy.width,
          height: enemy.height,
          step: enemy.step,
        );
      }).toList();

      yield state.copyWith(
        player: player,
        enemies: enemies,
        border: border,
        screenOrientation: event.orientation,
      );
    }
  }

  void _moveEnemy(Enemy enemy) {
    // Update position.
    enemy.position += enemy.step * state.deltaTime * state.border.size / 450.0;

    // If enemy is out of bounds, turn it around.
    if (enemy.position.dx <= state.border.position.dx ||
        enemy.position.dx + enemy.width >=
            state.border.position.dx + state.border.size) {
      enemy.step = Offset(-enemy.step.dx, enemy.step.dy);
    }
    if (enemy.position.dy <= state.border.position.dy ||
        enemy.position.dy + enemy.height >=
            state.border.position.dy + state.border.size) {
      enemy.step = Offset(enemy.step.dx, -enemy.step.dy);
    }
  }

  bool _isGameOver() {
    for (final Enemy enemy in state.enemies) {
      if (state.player.collidesWithEnemy(enemy)) {
        return true;
      }
    }

    return state.player.collidesWithFieldBorder(state.border);
  }

  Future<void> _updateScoreOnServer(int newScore) async {
    String? user =
        sharedPreferences.getString(Config.sharedPreferencesUserIdKey);

    if (user != null) {
      await FirebaseFirestore.instance
          .collection(Config.firestoreCollectionScore)
          .doc(user)
          .set({Config.firestoreCollectionScoreKey: newScore});
    } else {
      user = (await FirebaseFirestore.instance
              .collection(Config.firestoreCollectionScore)
              .add({Config.firestoreCollectionScoreKey: newScore}))
          .id;

      sharedPreferences.setString(Config.sharedPreferencesUserIdKey, user);
    }
  }
}
